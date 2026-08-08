# # Example 02 — Advanced: Variants, Rework, and Performance Analysis

# Cell 1 — Setup & Load

import os, warnings
import pm4py
import pandas as pd
import matplotlib.pyplot as plt
from collections import Counter
from IPython.display import display

warnings.filterwarnings("ignore")

OCEL_PATH  = r"../../data/BPIC19_sample.jsonocel"

os.getcwd()

ocel         = pm4py.read_ocel(OCEL_PATH)
obj_type_col = ocel.object_type_column
most_common_type = ocel.objects[obj_type_col].value_counts().index[0]

classic_log = pm4py.ocel_flattening(ocel, most_common_type)
df_full     = pm4py.convert_to_dataframe(classic_log)

print("Object type :", most_common_type)
print("Cases       :", len(classic_log))
print("Events      :", len(df_full))

# Cell 2 — Variant Analysis

variants = pm4py.get_variants(classic_log)
print("Total distinct variants:", len(variants))

sorted_variants = sorted(variants.items(), key=lambda x: x[1], reverse=True)

total_cases  = len(classic_log)
top10_cases  = sum(v[1] for v in sorted_variants[:10])
top20_cases  = sum(v[1] for v in sorted_variants[:20])

print(f"Top-10 variants cover : {top10_cases/total_cases:.1%} of all cases")
print(f"Top-20 variants cover : {top20_cases/total_cases:.1%} of all cases")


# Cell 3 — Fig 03: Variant Frequency Chart

top20  = sorted_variants[:20]
labels = [f"V{i+1}" for i in range(len(top20))]
counts = [v[1] for v in top20]

fig, ax = plt.subplots(figsize=(11, 5))
bars = ax.bar(labels, counts, color="coral", edgecolor="white")
ax.set_title("Top 20 Variants by Case Count")
ax.set_xlabel("Variant rank")
ax.set_ylabel("Number of cases")
ax.bar_label(bars, fmt="%d", fontsize=8, padding=2)
plt.tight_layout()
plt.show()

# Cell 4 — Throughput Time (with anomaly filtering)

df_full["time:timestamp"] = pd.to_datetime(
    df_full["time:timestamp"], utc=True, errors="coerce"
)

valid = df_full.groupby("case:concept:name").filter(lambda x: len(x) >= 2)

tt = (
    valid.groupby("case:concept:name")["time:timestamp"].max()
  - valid.groupby("case:concept:name")["time:timestamp"].min()
)
throughput_days_raw = tt.dt.total_seconds() / 86400

# Remove near-zero durations (< 15 min = 0.01 day) and top 1% outliers
p99 = throughput_days_raw.quantile(0.99)
throughput_days = throughput_days_raw[
    (throughput_days_raw > 0.01) &
    (throughput_days_raw <= p99)
]

removed = len(throughput_days_raw) - len(throughput_days)
print(f"Cases with >= 2 events (raw)         : {len(throughput_days_raw)}")
print(f"Cases after anomaly filter           : {len(throughput_days)}")
print(f"Removed (< 15 min or > P99={p99:.0f}d) : {removed}")
print(f"\nCleaned throughput stats:")
print(throughput_days.describe().round(2))


# Cell 5 — Fig 04: Throughput Time Histograms (raw and cleaned)

fig, axes = plt.subplots(1, 2, figsize=(14, 4))

# Left: raw (capped at 400 days for readability)
axes[0].hist(throughput_days_raw[throughput_days_raw <= 400].dropna(),
             bins=50, color="lightcoral", edgecolor="white")
axes[0].axvline(throughput_days_raw.median(), color="red", linestyle="--",
                label=f"Median: {throughput_days_raw.median():.1f}d")
axes[0].axvline(throughput_days_raw.mean(), color="orange", linestyle="--",
                label=f"Mean: {throughput_days_raw.mean():.1f}d")
axes[0].set_title("Raw (capped at 400 days)")
axes[0].set_xlabel("Days")
axes[0].set_ylabel("Number of cases")
axes[0].legend(fontsize=8)

# Right: cleaned
axes[1].hist(throughput_days.dropna(),
             bins=50, color="steelblue", edgecolor="white")
axes[1].axvline(throughput_days.median(), color="red", linestyle="--",
                label=f"Median: {throughput_days.median():.1f}d")
