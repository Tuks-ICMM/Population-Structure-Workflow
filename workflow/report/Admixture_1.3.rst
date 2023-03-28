We have implemented the `Admixture-1.3.0` software. `Admixture-1.3.0` uses an unsupervised clustering algorithm to produce cluster assignments which show population assignment based on marker frequency.

======
Notes:
======
Since this method of population structure introspection is parametric, certain quality control measures have been taken.

----------------------------
Minor allele count filtering
----------------------------
Singleton alleles have been removed. After reviewing an interesting discussion on the effects of frequency-based filters on admixture and population structure software, it was found that 
*singletons* negatively impact model-based methods ability to assign clear population groupings. (`doi.org/10.1111/1755-0998.12995 <https://doi.org/10.1111/1755-0998.12995>`_)

------------------------------
Linkage disequilibrium pruning
------------------------------
In the same article as above (`doi.org/10.1111/1755-0998.12995 <https://doi.org/10.1111/1755-0998.12995>`_), the authors discuss how unaccounted for linkage disequilibrium can affect results. 
Pruning out variants in linkage disequilibrium can help prevent the otherwise over-inflation of signals.

----------------------------------
Variant-level genotype missingness
----------------------------------
``Admixture-1.3`` does not like variants which are missing in all samples. These have to be removed before-hand.