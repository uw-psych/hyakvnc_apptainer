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
- `ubuntu22.04_interactive`:
	- `ubuntu22.04_xubuntu`


Minimized/barebones container recipes, suffixed with `_min`, are provided with
XFCE4, vncserver, and dependencies to run Lmod and build/run Apptainers.

These container recipes are provided to serve as examples and are meant to be
modified to user needs.

## Build Steps

Following guidance from [Hyak's Documentation](https://hyak.uw.edu/docs/tools/containers),
We will need to build the container on an interactive work node:

```bash
salloc -A <mygroup> -p <mypartition> c -8 --mem=32G --time=2:00:00
```

Navigate to this directory then run `make` with the name of container specified:

```bash
cd /path/to/hyak_vnc_apptainer
make ubuntu22.04_interactive 
```

Some containers depend on others. To make them, you must first make their
predecessors. For example, `ubuntu22.04_xubuntu` relies on
`ubuntu22.04_interactive`, and requires `make` to be called with that as its
argument before it can proceed

```bash
cd /path/to/hyak_vnc_apptainer
make ubuntu22.04_xubuntu
```

If successful, a container file ending with .sif can be found in the directory
with the same name as the container.

