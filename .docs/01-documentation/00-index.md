---
title: Documentation
permalink: documentation
layout: page
nav_order: 1
has_children: true
---

# Documentation

A brief guide on this workflow, including details on its download, configuration and execution.
{: .fs-6 .fw-300 }

---


This workflow includes a number of tools and processing steps intended to help researchers rapidly identify variation of medical interest.

This project aims to establish a stable platform, through which we can iteratively and incrementally develop a practical implementation for Pharmacogenetics analysis techniques. Our goal is to bring stability, traceability and predictability to the development and use of a standardized testing and reporting methods in the industry of personalized medicine.

A workflow has been chosen as the ideal medium through which to provide a standardized testing and reporting framework. The use of workflows such as Snakemake and facilities such as Git and Github, allow researchers to leverage several facilities and conventions developed within the information-technology industry within an academic context. This can bring great value in terms of giving researchers the means to perform research that is much more translational, in a format that is easily citable, within the research community and externally.

## Intended Use-Cases


## Project Structure


Since users of this workflow will need to work within the file structure in order to configure, and run this workflow, a dedicated file-structure has been employed to keep our source code neat and tidy. Below is a brief summary of the files and folders, based on the recommended Snakemake project structure detailed on the [Snakemake Documentation website](https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html).

{: .normal }
> Several development-related files and folders have been excluded for practicality. These folders have all been prefaced with a period (`.`) to denote them as hidden files and folders.

```
├── .gitignore
├── README.md
├── LICENSE.md
├── config
│   └── manifest.json
├── input
│   ├── locations.csv
│   └── samples.csv
├── resources
└── workflow
    ├── rules
    │   └── common.smk
    ├── envs
    │   └── population-structure-workflow.yml
    ├── scripts
    │   └── generateInd2Pop.py
    └── Snakefile
```