.PHONY : all clean
SHELL:=/usr/bin/env bash
CONT_NAME ?= rockylinux8

# Usage: $ make [CONT_NAME=<rockylinux8|ubuntu20.04|etc>] [clean]

all: $(CONT_NAME)/$(CONT_NAME).sif

# Build container given proper .def file
%.sif: %.def
	$(eval TMP_DIR=$(shell mktemp -d -p /tmp))
	@echo $(TMP_DIR)
	@cp $< $(TMP_DIR)
	@echo "=================="
	@echo "Building container"
	@echo "=================="
	# Building in /tmp is a workaround for builds failing while in
	# /gscratch/<account>/
	APPTAINER_BIND="" \
		SINGULARITY_BIND="" \
		APPTAINER_BINDPATH="" \
		SINGULARITY_BINDPATH="" \
		apptainer build \
			--fakeroot \
			$(TMP_DIR)/$(CONT_NAME).sif \
			$(TMP_DIR)/$(CONT_NAME).def
	@if [ -f $(TMP_DIR)/$(CONT_NAME).sif ]; then \
		mv $(TMP_DIR)/$(CONT_NAME).sif $@; \
		echo "==========================="; \
		echo "Finished building container"; \
		echo "==========================="; \
	fi
	rm -rf $(TMP_DIR)


clean:
	@rm -rf $(CONT_NAME)/$(CONT_NAME).sif
