import pm4py
import pandas as pd

ocel = pm4py.read_ocel_json("BPIC19_sample.jsonocel")

print(f"Total events : {len(ocel.events)}")
print(f"Total objects: {len(ocel.objects)}")

print(ocel.objects["ocel:type"].value_counts())

classic_log = pm4py.ocel_flattening(ocel, "POItem")
df_full     = pm4py.convert_to_dataframe(classic_log)
df_full["time:timestamp"] = pd.to_datetime(df_full["time:timestamp"], utc=True)

# Filter out ERP data entry errors (timestamps before 2018)
df_full = df_full[df_full["time:timestamp"] >= pd.Timestamp("2018-01-01", tz="UTC")]

# Chronological split by case (sorted by earliest event timestamp)
case_start = df_full.groupby("case:concept:name")["time:timestamp"].min().sort_values()
n_total    = len(case_start)       # 43,898 cases
n_train    = int(n_total * 0.70)   # 30,728
n_val      = int(n_total * 0.15)   # 6,584

train_ids = set(case_start.index[:n_train])
val_ids   = set(case_start.index[n_train : n_train + n_val])
test_ids  = set(case_start.index[n_train + n_val:])

train_log = pm4py.convert_to_event_log(df_full[df_full["case:concept:name"].isin(train_ids)])
val_log   = pm4py.convert_to_event_log(df_full[df_full["case:concept:name"].isin(val_ids)])
test_log  = pm4py.convert_to_event_log(df_full[df_full["case:concept:name"].isin(test_ids)])

net, im, fm = pm4py.discover_petri_net_inductive(train_log)
print(f"Places     : {len(net.places)}")      # 95
print(f"Transitions: {len(net.transitions)}") # 154
print(f"Arcs       : {len(net.arcs)}")        # 334

import matplotlib.pyplot as plt

activity_counts = df_full["concept:name"].value_counts().head(15)
fig, ax = plt.subplots(figsize=(10, 6))
activity_counts.sort_values().plot(kind="barh", color="steelblue", ax=ax)
ax.set_title("Activity Frequency (BPI Challenge 2019)")
ax.set_xlabel("Number of events")
plt.tight_layout()
plt.savefig("figs/fig_01_activity_freq.png", dpi=150)
plt.show()
