library("adegenet")
library("vcfR")
library("readr")
# library("tidyverse")


vcf <- vcfR2genind(read.vcfR(snakemake@input[[1]]))
# samples <- read.csv(snakemake@params['samples'])
pop(vcf) <- as.factor(snakemake@params[["cluster_assignments"]])

grp <- find.clusters(
  vcf,
  n.clust = 8,
  n.pca = 10,
  pca.select = "percVar",
  perc.pca = 80
)

table(pop(vcf), grp$grp)

png(
  filename = sprintf(
    "results/%s/Population_Structure/DAPC_population_inferences.png",
    snakemake@wildcards["cluster_assignment"]
  ),
  width = 13.3,
  height = 7.5
)
table.value(
  table(pop(vcf), grp$grp),
  col.lab = paste("infer", 1:13)
)
dev.off()

dapc_results <- dapc(vcf, grp$grp)

png(
  filename = sprintf(
    "results/%s/Population_Structure/DAPC_scatter_plot.png",
    snakemake@wildcards["cluster_assignment"]
  ),
  width = 13.3,
  height = 7.5
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
