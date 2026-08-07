# Example 01 — BPI Challenge 2019: Load, Explore, Discover

# ---------------------------------------------------------------------------------------
# Imports
# ---------------------------------------------------------------------------------------

import os
import shutil
import warnings
import pm4py
import pandas as pd
import matplotlib.pyplot as plt

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# INFO (MR): I changed the following code by removing anything that
# writes, just to preserve whatever is already there.
# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯


# ---------------------------------------------------------------------------------------
# Configurations
# ---------------------------------------------------------------------------------------

# INFO (MR): I just wanted to check what is the current working
# directory as it's not always OK. Here it's consistent with the
# following path.
os.getcwd()

OCEL_PATH  = r"../../data/BPIC19_sample.jsonocel"
print("File exists:", os.path.exists(OCEL_PATH))

# ---------------------------------------------------------------------------------------
# Reading in the data
# ---------------------------------------------------------------------------------------

ocel = pm4py.read_ocel(OCEL_PATH)
events_df = ocel.events
objects_df   = ocel.objects
obj_type_col = ocel.object_type_column

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# INFO (MR): What are these objects
type(ocel)
for p in dir(ocel): print(p)

type(events_df)
events_df
for p in events_df.columns.tolist(): print(p)

# INFO (MR): What is the meaning of these objects?
type(objects_df)
objects_df

# INFO (MR): The only types of objects. What is the meaning of these types?
unique_types = (
    objects_df['ocel:type']
    .drop_duplicates()
    .sort_values()
    .tolist()
)
unique_types

type(obj_type_col)
obj_type_col

# TODO (MR): Why not look at relations (between events and objects)
rel_df = ocel.relations
rel_df[rel_df["ocel:eid"] == "1900003"]

unique_events = (
    rel_df["ocel:eid"]
    .drop_duplicates()
    .tolist()
)

len(unique_events)

rel_df[rel_df["ocel:eid"] == unique_events[2000]]
objects_df[objects_df["ocel:oid"] == "1924790"]

from pm4py.algo.discovery.ocel.ocpn import algorithm as ocpn_discovery
ocpn = ocpn_discovery.apply(ocel)
pm4py.view_ocpn(ocpn)

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

print("Total events :", len(events_df))
print("Total objects:", len(objects_df))
print("\nObject type counts:")
print(objects_df[obj_type_col].value_counts())

# TODO (MR): Interesting which one of those are dynamic instance
# level, reusable instalce level, and static master data?

# Cell 1b — Explore events

print("=" * 50)
print("EVENTS DataFrame")
print("=" * 50)
print(f"Shape: {events_df.shape}")
print(f"\nColumns:\n{events_df.columns.tolist()}")
print(f"\nSample rows:")
display(events_df.head(5))
print(f"\nNull values:")
print(events_df.isnull().sum())

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# TODO (MR): In the above code, there is nothing like `display`
# outside of Jupyter notebooks. Avoid. If you really need to do it,
# here's the way.

from IPython.display import display
display(events_df.head(5))
# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

# Cell 1c — Explore objects

print("=" * 50)
print("OBJECTS DataFrame")
print("=" * 50)
print(f"Shape: {objects_df.shape}")
print(f"\nColumns:\n{objects_df.columns.tolist()}")
print(f"\nSample rows:")
display(objects_df.head(5))
print(f"\nObject type distribution:")
display(objects_df[obj_type_col].value_counts().to_frame("count"))

# INFO (MR): Clean functional style
(
    objects_df[obj_type_col]
    .value_counts().
    to_frame("count")
    .pipe(display)
)


# TODO (MR): OK, but what is the meaning of all these numbers? Are
# objects just events (doubt it). It does not seem to be described in
# the thesis.


# Cell 1d — Time range & activity distribution

print("=" * 50)
print("TIME RANGE")
print("=" * 50)

# Auto-detect timestamp column
ts_col = None
for candidate in ["time:timestamp", "ocel:timestamp", "timestamp", "time"]:
    if candidate in events_df.columns:
        ts_col = candidate
        break

