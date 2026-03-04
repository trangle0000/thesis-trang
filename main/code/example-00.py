import pandas as pd

from pm4py.objects.conversion.log import converter as log_converter
from pm4py.algo.discovery.inductive import algorithm as inductive_miner
from pm4py.objects.conversion.process_tree import converter as pt_converter
from pm4py.visualization.petri_net import visualizer as pn_visualizer

# ---------------------------------------------------------------------------------------
# Definitions

def build_toy_event_log() -> pd.DataFrame:
    """
    Task 1: Build a small toy event log as a pandas DataFrame.
    """
    data = [
        # Case 1: A -> B -> C
        {"case_id": "1", "activity": "A", "timestamp": "2025-01-01 10:00:00"},
        {"case_id": "1", "activity": "B", "timestamp": "2025-01-01 10:05:00"},
        {"case_id": "1", "activity": "C", "timestamp": "2025-01-01 10:10:00"},

        # Case 2: A -> C
        {"case_id": "2", "activity": "A", "timestamp": "2025-01-01 11:00:00"},
        {"case_id": "2", "activity": "C", "timestamp": "2025-01-01 11:05:00"},

        # Case 3: A -> B -> C
        {"case_id": "3", "activity": "A", "timestamp": "2025-01-01 12:00:00"},
        {"case_id": "3", "activity": "B", "timestamp": "2025-01-01 12:05:00"},
        {"case_id": "3", "activity": "C", "timestamp": "2025-01-01 12:10:00"},
    ]

    df = pd.DataFrame(data)

    # PM4Py prefers XES-style column names
    df = df.rename(
        columns={
            "case_id": "case:concept:name",
            "activity": "concept:name",
            "timestamp": "time:timestamp",
        }
    )

    df["time:timestamp"] = pd.to_datetime(df["time:timestamp"])
    return df

build_toy_event_log()

# MR: Why the names? I feel that CaseID, Activity and Timestamp are
# better names.

# MR: Is this the standard format of the data? So we've got the case
# ID, then we've got the type of activity, and then we've got the
# timestamp. What are the typical formats used in process mining?

# ---------------------------------------------------------------------------------------

def convert_to_event_log(df: pd.DataFrame):
    """
    Convert the pandas DataFrame into a PM4Py EventLog object.
    """
    log = log_converter.apply(df, variant=log_converter.Variants.TO_EVENT_LOG)
    return log


d = build_toy_event_log()
d1 = convert_to_event_log(d) # this is a typical format

# ---------------------------------------------------------------------------------------

def inspect_input_structures(log) -> None:
    """
    Inspect the input data structures used by the Inductive Miner.
    """
    print("=== INPUT DATA STRUCTURES ===")
    print("Python type of log:", type(log))
    print("Number of traces (cases):", len(log))

    first_trace = log[0]
    print("\nType of first trace:", type(first_trace))
    print("Number of events in first trace:", len(first_trace))

    first_event = first_trace[0]
    print("\nType of first event:", type(first_event))
    print("First event dictionary:", first_event)
    print("Keys in first event:", list(first_event.keys()))
    print()

inspect_input_structures(d1)

for s in dir(d1):
    print(s)

# MR: There is a lot of methods and properties of those objects. What
# are those methods and properties?

# ---------------------------------------------------------------------------------------

def run_inductive_miner(log):
    """
    Run the Inductive Miner on the given EventLog.

    Depending on the PM4Py version / variant, inductive_miner.apply(log)
    can either return:
        - a tuple (net, im, fm), or
        - a process tree object.

    We handle both cases:
        - if we get a tuple, we interpret it as (net, im, fm),
        - otherwise we treat it as a process tree and convert it to (net, im, fm).
    """
    # Try to specify a variant (if supported by this pm4py version)
    try:
        result = inductive_miner.apply(log, variant=inductive_miner.Variants.IM)
    except Exception:
        # Fallback: default behaviour
        result = inductive_miner.apply(log)

    tree = None

    if isinstance(result, tuple) and len(result) == 3:
        # Case 1: already (net, im, fm)
        net, im, fm = result
    else:
        # Case 2: some kind of process tree or similar object
        tree = result
        net, im, fm = pt_converter.apply(tree)

    return tree, net, im, fm


r1 = run_inductive_miner(d1)

# MR: What is the result of this algorithm? Is it a Petri net or
# another model? Also, it lacks a mathematical description.

# ---------------------------------------------------------------------------------------

def inspect_output_structures(tree, net, im, fm) -> None:
    """
    Inspect and print the output data structures.
    """
    print("=== OUTPUT DATA STRUCTURES ===")
    if tree is not None:
        print("Process model returned by apply() (treated as process tree):", type(tree))
    else:
        print("Process model: None (algorithm returned Petri net directly)")

    print("Petri net type:", type(net))
    print("Initial marking type:", type(im))
    print("Final marking type:", type(fm))

    print("\n=== PETRI NET SUMMARY ===")
    print("Number of places:", len(net.places))
    print("Number of transitions:", len(net.transitions))
    print("Number of arcs:", len(net.arcs))

    print("\nTransitions (name, label):")
    for t in net.transitions:
        print(f"- name={t.name}, label={t.label}")

    print("\nInitial marking (place -> tokens):")
    for place, tokens in im.items():
        print(f"- {place.name}: {tokens}")

    print("\nFinal marking (place -> tokens):")
    for place, tokens in fm.items():
        print(f"- {place.name}: {tokens}")

    print()

tree, net, im, fm = run_inductive_miner(d1)

inspect_output_structures(tree, net, im, fm)
d

# MR: What is the connection between the initial data as are displayed
# in the data frame and the resulting net? It seems that we have only
# three activities, A, B and C, but in the final net we have four
# places how these relate to each other.

# ---------------------------------------------------------------------------------------

## Example



# Creating a basic data structure.
a = convert_to_event_log(build_toy_event_log())

# Building a model of a process map.
tree, net, im, fm = run_inductive_miner(a)

# Inspecting output structures
inspect_output_structures(tree, net, im, fm)

# Basic visualization.
gviz = pn_visualizer.apply(net, im, fm)
pn_visualizer.view(gviz)

# MR: Now I understand how it works and what is the result, but you
# need to describe precisely in the text and also give me the
# mathematics for the algorithm itself.

# This saves the visualization to a particular location.
pn_visualizer.save(gviz, "./fig1.png")


