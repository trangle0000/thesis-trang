import os, shutil, warnings
import pm4py
import pandas as pd
import matplotlib.pyplot as plt

warnings.filterwarnings("ignore")

ocel             = pm4py.read_ocel_json("BPIC19_sample.jsonocel")
obj_type_col     = ocel.object_type_column
most_common_type = ocel.objects[obj_type_col].value_counts().index[0]
classic_log      = pm4py.ocel_flattening(ocel, most_common_type)
n_train          = int(len(classic_log) * 0.70)
train_log        = classic_log[:n_train]
net, im, fm      = pm4py.discover_petri_net_inductive(train_log)

perf_dfg, sa, ea = pm4py.discover_performance_dfg(train_log)

print(f"Number of arcs: {len(perf_dfg)}")
print("\nTop 10 slowest transitions (median days):")
sorted_perf = sorted(
    perf_dfg.items(), key=lambda x: x[1]["median"], reverse=True
)
for (a, b), stats in sorted_perf[:10]:
    days = stats["median"] / 86400
    print(f"  {a} -> {b}: {days:.1f} days")

dfg_activities = set()
for (a, b) in perf_dfg.keys():
    dfg_activities.add(a); dfg_activities.add(b)
sa_f = {k: v for k, v in sa.items() if k in dfg_activities}
ea_f = {k: v for k, v in ea.items() if k in dfg_activities}
pm4py.save_vis_performance_dfg(perf_dfg, sa_f, ea_f,
    "figs/fig_07_perf_dfg.png")

def classify_resource(r):
    if pd.isna(r) or str(r).upper() == "NONE":
        return "external"
    elif str(r).lower().startswith("batch"):
        return "automated"
    else:
        return "manual"

df_full = pm4py.convert_to_dataframe(classic_log)
df_full["time:timestamp"] = pd.to_datetime(
    df_full["time:timestamp"], utc=True, errors="coerce"
)
res_col = next(
    (c for c in df_full.columns if "resource" in c.lower()), None
)
df_full["resource_type"] = df_full[res_col].apply(classify_resource)
df_internal = df_full[df_full["resource_type"] != "external"]

auto_rate = (
    df_internal.groupby("concept:name")["resource_type"]
    .apply(lambda x: (x == "automated").sum() / len(x))
    .sort_values(ascending=True)
)
overall = (df_full["resource_type"] == "automated").sum() / len(df_full)
print(f"Overall automation rate: {overall:.1%}")

fig, ax = plt.subplots(figsize=(10, 6))
colors = ["steelblue" if v > 0.5 else "salmon" for v in auto_rate.values]
auto_rate.plot(kind="barh", color=colors, ax=ax)
ax.axvline(0.5, color="gray", linestyle="--", linewidth=1,
           label="50% threshold")
ax.set_title(f"Automation Rate per Activity  (Overall: {overall:.1%})")
ax.set_xlabel("Fraction of events executed by batch resources")
ax.legend()
plt.tight_layout()
plt.savefig("figs/fig_08_automation_rate.png", dpi=150)
plt.show()

rel = ocel.relations.copy()
rel["ocel:timestamp"] = pd.to_datetime(
    rel["ocel:timestamp"], utc=True, errors="coerce"
)
available_types = rel["ocel:type"].value_counts().index[:2].tolist()
print(f"Object types analysed: {available_types}")

results = {}
for otype in available_types:
    sub = (
        rel[rel["ocel:type"] == otype]
        .sort_values(["ocel:oid", "ocel:timestamp"])
        .copy()
    )
    sub["next_activity"] = (
        sub.groupby("ocel:oid")["ocel:activity"].shift(-1)
    )
    dfg = (
        sub.dropna(subset=["next_activity"])
        .groupby(["ocel:activity", "next_activity"])
        .size().reset_index(name="count")
        .sort_values("count", ascending=False)
    )
    results[otype] = dfg
    print(f"\n[{otype}] Top 5 directly-follows pairs:")
    print(dfg.head(5).to_string(index=False))

fig, axes = plt.subplots(1, 2, figsize=(14, 5))
for ax, (otype, dfg) in zip(axes, results.items()):
    top = dfg.head(10).copy()
    top["arc"] = (
        top["ocel:activity"].str[:20] + " ->\n"
        + top["next_activity"].str[:20]
    )
    top.sort_values("count").plot(
        kind="barh", x="arc", y="count",
        color="steelblue", legend=False, ax=ax
    )
    ax.set_title(f"Object-Centric DFG -- {otype}")
    ax.set_xlabel("Frequency")
    ax.set_ylabel("")
plt.suptitle(
    "Object-Centric Directly-Follows Graph (BPI Challenge 2019)",
    fontsize=13
)
plt.tight_layout()
plt.savefig("figs/fig_09_ocdfg.png", dpi=150)
plt.show()