print(f"Timestamp column: '{ts_col}'")
ts = pd.to_datetime(events_df[ts_col], utc=True, errors="coerce")
print(f"Start : {ts.min()}")
print(f"End   : {ts.max()}")
print(f"Span  : {(ts.max() - ts.min()).days} days")

# TODO (MR): Are we sure about the dates? Does it really start in
# 1948?



print("\n" + "=" * 50)
print("ACTIVITY DISTRIBUTION")
print("=" * 50)

act_col = None
for candidate in ["concept:name", "ocel:activity", "activity"]:
    if candidate in events_df.columns:
        act_col = candidate
        break

print(f"Activity column: '{act_col}'")
act_dist = events_df[act_col].value_counts()
print(f"Distinct activities: {len(act_dist)}")
display(act_dist.to_frame("count").head(20))


# Cell 1e — Business attributes

print("=" * 50)
print("BUSINESS ATTRIBUTES")
print("=" * 50)

skip_cols = ["ocel:eid", ts_col, act_col, "ocel:activity", "ocel:type"]
business_cols = [c for c in events_df.columns if c not in skip_cols]
print(f"Business columns: {business_cols}\n")

for col in business_cols[:8]:
    unique_vals = events_df[col].dropna().unique()
    print(f"[{col}]")
    print(f"  Unique values : {len(unique_vals)}")
    print(f"  Examples      : {list(unique_vals[:5])}")
    print()

# TODO (MR): What is the meaning of these variables?

# Cell 1f — Object types & event-object relations

print("Object type counts:")
display(objects_df[obj_type_col].value_counts().to_frame("count"))

if hasattr(ocel, "relations"):
    rel_df = ocel.relations
    print(f"\nEvent-Object relations: {len(rel_df)}")
    print(f"Columns: {rel_df.columns.tolist()}")
    display(rel_df.head(10))
    objs_per_event = rel_df.groupby("ocel:eid").size()
    print(f"\nObjects per event — Mean: {objs_per_event.mean():.2f}  Max: {objs_per_event.max()}")
else:
    print("No relations attribute found.")

# Cell 1g — Dataset summary

summary = pd.DataFrame({
    "Metric": [
        "Total events", "Total objects", "Distinct activities",
        "Object types", "Business attribute columns",
        "Date range start", "Date range end", "Time span (days)"
    ],
    "Value": [
        len(events_df), len(objects_df),
        events_df[act_col].nunique(),
        objects_df[obj_type_col].nunique(),
        len(business_cols),
        str(ts.min().date()), str(ts.max().date()),
        (ts.max() - ts.min()).days
    ]
})
display(summary)

# Cell 2 — Flatten to classical event log

most_common_type = objects_df[obj_type_col].value_counts().index[0]
print("Selected object type:", most_common_type)



# TODO (MR): So the most common object type is `POItem`. Thus, we want
# to see how each individual item is processed. It's also interesting
# to see how the whole orders PO are processed.

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
ocel.events
ocel.relations

(
    ocel.objects
    .loc[lambda df: df["ocel:type"] == "POItem"]
    ["ocel:oid"]
    .tolist()
)

ocel.objects[ocel.objects['ocel:type'] == "POItem"]
# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯


classic_log = pm4py.ocel_flattening(ocel, most_common_type)
print("Cases after flattening:", len(classic_log))

(
    classic_log["case:ocel:type"]
    .drop_duplicates()
    .tolist()
)


df_full = pm4py.convert_to_dataframe(classic_log)
print("Events in classic log:", len(df_full))
print("Columns:", df_full.columns.tolist()[:10])

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
(
    ocel.relations
    .merge(ocel.events[["ocel:eid", "ocel:timestamp"]], on="ocel:eid")
    .drop(columns=["ocel:timestamp_y"])
    .rename(columns={"ocel:timestamp_x": "ocel:timestamp"})
    .groupby(["ocel:type", "ocel:oid"])["ocel:timestamp"]
    .agg(start_time="min", end_time="max")
    .assign(lifespan_hours=lambda df: (df["end_time"] - df["start_time"]).dt.total_seconds() / 3600)
    .reset_index()
    .groupby("ocel:type")["lifespan_hours"]
    .agg(
        total_objects="count",
        mean_lifespan_hrs="mean",
        median_lifespan_hrs="median",
        min_lifespan_hrs="min",
        max_lifespan_hrs="max"
    )
    .round(2)
    .sort_values("mean_lifespan_hrs", ascending=False)
    .pipe(display)
)

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

