# %%
import pandas as pd
import plotly.express as px

# %%

eigenvectors = pd.read_csv(
    join(
        "results",
        snakemake.wildcards.cluster_assignment,
        "Population_Structure",
        "Plink-PCA.eigenvec",
    ),
    sep="\t",
)
eigenvalues = pd.read_csv(
    join(
        "results",
        snakemake.wildcards.cluster_assignment,
        "Population_Structure",
        "Plink-PCA.eigenval",
    ),
    header=None,
)
samples = pd.read_csv("../../input/samples.csv")

vectors = eigenvectors.merge(
    samples, how="left", left_on="#IID", right_on="sample_name", indicator=True
)
# %%


# fig = px.scatter(
#     x=vectors["PC1"],
#     y=vectors["PC2"],
#     color=vectors["dataset"],
#     template="plotly_dark",
#     title="Plink-2 PCA | Datasets",
# )
# fig.update_layout(xaxis_title="PC 1", yaxis_title="PC 2")
# fig.write_image()


# fig = px.scatter(
#     x=vectors["PC1"],
#     y=vectors["PC2"],
#     color=vectors["SUB"],
#     template="plotly_dark",
#     title="Plink-2 PCA | Sub-Populations",
# )
# fig.update_layout(xaxis_title="PC 1", yaxis_title="PC 2")
# fig.write_image()
# %%

fig = px.scatter(
    x=vectors["PC1"],
    y=vectors["PC2"],
    color=vectors[snakemake.wildcards.cluster_assignment],
    template="plotly_dark",
    title=f"Plink-2 PCA | {snakemake.wildcards.cluster_assignment}",
)
fig.update_layout(xaxis_title="PC 1", yaxis_title="PC 2")
fig.write_image(f"{snakemake.output}")
# %%
