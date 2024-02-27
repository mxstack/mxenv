#:[zest-releaser]
#:title = zest.releaser
#:description = A collection of command-line programs to help automate the
#:  task of releasing a Python project.
#:depends = core.mxenv
#:
#:[target.zest-releaser-prerelease]
#:description = Run prerelease command of zest.releaser
#:
#:[target.zest-releaser-release]
#:description = Run release command of zest.releaser
#:
#:[target.zest-releaser-postrelease]
#:description = Run postrelease command of zest.releaser
#:
#:[target.zest-releaser-fullrelease]
#:description = Run fullrelease command of zest.releaser
#:
#:[target.zest-releaser-dirty]
#:description = Marks zest.releaser dirty
#:
#:[target.zest-releaser-clean]
#:description = Uninstall zest.releaser.

##############################################################################
# zest-releaser
##############################################################################

ZEST_RELEASER_TARGET:=$(SENTINEL_FOLDER)/zest-releaser.sentinel
$(ZEST_RELEASER_TARGET): $(MXENV_TARGET)
	@echo "Install zest.releaser"
	@$(PYTHON_PACKAGE_COMMAND) install zest.releaser
	@touch $(ZEST_RELEASER_TARGET)

.PHONY: zest-releaser-prerelease
zest-releaser-prerelease: $(ZEST_RELEASER_TARGET)
	@echo "Run prerelease"
	@prerelease

.PHONY: zest-releaser-release
zest-releaser-release: $(ZEST_RELEASER_TARGET)
	@echo "Run release"
	@release

.PHONY: zest-releaser-postrelease
zest-releaser-postrelease: $(ZEST_RELEASER_TARGET)
	@echo "Run postrelease"
	@postrelease

.PHONY: zest-releaser-fullrelease
zest-releaser-fullrelease: $(ZEST_RELEASER_TARGET)
	@echo "Run fullrelease"
	@fullrelease

.PHONY: zest-releaser-dirty
zest-releaser-dirty:
	@rm -f $(ZEST_RELEASER_TARGET)

.PHONY: zest-releaser-clean
zest-releaser-clean: zest-releaser-dirty
	@test -e $(MXENV_PYTHON) && $(MXENV_PYTHON) -m pip uninstall -y zest.releaser || :

INSTALL_TARGETS+=$(ZEST_RELEASER_TARGET)
DIRTY_TARGETS+=zest-releaser-dirty
CLEAN_TARGETS+=zest-releaser-clean