# TODO (MR): Interesting to see how the length of a lifespan changes
# in time. Is it becoming shorter? This is for both item and whole
# order.

# Cell 3 — Fig 01: Top 15 Activities by Frequency

act_counts = df_full["concept:name"].value_counts().head(15)

fig, ax = plt.subplots(figsize=(10, 5))
act_counts.sort_values().plot(kind="barh", color="steelblue", ax=ax)
ax.set_title("Top 15 Activities by Frequency")
ax.set_xlabel("Number of events")
plt.tight_layout()
# plt.savefig(os.path.join(OUTPUT_DIR, "fig_01_activity_freq.png"), dpi=150)
plt.show()
print("Saved: fig_01_activity_freq.png")



# Cell 4 — Basic log statistics

print("=== Basic Log Statistics ===")
print(f"Total cases    : {len(classic_log)}")
print(f"Total events   : {len(df_full)}")
print(f"Activities     : {df_full['concept:name'].nunique()}")
print("\nTop 10 activities:")
print(df_full["concept:name"].value_counts().head(10).to_string())


# Cell 5 — Process Discovery with train/test split

TRAIN_SIZE = 2000
TEST_SIZE  = 2000

train_log = classic_log[:TRAIN_SIZE]
test_log  = classic_log[TRAIN_SIZE : TRAIN_SIZE + TEST_SIZE]

# TODO (MR): This, I think, should be done more carefully. If the
# cases from 1948 or 1950s are quite different from the cases from
# five years ago, then obviously whatever we train on these very, very
# old cases will not be suitable for what we have now. Thank you.

print(f"Train cases : {len(train_log)}")
print(f"Test cases  : {len(test_log)}")

print("\nRunning Inductive Miner on train set...")
net, im, fm = pm4py.discover_petri_net_inductive(train_log)

print(f"\nPetri net:")
print(f"  Places     : {len(net.places)}")
print(f"  Transitions: {len(net.transitions)}")
print(f"  Arcs       : {len(net.arcs)}")


# Cell 6 — Save & view Petri net

pm4py.view_petri_net(net, im, fm)

dfg, start_acts, end_acts = pm4py.discover_dfg(train_log)

if shutil.which("dot"):
    out = os.path.join(OUTPUT_DIR, "fig_02_petri_net.png")
    pm4py.save_vis_petri_net(net, im, fm, out)
    print("Saved: fig_02_petri_net.png")
    pm4py.view_petri_net(net, im, fm)
else:
    print("Graphviz not found — saving DFG instead")

    out = os.path.join(OUTPUT_DIR, "fig_02_petri_net.png")
    pm4py.save_vis_dfg(dfg, start_acts, end_acts, out)
    print("Saved: fig_02_petri_net.png (DFG fallback)")
    pm4py.view_dfg(dfg, start_acts, end_acts)



# Cell 7 — Conformance Checking (token-based replay on unseen TEST set)

fitness_test = pm4py.fitness_token_based_replay(test_log, net, im, fm)

print("=== Conformance Checking (Token-Based Replay) ===")
print(f"Evaluated on         : {len(test_log)} UNSEEN cases (not used for discovery)")
print(f"Log fitness          : {fitness_test['log_fitness']:.4f}")
print(f"Average trace fitness: {fitness_test['average_trace_fitness']:.4f}")
print(f"Perfectly fitting    : {fitness_test['percentage_of_fitting_traces']:.1f}%")

fit_val = fitness_test['log_fitness']
if fit_val >= 0.95:
    msg = "Excellent — model captures real process behaviour well"
elif fit_val >= 0.80:
    msg = "Good — minor deviations exist"
else:
    msg = "Moderate or poor — consider tuning the Inductive Miner threshold"

print(f"\nInterpretation: {msg}")

