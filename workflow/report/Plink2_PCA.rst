Plink-2 Principle Component Analysis (PCA). 
===========================================

We have implemented `Plink-2`'s PCA methods which use a relationship-standardized relationship matrix, as detailed [here](https://www.cog-genomics.org/plink/2.0/strat#pca).

Wildcard Options at runtime:
----------------------------
- **cluster_assignment**: {{ snakemake.wildcards.cluster_assignment }}