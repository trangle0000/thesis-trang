import pm4py
import pandas as pd
import matplotlib.pyplot as plt
from collections import Counter

ocel        = pm4py.read_ocel_json("BPIC19_sample.jsonocel")
classic_log = pm4py.ocel_flattening(ocel, "POItem")
df_full     = pm4py.convert_to_dataframe(classic_log)
df_full["time:timestamp"] = pd.to_datetime(
    df_full["time:timestamp"], utc=True, errors="coerce"
)
before  = df_full["case:concept:name"].nunique()
df_full = df_full[
    df_full["time:timestamp"] >= pd.Timestamp("2018-01-01", tz="UTC")
].copy()
print(f"Cases removed (before 2018-01-01): {before - df_full['case:concept:name'].nunique()}")
print(f"Cases      : {df_full['case:concept:name'].nunique():,}")
print(f"Events     : {len(df_full):,}")
print(f"Activities : {df_full['concept:name'].nunique()}")

filtered_log = pm4py.convert_to_event_log(df_full)
variants     = pm4py.get_variants(filtered_log)

def variant_count(v):
    return v[1] if isinstance(v[1], int) else len(v[1])

sorted_variants = sorted(variants.items(), key=variant_count, reverse=True)
total_cases     = df_full["case:concept:name"].nunique()
top10_cases     = sum(variant_count(v) for v in sorted_variants[:10])
top20_cases     = sum(variant_count(v) for v in sorted_variants[:20])

print(f"Distinct variants       : {len(sorted_variants)}")
cumulative = 0
for i, v in enumerate(sorted_variants[:20], 1):
    cumulative += variant_count(v)
    if i in (10, 20):
        print(f"Top-{i} variant coverage : {cumulative/total_cases:.1%}")

top10_dict   = dict(sorted_variants[:10])
filtered_sub = pm4py.filter_variants(filtered_log, top10_dict)

if len(filtered_sub) == 0:
    print("Warning: filtered log is empty --- flattening artifact detected.")
    print("Falling back to full log for downstream steps.")
    filtered_sub = filtered_log
else:
    print(f"Cases after top-10 filter: {len(filtered_sub)}")

sample_cases       = df_full["case:concept:name"].drop_duplicates().head(3000)
df_small           = df_full[df_full["case:concept:name"].isin(sample_cases)]
repeat_cases       = 0
repeat_act_counter = Counter()

for case_id, g in df_small.groupby("case:concept:name"):
    cnt = Counter(g["concept:name"].tolist())
    if any(v > 1 for v in cnt.values()):
        repeat_cases += 1
        for act, freq in cnt.items():
            if freq > 1:
                repeat_act_counter[act] += 1

rework_rate = repeat_cases / len(sample_cases)
print(f"Rework rate (sample): {rework_rate:.1%}")
print("Most repeated activities:")
for act, count in repeat_act_counter.most_common(6):
    print(f"  {act}: {count} cases")

if repeat_act_counter:
    top_rework     = repeat_act_counter.most_common(10)
    acts_r, cnts_r = zip(*top_rework)

    fig, ax = plt.subplots(figsize=(10, 5))
    ax.barh(list(acts_r)[::-1], list(cnts_r)[::-1], color="salmon",
            edgecolor="white")
    ax.set_title(f"Top Repeated Activities (Rework Rate: {rework_rate:.1%})")
    ax.set_xlabel("Number of cases with repeated activity")
    for i, v in enumerate(list(cnts_r)[::-1]):
        ax.text(v + 0.3, i, str(v), va="center", fontsize=8)
    plt.tight_layout()
    plt.savefig("figs/fig_05_rework.png", dpi=150)
    plt.show()

valid = df_full.groupby("case:concept:name").filter(lambda x: len(x) >= 2)
tt    = (
    valid.groupby("case:concept:name")["time:timestamp"].max()
  - valid.groupby("case:concept:name")["time:timestamp"].min()
)
tt_raw      = tt.dt.total_seconds() / 86400
p99         = tt_raw.quantile(0.99)
tt_filtered = tt_raw[(tt_raw > 0.01) & (tt_raw <= p99)]

print(f"Cases with >= 2 events (raw): {len(tt_raw)}")
print(f"Cases after anomaly filter  : {len(tt_filtered)}")
print(f"Mean throughput time        : {tt_filtered.mean():.2f} days")
print(f"Median throughput time      : {tt_filtered.median():.2f} days")
print(f"95th percentile             : {tt_filtered.quantile(0.95):.2f} days")
print(f"Min throughput time         : {tt_filtered.min():.2f} days")
print(f"Max throughput time         : {tt_filtered.max():.2f} days")

