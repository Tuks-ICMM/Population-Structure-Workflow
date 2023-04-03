
library("adegenet")
library("vcfR")
library("readr")
# library("tidyverse")


vcf <- vcfR2genind(read.vcfR(snakemake@input[[1]]))
# samples <- read.csv(snakemake@params['samples'])
pop(vcf) <- as.factor(snakemake@params[["cluster_assignments"]])

print(paste("[ASSUMPTION(find.clusters)] Number of clusters: ", length(unique(snakemake@params[["cluster_assignments"]]))))
grp <- find.clusters(
  vcf,
  n.clust = length(unique(snakemake@params[["cluster_assignments"]])),
  n.pca = 10,
  pca.select = "percVar",
  perc.pca = 90
)

table(pop(vcf), grp$grp)


print(paste("[LOG] Graph to file: ",  sprintf(
  "results/%s/Population_Structure/DAPC_population_inferences.png",
  snakemake@wildcards[["cluster_assignment"]]
)))
png(
  filename = sprintf(
    "results/%s/Population_Structure/DAPC_population_inferences.png",
    snakemake@wildcards[["cluster_assignment"]]
  )
)
print(paste("[ASSUMPTION(table)] Number of clusters: ", length(unique(snakemake@params[["cluster_assignments"]]))))
table.value(
  table(pop(vcf), grp$grp),
  col.lab = paste("infer", 1:length(unique(snakemake@params[["cluster_assignments"]])))
)
dev.off()

print(paste("[ASSUMPTION(DAPC)] Number of clusters: ", length(unique(snakemake@params[["cluster_assignments"]]))))
dapc_results <- dapc(
  vcf, grp$grp,
  truenames = TRUE,
  var.contrib = TRUE,
  var.loadings = TRUE,
  n.clust = length(unique(snakemake@params[["cluster_assignments"]])),
  n.pca = 10,
  n.da = 10,
  pca.info = TRUE,
  pca.select = "percVar",
  perc.pca = 90,
)

print(paste("[LOG] Graph to file: ",  sprintf(
  "results/%s/Population_Structure/DAPC_scatter_plot.png",
  snakemake@wildcards[["cluster_assignment"]]
)))
png(
  filename = sprintf(
    "results/%s/Population_Structure/DAPC_scatter_plot.png",
    snakemake@wildcards[["cluster_assignment"]]
  )
)
scatter(
  dapc_results,
  scree.pca = TRUE,
  posi.pca = "bottomleft",
  posi.da = "bottomright",
  leg = TRUE
)
dev.off()


# e <- ggplot(dapc_results$tab$`PCA-pc.1`, dapc_results$tab$`PCA-pc.2`, col=vcf@pop, xlab="PC 1", ylab="PC 2", main="PCA")
# legend(6, 8, legend=unique(vcf@pop))
