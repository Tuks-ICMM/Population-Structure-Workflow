# %%
from os.path import join

import pandas as pd
import plotly.express as px

# %%

data = (
    pd.read_csv(
        join(
            "results",
            snakemake.wildcards.cluster_assignment,
            "Population_Structure",
            f"plinkPed.{snakemake.wildcards.k}.Q",
        ),
        sep=" ",
        header=None,
    )
    .reset_index()
    .rename(columns={"index": "Individual"})
    #
    # .groupby("population")
    # .apply(pd.DataFrame.sort_values, "likelihood")
)
data.sort_values(
    by=[PC for PC in data.keys() if PC != "Individual"], ascending=False, inplace=True
)

data["Individual"] = (
    data["Individual"].apply(str).apply(lambda value: f"Individual {value}")
)

data = data.reset_index(drop=True)

# %%

label_mappings = {"Individual": "Individuals", "variable": "Populations (LTR)"}

# %%
fig = px.histogram(
    data,
    x="Individual",
    y=[PC for PC in data.keys() if PC != "Individual"],
    title=f"Admixture-1.3.0 Plot | SUPER",
    template="plotly_dark",
    labels=label_mappings,
)
fig.update_layout(yaxis_title="Population assignment", bargroupgap=0.0, bargap=0.0)
fig.write_image(f"{snakemake.output}")

# %%
