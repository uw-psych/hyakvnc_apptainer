Sample VNC Apptainer
====================

This repo contains sample Apptainer recipes along with a Makefile to build one
on UW Hyak Klone.

These Apptainer containers are used by `hyakvnc` to start a VNC session.

Available Apptainers and their descendants:

- ~~`ubuntu20.04_min`~~
- ~~`ubuntu20.04`~~
- ~~`rockylinux8_min`~~
- ~~``rockylinux8`~~
- `ubuntu22.04_interactive`: An basic command-line starter image for interactive use
	- `ubuntu22.04_turbovnc`: + TurboVNC
		- `ubuntu22.04_xubuntu`: Ubuntu with most of Xubuntu tools installed
			-  `ubuntu22.04_xubuntu_freesurfer`: + FreeSurfer


~~Minimized/barebones container recipes, suffixed with `_min`, are provided with
XFCE4, vncserver, and dependencies to run Lmod and build/run Apptainers.~~

These container recipes are provided to serve as examples and are meant to be
modified to user needs.

## Build Steps

It is recommended that you run this from a directory on `/gscratch` rather than in your home directory (e.g., `/gscratch/<mygroup>/<myusername>/hyakvnc_apptainer`) -- otherwise, you might run out of disk space.

Following guidance from [Hyak's Documentation](https://hyak.uw.edu/docs/tools/containers),
We will need to build the container on an interactive work node:

```bash
salloc -A <mygroup> -p <mypartition> c -8 --mem=32G --time=2:00:00
```

Navigate to this directory then run `make` with the name of container specified:

```bash
cd /path/to/hyakvnc_apptainer
make ubuntu22.04_turbovc 
```

Some containers depend on others. They expect to be in the directory specified by the environment varialbe "$CONTAINERDIR".
By default, CONTAINERDIR is set to the current directory.

If successful, a container file ending with .sif can be found in the directory specified by the environment variable "$CONTAINERDIR", or the current directory.
