---
title: Methodology
permalink: workflow/methodology
layout: page
nav_order: 2
parent: Workflow
has_children: false
---

# Methodology
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

<details open markdown="block">
  <summary>Rule Map/Diagram</summary>


  ```mermaid
---
title: Population Structure Workflow
config:
    flowchart:
        defaultRenderer: elk
---
flowchart TB
  subgraph population_structure_workflow[Population Structure Workflow]
    direction TB
    classDef bcftools stroke:#FF5733,fill:#D3D3D3,stroke-width:4px,color:black;
    classDef plink stroke:#36454F,fill:#D3D3D3,stroke-width:4px,color:black;
    classDef python stroke:#FEBE10,fill:#D3D3D3,stroke-width:4px,color:black;
    classDef admixture stroke:#333,fill:#D3D3D3,stroke-width:4px,color:black;
    classDef tabix stroke:#023020,fill:#D3D3D3,stroke-width:4px,color:black;
    classDef gatk stroke:#007FFF,fill:#D3D3D3,stroke-width:4px,color:black;
    START(((Input)))
    END(((Output)))

    extract_provided_region[[<b>extract_provided_region</b>: <br>Extract the provided region <br>coordinates for clustering]]

    remove_rare_variants[[<b>remove_rare_variants</b>: <br>Remove all variants which are <br>not good indicators of population <br>structure by nature]]

    plink_pca[[<b>plink_pca</b>: <br>Perform a <br>PLINK-2.0 PCA]]
    
    report_fixation_index_per_cluster[[<b>report_fixation_index_per_cluster</b>: <br>Report Fixation-index for the <br>provided clusters]]

    class remove_rare_variants,plink_pca,plinkPed,report_fixation_index_per_cluster,extract_provided_region plink;
    class Admixture admixture;
    class fetchPedLables python;

    START --> extract_provided_region --> remove_rare_variants --> plink_pca & report_fixation_index_per_cluster

    plink_pca & report_fixation_index_per_cluster --> END
  end
  ```


</details>

<details markdown="block">
  <summary>
    <code>extract_provided_region</code>
  </summary>

  ```mermaid
  flowchart TD
    extract_provided_region[[<b>extract_provided_region</b>: <br>Extract the provided region <br>coordinates for clustering]]

    classDef plink stroke:#36454F,fill:#D3D3D3,stroke-width:4px,color:black;
    class extract_provided_region plink;
  ```

  <dl>
    <dt>Function</dt>
    <dd>Extract the requested coordinates to be used for population clustering, as provided in the <code>sample.csv</code> file.</dd>
    <dt>Command</dt>
    <dd><code>plink2 --threads {threads} --pfile {params.input} vzs --from-bp {params.fromBP} --to-bp {params.toBP} --chr {params.chr} --make-pgen vzs --out {params.output}</code></dd>
    <dt>Parameters</dt>
    <dd>
      <dl>
        <dt><code>--threads {threads}</code></dt>
        <dd>Used to set the number of CPU threads used during this calculation</dd>
        <dt><code>--pfile {params.input} vzs</code></dt>
        <dd>Used to provide plink with the location of a plink-2 binary file set (.psam, .pvar and .pgen files), and to expect z-compressed files.</dd>  
        <dt><code>--from-bp</code></dt>
        <dd>The start co-ordinates to start trimming from.</dd>
        <dt><code>--to-bp</code></dt>
        <dd>The stop coordinates to trim until.</dd>
        <dt><code>--chr</code></dt>
        <dd>The chromosome on which the coordinates can be found.</dd>
        <dt><code>--make-pgen zs</code></dt>
        <dd>Save output to a BG-Zipped pgen binary fileset.</dd>  
        <dt><code>--out {params.output}</code></dt>
        <dd>Provide the file name and path for output creation.</dd>
      </dl>
    </dd>
  </dl>
</details>

