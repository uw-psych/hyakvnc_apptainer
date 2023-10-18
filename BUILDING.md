# Building the containers on GitHub Actions

The containers are built using GitHub Actions. The workflow is defined in [`.github/workflows/apptainer-image.yml`](.github/workflows/apptainer-image.yml).

The workflow is triggered on every push with the tag `sif-<containername>`. It builds the named container and pushes it to the GitHub Container Registry.

Before containers that depend on other containers can be built, the dependent containers must be built and pushed to the registry. So, if `ubuntu22.04_turbovnc` depends on `ubuntu22.04_interactive`, you must first push a commit with the tag `sif-ubuntu22.04_interactive` for it to be built. Then, you can push a commit with the tag `sif-ubuntu22.04_turbovnc`.

