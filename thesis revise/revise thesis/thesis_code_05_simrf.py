import simpy, random, warnings
import numpy as np, pandas as pd, matplotlib.pyplot as plt, pm4py

warnings.filterwarnings("ignore")

ocel             = pm4py.read_ocel_json("BPIC19_sample.jsonocel")
obj_type_col     = ocel.object_type_column
most_common_type = ocel.objects[obj_type_col].value_counts().index[0]
classic_log      = pm4py.ocel_flattening(ocel, most_common_type)
n_train          = int(len(classic_log) * 0.70)
train_log        = classic_log[:n_train]
perf_dfg, _, _   = pm4py.discover_performance_dfg(train_log)

raw_times = {}
for (a, b), stats in perf_dfg.items():
    raw_times.setdefault(a, []).append(stats["median"] / 86400)
svc_mean = np.mean([np.mean(v) for v in raw_times.values()])
IAR, SIM_DURATION, SEED = 0.5, 365, 42

def run_simulation(n_apvrs, seed=SEED, dur=SIM_DURATION):
    rng  = random.Random(seed)
    env  = simpy.Environment()
    pool = simpy.Resource(env, capacity=n_apvrs)
    tt   = []
    def case(env):
        t = env.now
        with pool.request() as req:
            yield req
            yield env.timeout(max(0, rng.gauss(svc_mean, svc_mean * 0.3)))
        tt.append(env.now - t)
    def gen(env):
        while True:
            yield env.timeout(rng.expovariate(1 / IAR))
            env.process(case(env))
    env.process(gen(env))
    env.run(until=dur)
    return tt

approver_counts = [1, 2, 3, 4, 5, 6]
sim_data = [(n, run_simulation(n)) for n in approver_counts]
df_results = pd.DataFrame([{"approvers": n, "mean_tt": np.mean(t), "median_tt": np.median(t), "p95_tt": np.percentile(t, 95)} for n, t in sim_data])
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import roc_auc_score, roc_curve

df = pm4py.convert_to_dataframe(classic_log)
df["time:timestamp"] = pd.to_datetime(df["time:timestamp"], utc=True, errors="coerce")
tt = (df.groupby("case:concept:name")["time:timestamp"]
    .agg(lambda x: (x.max() - x.min()).total_seconds() / 86400))
case_features = (df.sort_values("time:timestamp")
    .groupby("case:concept:name").first().reset_index()
    .merge(tt.rename("throughput_days"), on="case:concept:name"))
case_features = case_features[case_features["throughput_days"] >= 0.01].copy()
case_features["slow"] = (case_features["throughput_days"] > 30).astype(int)

feature_cols = ["cCompany", "cDocType", "cGR", "cGRbasedInvVerif", "cItemCat", "cItemType"]
df_ml = case_features[feature_cols + ["slow"]].dropna().copy()
for col in feature_cols:
    df_ml[col] = LabelEncoder().fit_transform(df_ml[col].astype(str))
X, y = df_ml[feature_cols].values, df_ml["slow"].values
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42, stratify=y)
print(f"Training cases   : {len(X_train)}\nTest cases       : {len(X_test)}\nSlow cases (>30d): {y.mean():.1%}")

rf = RandomForestClassifier(n_estimators=100, random_state=42)
rf.fit(X_train, y_train)

y_proba = rf.predict_proba(X_test)[:, 1]
auc     = roc_auc_score(y_test, y_proba)
importances = pd.Series(
    rf.feature_importances_, index=feature_cols
).sort_values(ascending=False)

print(f"AUC-ROC: {auc:.4f}")
print("\nFeature importances:")
print(importances.round(4).to_string())

fig, axes = plt.subplots(1, 2, figsize=(13, 5))
axes[0].plot(df_results["approvers"], df_results["mean_tt"],   "o-",  color="steelblue", label="Mean")
axes[0].plot(df_results["approvers"], df_results["median_tt"], "s--", color="coral",     label="Median")
axes[0].plot(df_results["approvers"], df_results["p95_tt"],    "^:",  color="gray",      label="P95")
axes[0].axhline(36.77, color="green", linestyle="--", label="BPI 2019 mean (36.8d)")
axes[0].set_title("Throughput Time vs Number of Approvers")
axes[0].legend(); axes[0].set_xticks(approver_counts)
axes[1].hist(run_simulation(2), bins=40, alpha=0.6, color="coral",     label="2 approvers")
axes[1].hist(run_simulation(4), bins=40, alpha=0.6, color="steelblue", label="4 approvers")
axes[1].set_title("Throughput Distribution: 2 vs 4 Approvers")
plt.suptitle("SimPy Simulation -- P2P Process Optimization", fontsize=13)
plt.savefig("figs/fig_10_simulation.png", dpi=150); plt.show()

fig, axes = plt.subplots(1, 2, figsize=(13, 5))
importances.sort_values().plot(kind="barh", color="steelblue", ax=axes[0])
axes[0].set_title("Feature Importance -- Random Forest")
fpr, tpr, _ = roc_curve(y_test, y_proba)
axes[1].plot(fpr, tpr, color="steelblue", lw=2, label=f"AUC = {auc:.3f}")
axes[1].plot([0, 1], [0, 1], "k--"); axes[1].set_title("ROC Curve -- Slow Cases (>30d)")
plt.savefig("figs/fig_11_predictive_monitoring.png", dpi=150); plt.show()