<details markdown="block">
  <summary>
    <code>remove_rare_variants</code>
  </summary>

  ```mermaid
  flowchart TD
    remove_rare_variants[[<b>remove_rare_variants</b>: <br>Remove all variants which are <br>not good indicators of population <br>structure by nature]]

    classDef plink stroke:#36454F,fill:#D3D3D3,stroke-width:4px,color:black;
    class remove_rare_variants plink;
  ```

  <dl>
    <dt>Function</dt>
    <dd>Remove singletons as these do not contribute towards an understanding of clusters, since a singleton only serves to separate a sample from a possible cluster.</dd>
    <dt>Command</dt>
    <dd><code>plink2 --threads {threads} --pfile {params.input} vzs --pheno {input.sample_metadata} --mac 2 --make-pgen vzs --out {params.output}</code></dd>
    <dt>Parameters</dt>
    <dd>
      <dl>
        <dt><code>--threads {threads}</code></dt>
        <dd>Used to set the number of CPU threads used during this calculation.</dd>
        <dt><code>--pfile {params.input} vzs</code></dt>
        <dd>Used to provide plink with the location of a plink-2 binary file set (.psam, .pvar and .pgen files), and to expect z-compressed files.</dd>  
        <dt><code>--pheno {input.sample_metadata}</code></dt>
        <dd>Responsible for annotating samples with provided annotations.</dd>  
        <dt><code>--mac 2</code></dt>
        <dd>Remove any variants with a total count of less than 2.</dd>
        <dt><code>--make-pgen zs</code></dt>
        <dd>Save output to a BG-Zipped pgen binary fileset.</dd>  
        <dt><code>--out {params.output}</code></dt>
        <dd>Provide the file name and path for output creation.</dd>
      </dl>
    </dd>
  </dl>
</details>

<details markdown="block">
  <summary>
    <code>plink_pca</code>
  </summary>

  ```mermaid
  flowchart TD
    plink_pca[[<b>plink_pca</b>: <br>Perform a <br>PLINK-2.0 PCA]]

    classDef plink stroke:#36454F,fill:#D3D3D3,stroke-width:4px,color:black;
    class plink_pca plink;
  ```

  <dl>
    <dt>Function</dt>
    <dd>Perform dimensionality reduction on the samples provided and produce allele-weighted scores indicating possible population structure.</dd>
    <dt>Command</dt>
    <dd><code>plink2 --threads {threads} --pfile {params.input} vzs --pca allele-wts --out {params.output}</code></dd>
    <dt>Parameters</dt>
    <dd>
      <dl>
        <dt><code>--threads {threads}</code></dt>
        <dd>Used to set the number of CPU threads used during this calculation.</dd>
        <dt><code>--pfile {params.input} vzs</code></dt>
        <dd>Used to provide plink with the location of a plink-2 binary file set (.psam, .pvar and .pgen files), and to expect z-compressed files.</dd>  
        <dt><code>--pca allele-wts</code></dt>
        <dd>Generate an allele-weighted PCA eigenvector and eigenvalue files.</dd>
        <dt><code>--out {params.output}</code></dt>
        <dd>Provide the file name and path for output creation.</dd>
      </dl>
    </dd>
  </dl>
</details>


<details markdown="block">
  <summary>
    <code>report_fixation_index_per_cluster</code>
  </summary>

  ```mermaid
  flowchart TD
    report_fixation_index_per_cluster[[<b>report_fixation_index_per_cluster</b>: <br>Report Fixation-index for the <br>provided clusters]]

    classDef plink stroke:#36454F,fill:#D3D3D3,stroke-width:4px,color:black;
    class report_fixation_index_per_cluster plink;
  ```

  <dl>
      <dt>Function</dt>
      <dd>
      To generate a hardy-weinberg report.</dd>
      <dt>Command</dt>
      <dd><code>plink2 --threads {threads} --pfile {params.input} vzs --fst {wildcards.cluster} report-variants zs --out {params.output}</code></dd>
      <dt>Parameters</dt>
      <dd>
        <dl>
          <dt><code>--threads {threads}</code></dt>
          <dd>Used to set the number of CPU threads used during this calculation</dd>
          <dt><code>--pfile {params.input} vzs</code></dt>
          <dd>Used to provide plink with the location of a plink-2 binary file set (.psam, .pvar and .pgen files), and to expect z-compressed files.</dd>
          <dt><code>--fst {wildcards.cluster} report-variants zs</code></dt>
          <dd>Perform the requested fixation index calculations. the <code>report-variants</code> modifier requests variant-level fst results and the <code>zs</code> modifier requests the output to be compressed.</dd>
          <dt><code>--out {params.output}</code></dt>
          <dd>Provide the file name and path for output creation.</dd>  
        </dl>
      </dd>
    </dl>

</details>