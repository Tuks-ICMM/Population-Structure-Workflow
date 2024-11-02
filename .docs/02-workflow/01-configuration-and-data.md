---
title:  Configuration & Data
permalink: workflow/configuration-and-data
layout: page
nav_order: 1
parent: Workflow
has_children: false
---

# Data Requirements
{: .no_toc}

A summary of the required data and input files needed to perform an analysis.
{: .fs-6 .fw-300 }

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

---

This page describes the information needed to run the {{ site.title }}. Below we guide users through the system used to declare an analysis manifest, and all associated metadata files. For more information, please consult the relevant section below which contains more specific guidance, discussions and technical documentation.


## Overview

This workflow makes use of an analysis manifest to encapsulate all analysis variables used. This manifest file collects and connects the metadata for your samples, datasets, and relevant reference resources (Reference Genomes, etc) together. Doing so allows the workflow to programmatically access clusters through sample annotations, which is required in order to produce cluster-level reports.

<details markdown="block" open>
  <summary>Input Data Infographic</summary>
  {: .text-delta }

{% raw %}
```mermaid
---
title: Input Filemap
config:
    flowchart:
        defaultRenderer: elk
    elk:
        nodePlacementStrategy: BRANDES_KOEPF
---
flowchart TB

  subgraph input ["Input Files"]
      subgraph data [Datasets]
          datasetFile1{{<b>Dataset file</b><br><code>GnomAD_Chr1.vcf.gz</code>}}
          datasetFile2{{<b>Dataset file</b><br><code>GnomAD_Chr2.vcf.gz</code>}}
          datasetFileN{{<b>Dataset file</b><br><code>GnomAD_ChrN...vcf.gz</ code>}}
      end
      subgraph metadata ["Analysis metadata"]
          locationMeta{{<b>Coordinates for study</b><br><code>locations.csv</code>}}
          sampleMeta{{<b>Sample metadata</b><br><code>samples.csv</code>}}
      end
  end
  subgraph config [<code>config/</code>]
    configuration{{<b>Analysis configuration</b> <br><code>config/configuration.json</code>}}
  end
  population_structure_workflow[\Population structure Workflow/]
  click population_structure_workflow href "https://tuks-icmm.github.io/Population-Structure-Workflow/workflow/methodology" _blank

  
  input --> population_structure_workflow
  config ----> population_structure_workflow
  population_structure_workflow --> results

  results(((Results)))
    
    metadata -.-o|Describes| data
```
{% endraw %}

</details>

## Input Data

This workflow is designed to work on variant-call-format files (.vcf file extension). The latest version of the VCF specification can be found here.

### Compression and Indexing

This workflow can accept uncompressed VCF files, however this workflow will compress and index the data during handling for performance reasons. If possible, please provide them in compressed and index form


## Analysis configuration

To perform an analysis with this workflow, users will need to configure the workflow. This includes providing environment-related information like output locations, as well as analysis settings like reference population selection. This information is all declared and stored using the `config/manifest.json` file.

<h3>The <code>manifest.json</code> file</h3>

This file is responsible for declaring all information relating to the analysis and serves as the central point of contact between the workflow runtime and your input data. It is also used to configure and synchronize any sub-workflows imported internally.

<details markdown="block">
  <summary>
    <code>manifest.json</code> format example
  </summary>
  {: .text-delta }

  <dl>
    <dt><b>input</b> <code>&lt;object&gt;</code></dt>
    <dd>
        <dl>
            <dt><b>locations</b> <code>&lt;Array&lt;str&gt;&gt;</code></dt>
            <dd>A list representing the file-path to the location metadata file. Should be suitable for use with the python <code>os.path.join()</code> function.</dd>
            <dt><b>samples</b> <code>&lt;Array&lt;str&gt;&gt;</code></dt>
            <dd>A list representing the file-path to the samples metadata file. Should be suitable for use with the python <code>os.path.join()</code> function.</dd>
        </dl>
    </dd>
    <dt><b>output</b> <code>&lt;Array&lt;str&gt;&gt;</code></dt>
    <dd>A list representing a path to a folder where the results of the analysis should be stored. If the folder does not exist, it will be created.</dd>
  </dl>

  ```json
  {
    "input": {
        "locations": [
            "/",
            "path",
            "to",
            "my",
            "locations",
            "metadata"
        ],
        "samples": [
            "/",
            "path",
            "to",
            "my",
            "samples",
            "metadata"
        ],
    },
    "output": [
        "/",
        "path",
        "to",
        "my",
        "output",
        "location"
    ]
}
  ```
