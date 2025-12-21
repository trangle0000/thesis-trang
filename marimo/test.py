import marimo

__generated_with = "0.18.4"
app = marimo.App(width="medium")


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    # Testing `pm4py`
    """)
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Imports
    """)
    return


@app.cell
def _():
    import marimo as mo
    import pandas as pd
    return mo, pd


@app.cell
def _():
    from pm4py.objects.conversion.log import converter as log_converter
    from pm4py.algo.discovery.inductive import algorithm as inductive_miner
    from pm4py.objects.conversion.process_tree import converter as pt_converter
    from pm4py.visualization.petri_net import visualizer as pn_visualizer
    return inductive_miner, log_converter, pn_visualizer, pt_converter


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Definitions
    """)
    return


@app.cell
def _(pd):
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
    return (build_toy_event_log,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ❗️ The structure above is unclear to me. Is it the standard format for data?
    """)
    return


@app.cell
def _(log_converter, pd):
    def convert_to_event_log(df: pd.DataFrame):
        """
        Convert the pandas DataFrame into a PM4Py EventLog object.
        """
        log = log_converter.apply(df, variant=log_converter.Variants.TO_EVENT_LOG)
        return log
    return (convert_to_event_log,)


@app.function
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


@app.cell
def _(inductive_miner, pt_converter):
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
    return (run_inductive_miner,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ❗️ What is the result of this algorithm? Is it a Petri net or another model? Also, it lacks a mathematical description.
    """)
    return


@app.function
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


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Example
    """)
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    Creating a basic data structure.
    """)
    return


@app.cell
def _(build_toy_event_log, convert_to_event_log):
    a = convert_to_event_log(build_toy_event_log())
    return (a,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    Building a model of a process map.
    """)
    return


@app.cell
def _(a, run_inductive_miner):
    tree, net, im, fm = run_inductive_miner(a)
    return fm, im, net, tree


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ❗️ It's not clear what are all these elements.
    """)
    return


@app.cell
def _(fm, im, net, tree):
    inspect_output_structures(tree, net, im, fm)
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    Basic visualization.
    """)
    return


@app.cell
def _(fm, im, net, pn_visualizer):
    gviz = pn_visualizer.apply(net, im, fm)
    pn_visualizer.view(gviz)
    return (gviz,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    This saves the visualization to a particular location.
    """)
    return


@app.cell
def _(gviz, pn_visualizer):
    pn_visualizer.save(gviz, "./fig1.png")
    return


if __name__ == "__main__":
    app.run()
