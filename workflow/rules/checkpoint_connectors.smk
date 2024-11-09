
def collect_calculate_linkage_disequilibrium_per_cluster(wildcards) -> list[str]:
    LD_output = list()
    for location in locations["location_name"].unique().tolist():
        for cluster in clusters:
            for population in samples[cluster].unique().tolist():
                LD_output.append(
                    directory(out(f"linkage_disequilibrium/{cluster}/{location}/calculated_linkage_disequilibrium_per_cluster.{population}.vcor.zst"))
                )
    return LD_output