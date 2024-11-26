def collect_calculate_linkage_disequilibrium_per_cluster(wildcards) -> list[str]:
    LD_output = list()
    for location in locations["location_name"].unique().tolist():
        for cluster in clusters:
            checkpoint_output = checkpoint.calculate_linkage_disequilibrium_per_cluster.get(
                    cluster=cluster, location=location
                ).output["linakge_reports"]
            
            populations = glob_wildcards(
                join(
                    checkpoint_output,
                    "calculated_linkage_disequilibrium_per_cluster.{populations}.vcor.zst",
                )
            ).populations
            LD_output.append(
                expand(
                    out(
                        "linkage_disequilibrium/{cluster}/{location}/calculated_linkage_disequilibrium_per_cluster.{population}.vcor.zst"
                    ),
                    cluster=cluster,
                    location=location,
                    population=populations,
                )
            )
    return LD_output
