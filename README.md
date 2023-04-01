Sample VNC Apptainer
====================

This repo contains sample Apptainer recipes along with a Makefile to build one
on UW Hyak Klone.

These Apptainer containers are used by `hyakvnc.py` to start a VNC session.

Available Apptainers:

- ubuntu20.04
- rockylinux

## Build Steps

Following guidance from [Hyak's Documentation](https://hyak.uw.edu/docs/tools/containers),
We will need to build the container on an interactive work node:

```bash
salloc -A <mygroup> -p <mypartition> -N 1 -n2 --mem=10G --time=2:00:00
# connect to allocated node. Example: ssh n3300
ssh <node_name>
module load apptainer/1.1.5
```

Navigate to this directory then run `make` with the name of container specified:

```bash
cd /path/to/hyak_vnc_apptainer
make CONT_NAME=rockylinux
```

If successful, a container file ending with .sif can be found in the directory
with the same name as the container.
