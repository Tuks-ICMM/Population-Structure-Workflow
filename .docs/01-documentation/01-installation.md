---
title: Installation
layout: page
permalink: documentation/installation
nav_order: 1
has_children: false
parent: Documentation
---


This workflow is maintained and distributed through the [ICMM GitHub page](https://github.com/Tuks-ICMM). The source-code has been versioned according to publications and relevant checkpoints, and can be downloaded via a git clone command:

```bash
git clone https://github.com/Tuks-ICMM/Population-Structure-Workflow.git
```

If you would like to clone a specific version, versions are declared and maintained via the repositories [releases page](https://github.com/Tuks-ICMM/VCF-Validation-Workflow/tags). To access a version, users can clone the repository, and perform a <code>checkout</code> command, providing the version to checkout:

```bash
git clone https://github.com/Tuks-ICMM/Population-Structure-Workflow.git
git checkout tags/<release_version>
```

## Dependencies

This workflow is built and powered using a python-based framework for workflow management. In addition, we make use of several underlying bioinformatics tools and third-party command-line programs to perform some steps in the analysis (For more information, see the [methodology page](/workflow/methodology)):

- Plink-2


