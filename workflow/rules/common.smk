from os.path import join

def outputDir(path: str) -> str:
    """This function consults the `config.json` file to determine if a pre-set output directory has been specified. If it has, the provided directory will be used. If not, the current working directory will be used."""
    if "output-dir" in config:
        OUTPUT_DIR_PATH = join(*config["output-dir"])
        return join(OUTPUT_DIR_PATH, path)
    else:
        return join("results", path)

def population_structure_outputs(wildcards):
    return []