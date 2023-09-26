SHELL := /usr/bin/env bash
.SHELLFLAGS := -eo pipefail -O xpg_echo -o errtrace -o functrace -c
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKE := $(make)
DATETIME_FORMAT := %(%Y-%m-%d %H:%M:%S)T

.SUFFIXES:
.DELETE_ON_ERROR:

APPTAINER_BIN ?= $(shell command -v apptainer 2>/dev/null || command -v singularity 2>/dev/null)
SUBDIRS     ?= $(patsubst %/Singularity,%,$(wildcard */Singularity))

.PHONY: help
help:  ## Prints this usage.
	@printf '== Recipes ==\n' && grep --no-filename -E '^[a-zA-Z0-9-]+:' $(MAKEFILE_LIST) && echo '\n== Images ==' && echo $(SUBDIRS) | tr ' ' '\n' 
# see https://www.gnu.org/software/make/manual/html_node/Origin-Function.html
MAKEFILE_ORIGINS := \
	default \
	environment \
	environment\ override \
	file \
	command\ line \
	override \
	automatic \
	\%

PRINTVARS_MAKEFILE_ORIGINS_TARGETS += \
	$(patsubst %,printvars/%,$(MAKEFILE_ORIGINS)) \

.PHONY: $(PRINTVARS_MAKEFILE_ORIGINS_TARGETS)
$(PRINTVARS_MAKEFILE_ORIGINS_TARGETS):
	@$(foreach V, $(sort $(.VARIABLES)), \
		$(if $(filter $(@:printvars/%=%), $(origin $V)), \
			$(info $V=$($V) ($(value $V)))))

.PHONY: printvars
printvars: printvars/file ## Print all Makefile variables (file origin).

.PHONY: printvar-%
printvar-%: ## Print one Makefile variable.
	@echo '($*)'
	@echo '  origin = $(origin $*)'
	@echo '  flavor = $(flavor $*)'
	@echo '   value = $(value  $*)'


$(SUBDIRS):
	cd $@ && $(APPTAINER_BIN) build $@.sif Singularity 

.PHONY: $(SUBDIRS)

ubuntu22.04_xubuntu: ubuntu22.04_interactive/ubuntu22.04_interactive.sif

ubuntu22.04_xubuntu_freesurfer: ubuntu22.04_xubuntu/ubuntu22.04_xubuntu.sif