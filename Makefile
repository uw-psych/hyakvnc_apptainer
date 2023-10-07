SHELL := /bin/bash
.SHELLFLAGS := -e -O xpg_echo -o errtrace -o functrace -c
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKE := $(make)
DATETIME_FORMAT := %(%Y-%m-%d %H:%M:%S)T
.ONESHELL:
.SUFFIXES:
.DELETE_ON_ERROR:

CONTAINERDIR := $(or $(CONTAINERDIR), ./built_containers)

$(CONTAINERDIR):
	@mkdir -pv $@

#DEFS := $(wildcard */Singularity)
#SIFS := $(addprefix $(CONTAINERDIR)/,$(DEFS:/Singularity=.sif))
#SIFS_SOFTLINKS :=  $(addprefix ,$(DEFS:/Singularity=.sif))
SUBDIRS := $(patsubst %/Singularity,%,$(wildcard */Singularity))

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


.DEFAULT_GOAL := help




${CONTAINERDIR}/%.sif: %/Singularity | $(CONTAINERDIR)
ifeq (, $(shell command -v apptainer 2>/dev/null))
	$(error "No apptainer in $(PATH). If you're on klone, you should be on a compute node")
endif
	apptainer build --fakeroot --fix-perms --warn-unused-build-args --build-arg CONTAINERDIR="$$CONTAINERDIR" $@ $< 
	[ -n "$$APPTAINER_PASSPHRASE" ] && echo "$$APPTAINER_PASSPHRASE" | apptainer sign $@ || echo "Not signing $@"

%.sif: ${CONTAINERDIR}/%.sif | $(CONTAINERDIR)
	ln -sf $< $@

.PHONY: $(SUBDIRS)
#$(SUBDIRS): %: ${CONTAINERDIR}/%.sif ## Build a container
$(SUBDIRS): %: %.sif ## Build a container

#$(SIFS): $(DEFS)


$(CONTAINERDIR)/ubuntu22.04_turbovnc.sif:: $(CONTAINERDIR)/ubuntu22.04_interactive.sif
$(CONTAINERDIR)/ubuntu22.04_xubuntu.sif:: $(CONTAINERDIR)/ubuntu22.04_turbovnc.sif

#$(SUBDIRS): $(DEFS) $(SIFS)

#.PHONY: $(SUBDIRS)

#ubuntu22.04_interactive.sif: ${CONTAINERDIR}/ubuntu22.04_interactive.sif ## Interactive Ubuntu base container
#	ln -sf $< $@

#ubuntu22.04_turbovnc.sif: ubuntu22.04_interactive.sif |${CONTAINERDIR}/ubuntu22.04_turbovnc.sif  ## Interactive Ubuntu base container
#	ln -sf $< $@


#ubuntu22.04_xubuntu: ${CONTAINERDIR}/ubuntu22.04_turbovnc.sif ## Ubuntu with TurboVNC installed
#ubuntu22.04_xubuntu_freesurfer: ${CONTAINERDIR}/ubuntu22.04_xubuntu/ubuntu22.04_xubuntu.sif ## Ubuntu with TurboVNC and FreeSurfer installed

