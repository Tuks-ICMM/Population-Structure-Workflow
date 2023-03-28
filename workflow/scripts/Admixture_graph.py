# %%
from os.path import join

import pandas as pd
import plotly.express as px

# %%

data = (
    pd.read_csv(
        "../../results/SUPER/Population_Structure/Admixture_1.3.11.Q",
        sep=" ",
        header=None,
    )
    .reset_index()
    .rename(columns={"index": "Individual"})
    #
    # .groupby("population")
    # .apply(pd.DataFrame.sort_values, "likelihood")
)
data.sort_values(by=[PC for PC in data.keys() if PC != 'Individual'], ascending=False, inplace=True)

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
    y=[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    title=f"Admixture-1.3.0 Plot | SUPER",
    template="plotly_dark",
    labels=label_mappings,
)
fig.update_layout(yaxis_title="Population assignment", bargroupgap=0.0, bargap=0.0)
fig.write_image("{snakemake.output}")

# %%
