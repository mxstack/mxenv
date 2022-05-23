#:[install]
#:title = Install
#:description = Install packages with pip after creating files and checking
#:  out sources.
#:depends = sources

###############################################################################
# install
###############################################################################

INSTALLED_PACKAGES=.installed.txt

INSTALL_SENTINEL:=$(SENTINEL_FOLDER)/install.sentinel
$(INSTALL_SENTINEL): $(SOURCES_SENTINEL)
	@echo "Install python packages"
	@$(VENV_FOLDER)/bin/pip install -r requirements-mxdev.txt
	@$(VENV_FOLDER)/bin/pip freeze > $(INSTALLED_PACKAGES)
	@touch $(INSTALL_SENTINEL)

.PHONY: install
install: $(INSTALL_SENTINEL)

.PHONY: install-dirty
install-dirty:
	@rm -f $(INSTALL_SENTINEL)
