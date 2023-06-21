from pandas import read_csv

samples = read_csv(snakemake.input.samples, index_col="sample_name")
samples

pedLabels = read_csv(snakemake.input.ped", usecols=[0], index_col=["ID"], names=["ID"], sep=" ")
pedLabels

output = pedLabels.merge(samples, how="left", right_index=True, left_index=True).fillna("-")
output

output[[snakemake.wildcards.cluster_assignment]].to_csv(f"results/{snakemake.wildcards.cluster_assignment}/Population_Structure/fetchPedLables.pop", index=False, header=False)