summary = pd.DataFrame({
    "Metric": [
        "Total cases", "Distinct variants",
        "Top-10 variant coverage", "Top-20 variant coverage",
        "Cases with >= 2 events (raw)", "Cases after anomaly filter",
        "Mean throughput (days)", "Median throughput (days)",
        "P95 throughput (days)", "Rework rate (sample 3,000 cases)"
    ],
    "Value": [
        df_full["case:concept:name"].nunique(), len(sorted_variants),
        f"{top10_cases/total_cases:.1%}", f"{top20_cases/total_cases:.1%}",
        len(tt_raw), len(tt_filtered),
        round(tt_filtered.mean(), 2), round(tt_filtered.median(), 2),
        round(tt_filtered.quantile(0.95), 2), f"{rework_rate:.1%}"
    ]
})
print(summary.to_string(index=False))

fig, axes = plt.subplots(1, 2, figsize=(14, 4))
axes[0].hist(tt_raw[tt_raw <= 400].dropna(), bins=50, color="lightcoral",
             edgecolor="white")
axes[0].axvline(tt_raw.median(), color="red", linestyle="--",
                label=f"Median: {tt_raw.median():.1f}d")
axes[0].axvline(tt_raw.mean(), color="orange", linestyle="--",
                label=f"Mean: {tt_raw.mean():.1f}d")
axes[0].set_title("Raw (capped at 400 days)")
axes[0].set_xlabel("Days")
axes[0].legend(fontsize=8)
axes[1].hist(tt_filtered.dropna(), bins=50, color="steelblue", edgecolor="white")
axes[1].axvline(tt_filtered.median(), color="red", linestyle="--",
                label=f"Median: {tt_filtered.median():.1f}d")
axes[1].axvline(tt_filtered.mean(), color="orange", linestyle="--",
                label=f"Mean: {tt_filtered.mean():.1f}d")
axes[1].set_title("Cleaned (zero & top 1% removed)")
axes[1].set_xlabel("Days")
axes[1].legend(fontsize=8)
plt.suptitle("Throughput Time Distribution -- BPI Challenge 2019", y=1.02)
plt.tight_layout()
plt.savefig("figs/fig_04_throughput.png", dpi=150)
plt.show()

if "cDocType" in df_full.columns:
    doc_tt = (
        df_full[df_full["case:concept:name"].isin(valid["case:concept:name"])]
        .groupby("case:concept:name")
        .agg(
            doc_type=("cDocType", "first"),
            tt_days=("time:timestamp",
                     lambda x: (x.max()-x.min()).total_seconds()/86400)
        )
        .reset_index()
    )
    fig, ax = plt.subplots(figsize=(9, 4))
    doc_tt.boxplot(column="tt_days", by="doc_type", ax=ax)
    ax.set_title("Throughput Time by Document Type")
    ax.set_ylabel("Days")
    plt.suptitle("")
    plt.tight_layout()
    plt.savefig("figs/fig_06_throughput_by_doctype.png", dpi=150)
    plt.show()

top20      = sorted_variants[:20]
labels     = [f"V{i+1}" for i in range(len(top20))]
counts     = [variant_count(v) for v in top20]
cumulative = [sum(counts[:i+1]) / total_cases * 100 for i in range(len(counts))]

fig, ax1 = plt.subplots(figsize=(12, 5))
bars = ax1.bar(labels, counts, color="coral", edgecolor="white")
ax1.bar_label(bars, fmt="%d", fontsize=8, padding=2)
ax1.set_title("Top 20 Variants by Case Count (Pareto)")
ax1.set_xlabel("Variant rank")
ax1.set_ylabel("Number of cases", color="coral")
ax2 = ax1.twinx()
ax2.plot(labels, cumulative, color="navy", marker="o",
         linewidth=1.5, markersize=4, label="Cumulative %")
ax2.axhline(80, color="gray", linestyle="--", linewidth=0.8, label="80% line")
ax2.set_ylabel("Cumulative coverage (%)", color="navy")
ax2.set_ylim(0, 105)
ax2.legend(loc="center right", fontsize=9)
plt.tight_layout()
plt.savefig("figs/fig_03_variant_freq.png", dpi=150, bbox_inches="tight")
plt.show()
