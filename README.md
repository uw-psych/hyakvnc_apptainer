# hyakvnc_apptainer

This repository contains Apptainer container recipes designed to work with [hyakvnc](https://github.com/uw-psych/hyakvnc).

Each container contains a VNC server and a desktop environment that can be used by connecting to the VNC server. The containers are designed to be run on UW Hyak Klone.

## Usage

As these containers are primarily designed for `hyakvnc`, you should use that tool to start a VNC session. See the [hyakvnc README](https://github.com/uw-psych/hyakvnc) for more information.

It is also possible to run these containers directly using `apptainer`:

```bash
# Download the container from GitHub Container Registry:
apptainer pull hyakvnc-ubuntu22.04-vncserver_latest.sif oras://ghcr.io/uw-psych/hyakvnc-ubuntu22.04-vncserver:latest

# Run the container:
apptainer run hyakvnc-ubuntu22.04-vncserver_latest.sif 
```

## Available containers

- `hyakvnc-ubuntu22.04-vncserver`: An Ubuntu 22.04 image with XFCE and the TurboVNC server installed and configured for `hyakvnc`
  - `hyakvnc-ubuntu22.04-freesurfer`: + FreeSurfer 7.4.1