</details>

---

### Metadata

All data and sample metadata is provided in the form of ` .csv` files declared in the `manifest.json` file. These files allow you to declare datasets and provide the necessary information to determine which contig-level files should be used for analysis given the provided genomic coordinates. For convenience, we will assume standard names for the sake of this explanation:

{: .normal }
> This design-pattern of declaring metadata files via the `manifest.json` was chosen specifically to allow users to create and store analysis configurations and metadata alongside data, which often has special storage requirements (e.g. space, access, etc). Through the `manifest.json` file, all other analysis-specific files will be declared and will be accessible. This then only requires that the `manifest.json` file is discoverable under the path `config/manifest.json`, which can be accomplished with a symlink or shortcut, keeping the amount of setup work to a minimum.

#### <code>locations.csv</code> Metadata

The location metadata file allows you to declare samples and provide the necessary sample-level information for use in this pipeline.


<details markdown="block">
  <summary>
    Format example
  </summary>
  {: .text-delta }


<dl class="def-wide">
  <dt>location_name <code>&lt;str&gt;</code></dt>
  <dd>The ID of a gene or, if not a studied gene region, a unique identifier to reference this genomic coordinate window.
  
  <br><strong><i>E.g. <code>CYP2A6</code></i></strong></dd>
  
  <dt>chromosome <code>&lt;enum &lt;int [0-24]&gt; &gt;</code></dt>
  <dd>The chromosome number on which the above genomic region can be found.
  
  <br><strong><i>E.g. <code>19</code></i></strong></dd>

  <dt>start <code>&lt;int&gt;</code></dt>
  <dd>The start coordinates for the genomic window.
  
  <br><strong><i>E.g. <code>40842850</code></i></strong></dd>
  
  <dt>stop <code>&lt;int&gt;</code></dt>
  <dd>The stop coordinates for the genomic window.
  
  <br><strong><i>E.g. <code>1000g</code></i></strong></dd>
  
  <dt>strand <code>&lt;enum [-1,1]&gt;</code></dt>
  <dd>The strand on which the genomic region can be found, where <code>1</code> denotes the forward strand and <code>-1</code> denotes the reverse strand.
  
  <br><strong><i>E.g. <code>-1</code></i></strong></dd>
</dl>

| **location_name** | **chromosome** | **start** | **stop**  | **strand** |
| :---------------- | :------------- | :-------- | :-------- | :--------- |
| CYP2A6            | 19             | 40842850  | 40851138  | -1         |
| CYP2B6            | 19             | 40988570  | 41021110  | 1          |
| UGT2B7            | 4              | 69045214  | 69112987  | 1          |

</details>

#### <code>samples.csv</code> Metadata

The sample metadata file allows you to declare samples and provide the necessary sample-level information for use in this pipeline.

<details markdown="block">
  <summary>
   Format example
  </summary>
  {: .text-delta }

{: .highlight-title }
> Case Sensitive
>
> The following metadata declaration files use _**case-sensitive column names**_.

<dl class="def-wide">
  <dt>sample_name <code>&lt;str&gt;</code></dt>
  <dd>The ID of the sample. this should correspond to the sample ID's provided in the provided <code>.vcf</code> file. 
  
  <br><strong><i>E.g. <code>HG002</code></i></strong></dd>
  
  <dt>dataset <code>&lt;enum [dataset_name]&gt;</code></dt>
  <dd>The name of the dataset this sample belongs to. This value should correspond to the provided dataset ID listed in <code>datasets.csv</code> 
  
  <br><strong><i>E.g. <code>1000g</code></i></strong></dd>
  
  <dt><code>* &lt;str&gt;</code></dt>
  <dd>A file path indicating the location of the dataset to be used in the analysis. Please note that the column names are <b><i><u>case-sensitive</u></i></b>.
  
  <br><strong><i>E.g. <code>GRCh37</code> or <code>GRCh38</code></i></strong></dd>
</dl>

| **sample_name** | **dataset** | **SUPER** | **SUB** |
| :-------------- | :---------- | :-------- | :------ |
| HG002           | HG002       | `EUR`     | `GBR`   |
| HG002           | HG003       | `AFR`     | `GWD`   |
| HG002           | HG004       | `SAS`     | `GIH`   |

</details>
