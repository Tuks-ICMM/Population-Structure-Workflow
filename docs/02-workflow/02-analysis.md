---
title: Analysis
permalink: workflow/analysis
layout: page
nav_order: 2
parent: Workflow
---

# Configuration
{: .no_toc }

A breakdown of the process used in this workflow and how it has been implemented.
{: .fs-6 .fw-300 }

Reference Genome Configuration
{: .label }



<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

---

<details>
  <summary>Rule Map/Diagram</summary>

  ```mermaid
---
title: Population Structure Workflow
---
flowchart TB

  classDef bcftools stroke:#FF5733,fill:#D3D3D3,stroke-width:4px,color:black;
  classDef plink stroke:#36454F,fill:#D3D3D3,stroke-width:4px,color:black;
  classDef python stroke:#FEBE10,fill:#D3D3D3,stroke-width:4px,color:black;
  classDef admixture stroke:#333,fill:#D3D3D3,stroke-width:4px,color:black;
  classDef tabix stroke:#023020,fill:#D3D3D3,stroke-width:4px,color:black;
  classDef gatk stroke:#007FFF,fill:#D3D3D3,stroke-width:4px,color:black;
  START(((Input)))
  END(((Output)))

  extract_provided_region[[**extract_provided_region**: Extract the provided region coordinates for clustering]]

  remove_rare_variants[[**remove_rare_variants**: Remove all variants which are not good indicators of population structure by nature]]

  plinkPca[[**Plink_PCA**:
Perform a PLINK-2.0 PCA]]
  
  report_fixation_index_per_cluster[[**report_fixation_index_per_cluster**: Report Fixation-index for the provided clusters]]

  class remove_rare_variants,plinkPca,plinkPed,report_fixation_index_per_cluster,extract_provided_region plink;
  class Admixture admixture;
  class fetchPedLables python;

  START --> extract_provided_region --> remove_rare_variants --> plinkPca & report_fixation_index_per_cluster

  plinkPca & report_fixation_index_per_cluster --> END
  ```

</details>