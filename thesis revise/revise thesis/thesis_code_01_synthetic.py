import pm4py
import pandas as pd
import shutil, os, warnings

warnings.filterwarnings("ignore")

df_synth = pd.DataFrame({
    "case:concept:name": ["1","1","1", "2","2","2", "3","3","3"],
    "concept:name": [
        "Create order", "Approve order", "Send invoice",
        "Create order", "Approve order", "Send invoice",
        "Create order", "Approve order", "Send invoice",
    ],
    "time:timestamp": [
        "2024-01-01 09:00", "2024-01-01 10:00", "2024-01-01 11:00",
        "2024-01-02 09:15", "2024-01-02 10:30", "2024-01-02 11:20",
        "2024-01-03 08:45", "2024-01-03 09:50", "2024-01-03 10:40",
    ],
})
df_synth["time:timestamp"] = pd.to_datetime(df_synth["time:timestamp"])

log_synth  = pm4py.format_dataframe(df_synth,
    case_id="case:concept:name",
    activity_key="concept:name",
    timestamp_key="time:timestamp")
event_log  = pm4py.convert_to_event_log(log_synth)

print(f"Cases            : {len(event_log)}")
print(f"Total events     : {sum(len(t) for t in event_log)}")

variants = pm4py.get_variants(event_log)
print(f"Distinct variants: {len(variants)}")

dfg, start_acts, end_acts = pm4py.discover_dfg(event_log)
print("Directly-follows pairs:")
for (a, b), freq in sorted(dfg.items(), key=lambda x: -x[1]):
    print(f"  {a} -> {b}  (freq: {freq})")

net, im, fm = pm4py.discover_petri_net_inductive(event_log)
print(f"Petri net places     : {len(net.places)}")
print(f"Petri net transitions: {len(net.transitions)}")
print(f"Petri net arcs       : {len(net.arcs)}")

tt = (
    df_synth.groupby("case:concept:name")["time:timestamp"].max()
  - df_synth.groupby("case:concept:name")["time:timestamp"].min()
)
tt_min = tt.dt.total_seconds() / 60

for cid, val in tt_min.items():
    print(f"  Case {cid}: {val:.0f} min")
print(f"\nMean   : {tt_min.mean():.1f} min")
print(f"Median : {tt_min.median():.1f} min")
print(f"CV     : {tt_min.std()/tt_min.mean():.2f}")
