#:[system-dependencies]
#:title = System dependencies
#:description = System dependency management.
#:depends = base
#:
#:[target.system-dependencies]
#:description = Install system dependencies.
#:
#:[setting.SYSTEM_DEPENDENCIES]
#:description = Space separated system package names.
#:default =

###############################################################################
# system dependencies
###############################################################################

SYSTEM_DEPENDENCIES?=

.PHONY: system-dependencies
system-dependencies:
	@echo "Install system dependencies"
	@test -z "$(SYSTEM_DEPENDENCIES)" && echo "No System dependencies defined"
	@test -z "$(SYSTEM_DEPENDENCIES)" \
		|| sudo apt-get install -y $(SYSTEM_DEPENDENCIES)
