def collect_calculate_linkage_disequilibrium_per_cluster(wildcards) -> list[str]:
    LD_output = list()
    for cluster in clusters:
        for location in locations["location_name"].unique().tolist():
            # checkpoint_output = checkpoints.calculate_linkage_disequilibrium_per_cluster.get(
            #         cluster=cluster, location=location
            #     ).output["linkage_reports"]
            LD_output.extend(
                    directory(out(f"linkage_disequilibrium/{cluster}/{location}/"))
                )
            
    print("Linkage Output: ", LD_output)
    return LD_output
