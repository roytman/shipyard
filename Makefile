ifneq (,$(DAPPER_HOST_ARCH))

# Running in Dapper

CLUSTERS_ARGS = --cluster_settings $(DAPPER_SOURCE)/scripts/cluster_settings
DEPLOY_ARGS = $(CLUSTERS_ARGS)

include $(SHIPYARD_DIR)/Makefile.inc

TARGETS := $(shell ls -p scripts | grep -v -e /)

# Add any project-specific arguments here
$(TARGETS):
	./scripts/$@

.PHONY: $(TARGETS)

# Project-specific targets go here
validate: vendor/modules.txt

else

# Not running in Dapper

# Shipyard-specific starts
clusters deploy release validate: dapper-image

dapper-image: export SCRIPTS_DIR=./scripts/shared

dapper-image:
	$(SCRIPTS_DIR)/build_image.sh -i shipyard-dapper-base -f package/Dockerfile.dapper-base $(dapper_image_flags)

.DEFAULT_GOAL := validate
# Shipyard-specific ends

include Makefile.dapper

endif

# Disable rebuilding Makefile
Makefile Makefile.dapper Makefile.inc: ;
