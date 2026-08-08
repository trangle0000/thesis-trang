# Simple artificial example

# ---------------------------------------------------------------------------------------
# General imports
# ---------------------------------------------------------------------------------------

from networkx import inverse_line_graph
import pandas as pd
import pm4py as pm

# ---------------------------------------------------------------------------------------
# Specific imports
# ---------------------------------------------------------------------------------------

from pm4py.objects.conversion.log import converter as log_converter
from pm4py.algo.discovery.inductive import algorithm as inductive_miner
from pm4py.objects.conversion.process_tree import converter as pt_converter
from pm4py.visualization.petri_net import visualizer as pn_visualizer

# ---------------------------------------------------------------------------------------
# Definitions
# ---------------------------------------------------------------------------------------

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

a = build_toy_event_log()
print(a)

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# TODO (MR): These names are taken from the IEEE 1849-2016
# standard. Perhaps, we should descsribe the basic of this in the
# thesis?

# standard prefixes
# concept: semantic information (case name, activity name)
# time: temporal atribute
# org: organizational data
# lifecycle: lifecycle state, e.g., complete

# general structures → prefix:attribute_name
# standard prefixes → belong to event
# case: prefix → belong to trace (case level)
# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯


# ---------------------------------------------------------------------------------------

def convert_to_event_log(df: pd.DataFrame):
    """
    Convert the pandas DataFrame into a PM4Py EventLog object.
    """
    log = log_converter.apply(df, variant=log_converter.Variants.TO_EVENT_LOG)
    return log


d = build_toy_event_log()
d1 = convert_to_event_log(d) # this is a typical format

d
type(d1)

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# TODO (MR): This are all public properties. Do we need to see what they are?

for p in dir(d1):
    print(p)

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

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

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# TODO (MR): Comverting to more standard data structures

pm.convert_to_dataframe(d1[0])
pm.convert_to_dataframe(d1)

# TODO (MR): This is how we can convert it to markdown
a = pm.convert_to_dataframe(d1)
print(a.to_markdown(index = False))

# TODO (MR): Comverting to a CSV to direct use in typst document
a.to_csv()
# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯


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

type(r1)
len(r1)
r1[0]
r1[1]
r1[2]
r1[3]

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

# This saves the visualization to a particular location.
pn_visualizer.save(gviz, "./fig1.png")

# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# TODO (MR): Is it the example in the thesis?
# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

