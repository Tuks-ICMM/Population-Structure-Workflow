Discriminant ANalysis of Principle Components (DAPC). 
====================================

We have implemented the `R` package, `Adegenet`'s DAPC methods which perform a Post-Hoc test on Principle component analyses.

    | The `Adegenet` package's DAPC analysis performs a post-hoc selection of principle components from a normal
    | PCA by solving for principle components which *maximize between-population variation while minimizing within-population variation*.
    |
    | Because of this, a DAPC analysis and the components it identifies are slightly different from a typical PCA as some restrictions are no longer-applied: 
    | - The components are statistically independent of each other.
    | - The components are not necessarily orthogonal to each other.