axes[1].axvline(throughput_days.mean(), color="orange", linestyle="--",
                label=f"Mean: {throughput_days.mean():.1f}d")
axes[1].set_title("Cleaned (zero & top 1% removed)")
axes[1].set_xlabel("Days")
axes[1].legend(fontsize=8)

plt.suptitle("Throughput Time Distribution — BPI Challenge 2019 (sample)", y=1.02)
plt.tight_layout()
plt.show()


# Cell 5b — Fig 04b: Cleaned throughput histogram only (standalone)

fig, ax = plt.subplots(figsize=(9, 4))
ax.hist(throughput_days.dropna(), bins=50, color="steelblue", edgecolor="white")
ax.axvline(throughput_days.median(), color="red", linestyle="--",
           label=f"Median: {throughput_days.median():.1f}d")
ax.axvline(throughput_days.mean(), color="orange", linestyle="--",
           label=f"Mean: {throughput_days.mean():.1f}d")
ax.set_title("Throughput Time Distribution (cleaned)")
ax.set_xlabel("Days")
ax.set_ylabel("Number of cases")
ax.legend()
plt.tight_layout()
plt.show()


# Cell 6 — Loop / Rework Detection (on full log, not filtered)

sample_cases = df_full["case:concept:name"].drop_duplicates().head(3000)
df_small     = df_full[df_full["case:concept:name"].isin(sample_cases)]

repeat_cases       = 0
repeat_act_counter = Counter()

for case_id, g in df_small.groupby("case:concept:name"):
    cnt = Counter(g["concept:name"].tolist())
    if any(v > 1 for v in cnt.values()):
        repeat_cases += 1
        for a, v in cnt.items():
            if v > 1:
                repeat_act_counter[a] += 1

rework_rate = repeat_cases / len(sample_cases)
print(f"Rework rate: {rework_rate:.1%}")
print("\nTop repeated activities:")
for act, count in repeat_act_counter.most_common(10):
    print(f"  {act}: {count} cases")


# Cell 7 — Fig 05: Rework Activity Chart

if repeat_act_counter:
    top_rework     = repeat_act_counter.most_common(10)
    acts_r, cnts_r = zip(*top_rework)

    fig, ax = plt.subplots(figsize=(10, 5))
    ax.barh(list(acts_r)[::-1], list(cnts_r)[::-1], color="salmon")
    ax.set_title(f"Top Repeated Activities  (Rework Rate: {rework_rate:.1%})")
    ax.set_xlabel("Number of cases with repeated activity")
    plt.tight_layout()
    plt.show()
else:
    print("No rework detected in sample.")

# Cell 8 — KPI Summary Table

summary = pd.DataFrame({
    "Metric": [
        "Total cases",
        "Total distinct variants",
        "Top-10 variant coverage",
        "Top-20 variant coverage",
        "Cases with >= 2 events (raw)",
        "Cases after anomaly filter",
        "Mean throughput (days)",
        "Median throughput (days)",
        "P95 throughput (days)",
        "Min throughput (days)",
        "Max throughput (days)",
        "Rework rate (sample 3000)"
    ],
    "Value": [
        len(classic_log),
        len(variants),
        f"{top10_cases/total_cases:.1%}",
        f"{top20_cases/total_cases:.1%}",
        len(throughput_days_raw),
        len(throughput_days),
        round(throughput_days.mean(), 2),
        round(throughput_days.median(), 2),
        round(throughput_days.quantile(0.95), 2),
        round(throughput_days.min(), 2),
        round(throughput_days.max(), 2),
        f"{rework_rate:.1%}"
    ]
})
display(summary)

# Cell 9 — Fig 06: Throughput Time by Document Type

doc_type_tt = (
    df_full[df_full["case:concept:name"].isin(valid["case:concept:name"])]
    .groupby("case:concept:name")
    .agg(
        doc_type=("cDocType", "first"),
        tt_days=("time:timestamp",
                 lambda x: (x.max() - x.min()).total_seconds() / 86400)
    )
    .reset_index()
)

print(doc_type_tt.groupby("doc_type")["tt_days"].describe().round(2))

fig, ax = plt.subplots(figsize=(9, 4))
doc_type_tt.boxplot(column="tt_days", by="doc_type", ax=ax)
ax.set_title("Throughput Time by Document Type")
ax.set_ylabel("Days")
plt.suptitle("")
plt.tight_layout()
plt.show()

