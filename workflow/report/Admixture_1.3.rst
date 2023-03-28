Discriminant ANalysis of Principle Components (DAPC). 
=====================================================

We have implemented the `Admixture-1.3.0` software. `Admixture-1.3.0` uses an unsupervised clustering algorithm to produce cluster assignments which show population assignment based on marker frequency.

    | **Notes:**
    | Since this method of population structure introspection is parametric, certain qaulity control measures have been taken:
    | - Singleton alleles have been removed. After reviwing an interesting discussion on the effects of frequency-based filters on admixture and population structure software, it was found that 
    | *singletons* negatively impact model-based methods ability to assign clear population groupings. ([doi.org/10.1111/1755-0998.12995](https://doi.org/10.1111/1755-0998.12995))
