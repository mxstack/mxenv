##############################################################################
# THIS FILE IS GENERATED BY MXMAKE
#
# DOMAINS:
#: applications.zest-releaser
#: core.base
#: core.mxenv
#: core.mxfiles
#: core.packages
#: docs.sphinx
#: qa.coverage
#: qa.isort
#: qa.mypy
#: qa.ruff
#: qa.test
#
# SETTINGS (ALL CHANGES MADE BELOW SETTINGS WILL BE LOST)
##############################################################################

## core.base

# `deploy` target dependencies.
# No default value.
DEPLOY_TARGETS?=

# target to be executed when calling `make run`
# No default value.
RUN_TARGET?=

# Additional files and folders to remove when running clean target
# No default value.
CLEAN_FS?=

# Optional makefile to include before default targets. This can
# be used to provide custom targets or hook up to existing targets.
# Default: include.mk
INCLUDE_MAKEFILE?=include.mk

# Optional additional directories to be added to PATH in format
# `/path/to/dir/:/path/to/other/dir`. Gets inserted first, thus gets searched
# first.
# No default value.
EXTRA_PATH?=

## core.mxenv

# Primary Python interpreter to use. It is used to create the
# virtual environment if `VENV_ENABLED` and `VENV_CREATE` are set to `true`.
# Default: python3
PRIMARY_PYTHON?=python3

# Minimum required Python version.
# Default: 3.7
PYTHON_MIN_VERSION?=3.7

# Install packages using the given package installer method.
# Supported are `pip` and `uv`. If uv is used, its global availability is
# checked. Otherwise, it is installed, either in the virtual environment or
# using the `PRIMARY_PYTHON`, dependent on the `VENV_ENABLED` setting. If
# `VENV_ENABLED` and uv is selected, uv is used to create the virtual
# environment.
# Default: pip
PYTHON_PACKAGE_INSTALLER?=uv

# Flag whether to use a global installed 'uv' or install
# it in the virtual environment.
# Default: false
MXENV_UV_GLOBAL?=false

# Flag whether to use virtual environment. If `false`, the
# interpreter according to `PRIMARY_PYTHON` found in `PATH` is used.
# Default: true
VENV_ENABLED?=true

# Flag whether to create a virtual environment. If set to `false`
# and `VENV_ENABLED` is `true`, `VENV_FOLDER` is expected to point to an
# existing virtual environment.
# Default: true
VENV_CREATE?=true

# The folder of the virtual environment.
# If `VENV_ENABLED` is `true` and `VENV_CREATE` is true it is used as the
# target folder for the virtual environment. If `VENV_ENABLED` is `true` and
# `VENV_CREATE` is false it is expected to point to an existing virtual
# environment. If `VENV_ENABLED` is `false` it is ignored.
# Default: venv
VENV_FOLDER?=venv

# mxdev to install in virtual environment.
# Default: mxdev
MXDEV?=mxdev@git+https://github.com/mxstack/mxdev.git

# mxmake to install in virtual environment.
# Default: mxmake
MXMAKE?=-e .

## qa.ruff

# Source folder to scan for Python files to run ruff on.
# Default: src
RUFF_SRC?=src

## qa.isort

# Source folder to scan for Python files to run isort on.
# Default: src
ISORT_SRC?=src

## docs.sphinx

# Documentation source folder.
# Default: docs/source
DOCS_SOURCE_FOLDER?=docs/source

# Documentation generation target folder.
# Default: docs/html
DOCS_TARGET_FOLDER?=docs/html

# Documentation Python requirements to be installed (via pip).
# No default value.
DOCS_REQUIREMENTS?=sphinx-conestack-theme myst-parser sphinxcontrib-mermaid

## core.mxfiles

# The config file to use.
# Default: mx.ini
PROJECT_CONFIG?=mx.ini

## core.packages

# Allow prerelease and development versions.
# By default, the package installer only finds stable versions.
# Default: false
PACKAGES_ALLOW_PRERELEASES?=false

## qa.test

# The command which gets executed. Defaults to the location the
# :ref:`run-tests` template gets rendered to if configured.
# Default: .mxmake/files/run-tests.sh
TEST_COMMAND?=.mxmake/files/run-tests.sh

# Additional Python requirements for running tests to be
# installed (via pip).
# Default: pytest
TEST_REQUIREMENTS?=pytest

# Additional make targets the test target depends on.
# No default value.
TEST_DEPENDENCY_TARGETS?=

## qa.coverage

# The command which gets executed. Defaults to the location the
# :ref:`run-coverage` template gets rendered to if configured.
# Default: .mxmake/files/run-coverage.sh
COVERAGE_COMMAND?=.mxmake/files/run-coverage.sh

## qa.mypy

# Source folder for code analysis.
# Default: src
MYPY_SRC?=src

# Mypy Python requirements to be installed (via pip).
# Default: types-setuptools
MYPY_REQUIREMENTS?=types-setuptools types-docutils

## applications.zest-releaser

# Options to pass to zest.releaser prerelease command.
# No default value.
ZEST_RELEASER_PRERELEASE_OPTIONS?=

# Options to pass to zest.releaser release command.
# No default value.
ZEST_RELEASER_RELEASE_OPTIONS?=

# Options to pass to zest.releaser postrelease command.
# No default value.
ZEST_RELEASER_POSTRELEASE_OPTIONS?=

# Options to pass to zest.releaser fullrelease command.
# No default value.
ZEST_RELEASER_FULLRELEASE_OPTIONS?=

##############################################################################
# END SETTINGS - DO NOT EDIT BELOW THIS LINE
##############################################################################

INSTALL_TARGETS?=
DIRTY_TARGETS?=
CLEAN_TARGETS?=
PURGE_TARGETS?=
CHECK_TARGETS?=
TYPECHECK_TARGETS?=
FORMAT_TARGETS?=

export PATH:=$(if $(EXTRA_PATH),$(EXTRA_PATH):,)$(PATH)

# Defensive settings for make: https://tech.davis-hansson.com/p/make/
SHELL:=bash
.ONESHELL:
# for Makefile debugging purposes add -x to the .SHELLFLAGS
.SHELLFLAGS:=-eu -o pipefail -O inherit_errexit -c
.SILENT:
.DELETE_ON_ERROR:
MAKEFLAGS+=--warn-undefined-variables
MAKEFLAGS+=--no-builtin-rules

# mxmake folder
MXMAKE_FOLDER?=.mxmake

# Sentinel files
SENTINEL_FOLDER?=$(MXMAKE_FOLDER)/sentinels
SENTINEL?=$(SENTINEL_FOLDER)/about.txt
$(SENTINEL):
	@mkdir -p $(SENTINEL_FOLDER)
	@echo "Sentinels for the Makefile process." > $(SENTINEL)

##############################################################################
# mxenv
##############################################################################

# Check if given Python is installed
ifeq (,$(shell which $(PRIMARY_PYTHON)))
$(error "PYTHON=$(PRIMARY_PYTHON) not found in $(PATH)")
endif

# Check if given Python version is ok
PYTHON_VERSION_OK=$(shell $(PRIMARY_PYTHON) -c "import sys; print((int(sys.version_info[0]), int(sys.version_info[1])) >= tuple(map(int, '$(PYTHON_MIN_VERSION)'.split('.'))))")
ifeq ($(PYTHON_VERSION_OK),0)
$(error "Need Python >= $(PYTHON_MIN_VERSION)")
endif

# Check if venv folder is configured if venv is enabled
ifeq ($(shell [[ "$(VENV_ENABLED)" == "true" && "$(VENV_FOLDER)" == "" ]] && echo "true"),"true")
$(error "VENV_FOLDER must be configured if VENV_ENABLED is true")
endif

# Check if global python is used with uv (this is not supported by uv)
ifeq ("$(VENV_ENABLED)$(PYTHON_PACKAGE_INSTALLER)","falseuv")
$(error "Package installer uv does not work with a global Python interpreter.")
endif

# Determine the executable path
ifeq ("$(VENV_ENABLED)", "true")
export PATH:=$(abspath $(VENV_FOLDER))/bin:$(PATH)
export VIRTUAL_ENV=$(abspath $(VENV_FOLDER))
MXENV_PYTHON=python
else
MXENV_PYTHON=$(PRIMARY_PYTHON)
endif

# Determine the package installer
ifeq ("$(PYTHON_PACKAGE_INSTALLER)","uv")
PYTHON_PACKAGE_COMMAND=uv pip
else
PYTHON_PACKAGE_COMMAND=$(MXENV_PYTHON) -m pip
endif

MXENV_TARGET:=$(SENTINEL_FOLDER)/mxenv.sentinel
$(MXENV_TARGET): $(SENTINEL)
ifeq ("$(VENV_ENABLED)", "true")
ifeq ("$(VENV_CREATE)", "true")
ifeq ("$(PYTHON_PACKAGE_INSTALLER)$(MXENV_UV_GLOBAL)","uvtrue")
	@echo "Setup Python Virtual Environment using package 'uv' at '$(VENV_FOLDER)'"
	@uv venv -p $(PRIMARY_PYTHON) --seed $(VENV_FOLDER)
else
	@echo "Setup Python Virtual Environment using module 'venv' at '$(VENV_FOLDER)'"
	@$(PRIMARY_PYTHON) -m venv $(VENV_FOLDER)
	@$(MXENV_PYTHON) -m ensurepip -U
endif
endif
else
	@echo "Using system Python interpreter"
endif
ifeq ("$(PYTHON_PACKAGE_INSTALLER)$(MXENV_UV_GLOBAL)","uvfalse")
	@echo "Install uv"
	@$(MXENV_PYTHON) -m pip install uv
endif
	@$(PYTHON_PACKAGE_COMMAND) install -U pip setuptools wheel
	@echo "Install/Update MXStack Python packages"
	@$(PYTHON_PACKAGE_COMMAND) install -U $(MXDEV) $(MXMAKE)
	@touch $(MXENV_TARGET)

.PHONY: mxenv
mxenv: $(MXENV_TARGET)

.PHONY: mxenv-dirty
mxenv-dirty:
	@rm -f $(MXENV_TARGET)

.PHONY: mxenv-clean
mxenv-clean: mxenv-dirty
ifeq ("$(VENV_ENABLED)", "true")
ifeq ("$(VENV_CREATE)", "true")
	@rm -rf $(VENV_FOLDER)
endif
else
	@$(PYTHON_PACKAGE_COMMAND) uninstall -y $(MXDEV)
	@$(PYTHON_PACKAGE_COMMAND) uninstall -y $(MXMAKE)
endif

INSTALL_TARGETS+=mxenv
DIRTY_TARGETS+=mxenv-dirty
CLEAN_TARGETS+=mxenv-clean

##############################################################################
# ruff
##############################################################################

RUFF_TARGET:=$(SENTINEL_FOLDER)/ruff.sentinel
$(RUFF_TARGET): $(MXENV_TARGET)
	@echo "Install Ruff"
	@$(PYTHON_PACKAGE_COMMAND) install ruff
	@touch $(RUFF_TARGET)

.PHONY: ruff-check
ruff-check: $(RUFF_TARGET)
	@echo "Run ruff check"
	@ruff check $(RUFF_SRC)

.PHONY: ruff-format
ruff-format: $(RUFF_TARGET)
	@echo "Run ruff format"
	@ruff format $(RUFF_SRC)

.PHONY: ruff-dirty
ruff-dirty:
	@rm -f $(RUFF_TARGET)

.PHONY: ruff-clean
ruff-clean: ruff-dirty
	@test -e $(MXENV_PYTHON) && $(MXENV_PYTHON) -m pip uninstall -y ruff || :
	@rm -rf .ruff_cache

INSTALL_TARGETS+=$(RUFF_TARGET)
CHECK_TARGETS+=ruff-check
FORMAT_TARGETS+=ruff-format
DIRTY_TARGETS+=ruff-dirty
CLEAN_TARGETS+=ruff-clean

##############################################################################
# isort
##############################################################################

ISORT_TARGET:=$(SENTINEL_FOLDER)/isort.sentinel
$(ISORT_TARGET): $(MXENV_TARGET)
	@echo "Install isort"
	@$(PYTHON_PACKAGE_COMMAND) install isort
	@touch $(ISORT_TARGET)

.PHONY: isort-check
isort-check: $(ISORT_TARGET)
	@echo "Run isort check"
	@isort --check $(ISORT_SRC)

.PHONY: isort-format
isort-format: $(ISORT_TARGET)
	@echo "Run isort format"
	@isort $(ISORT_SRC)

.PHONY: isort-dirty
isort-dirty:
	@rm -f $(ISORT_TARGET)

.PHONY: isort-clean
isort-clean: isort-dirty
	@test -e $(MXENV_PYTHON) && $(MXENV_PYTHON) -m pip uninstall -y isort || :

INSTALL_TARGETS+=$(ISORT_TARGET)
CHECK_TARGETS+=isort-check
FORMAT_TARGETS+=isort-format
DIRTY_TARGETS+=isort-dirty
CLEAN_TARGETS+=isort-clean

##############################################################################
# sphinx
##############################################################################

# additional targets required for building docs.
DOCS_TARGETS+=

SPHINX_BIN=sphinx-build
SPHINX_AUTOBUILD_BIN=sphinx-autobuild

DOCS_TARGET:=$(SENTINEL_FOLDER)/sphinx.sentinel
$(DOCS_TARGET): $(MXENV_TARGET)
	@echo "Install Sphinx"
	@$(PYTHON_PACKAGE_COMMAND) install -U sphinx sphinx-autobuild $(DOCS_REQUIREMENTS)
	@touch $(DOCS_TARGET)

.PHONY: docs
docs: $(DOCS_TARGET) $(DOCS_TARGETS)
	@echo "Build sphinx docs"
	@$(SPHINX_BIN) $(DOCS_SOURCE_FOLDER) $(DOCS_TARGET_FOLDER)

.PHONY: docs-live
docs-live: $(DOCS_TARGET) $(DOCS_TARGETS)
	@echo "Rebuild Sphinx documentation on changes, with live-reload in the browser"
	@$(SPHINX_AUTOBUILD_BIN) $(DOCS_SOURCE_FOLDER) $(DOCS_TARGET_FOLDER)

.PHONY: docs-dirty
docs-dirty:
	@rm -f $(DOCS_TARGET)

.PHONY: docs-clean
docs-clean: docs-dirty
	@test -e $(MXENV_PYTHON) && $(MXENV_PYTHON) -m pip uninstall -y \
		sphinx sphinx-autobuild $(DOCS_REQUIREMENTS) || :
	@rm -rf $(DOCS_TARGET_FOLDER)

INSTALL_TARGETS+=$(DOCS_TARGET)
DIRTY_TARGETS+=docs-dirty
CLEAN_TARGETS+=docs-clean

##############################################################################
# mxfiles
##############################################################################

# case `core.sources` domain not included
SOURCES_TARGET?=

# File generation target
MXMAKE_FILES?=$(MXMAKE_FOLDER)/files

# set environment variables for mxmake
define set_mxfiles_env
	@export MXMAKE_FILES=$(1)
endef

# unset environment variables for mxmake
define unset_mxfiles_env
	@unset MXMAKE_FILES
endef

$(PROJECT_CONFIG):
ifneq ("$(wildcard $(PROJECT_CONFIG))","")
	@touch $(PROJECT_CONFIG)
else
	@echo "[settings]" > $(PROJECT_CONFIG)
endif

LOCAL_PACKAGE_FILES:=$(wildcard pyproject.toml setup.cfg setup.py requirements.txt constraints.txt)

FILES_TARGET:=requirements-mxdev.txt
$(FILES_TARGET): $(PROJECT_CONFIG) $(MXENV_TARGET) $(SOURCES_TARGET) $(LOCAL_PACKAGE_FILES)
	@echo "Create project files"
	@mkdir -p $(MXMAKE_FILES)
	$(call set_mxfiles_env,$(MXMAKE_FILES))
	@mxdev -n -c $(PROJECT_CONFIG)
	$(call unset_mxfiles_env)
	@test -e $(MXMAKE_FILES)/pip.conf && cp $(MXMAKE_FILES)/pip.conf $(VENV_FOLDER)/pip.conf || :
	@touch $(FILES_TARGET)

.PHONY: mxfiles
mxfiles: $(FILES_TARGET)

.PHONY: mxfiles-dirty
mxfiles-dirty:
	@touch $(PROJECT_CONFIG)

.PHONY: mxfiles-clean
mxfiles-clean: mxfiles-dirty
	@rm -rf constraints-mxdev.txt requirements-mxdev.txt $(MXMAKE_FILES)

INSTALL_TARGETS+=mxfiles
DIRTY_TARGETS+=mxfiles-dirty
CLEAN_TARGETS+=mxfiles-clean

##############################################################################
# packages
##############################################################################

# additional sources targets which requires package re-install on change
-include $(MXMAKE_FILES)/additional_sources_targets.mk
ADDITIONAL_SOURCES_TARGETS?=

INSTALLED_PACKAGES=$(MXMAKE_FILES)/installed.txt

ifeq ("$(PACKAGES_ALLOW_PRERELEASES)","true")
ifeq ("$(PYTHON_PACKAGE_INSTALLER)","uv")
PACKAGES_PRERELEASES=--prerelease=allow
else
PACKAGES_PRERELEASES=--pre
endif
else
PACKAGES_PRERELEASES=
endif

PACKAGES_TARGET:=$(INSTALLED_PACKAGES)
$(PACKAGES_TARGET): $(FILES_TARGET) $(ADDITIONAL_SOURCES_TARGETS)
	@echo "Install python packages"
	@$(PYTHON_PACKAGE_COMMAND) install $(PACKAGES_PRERELEASES) -r $(FILES_TARGET)
	@$(PYTHON_PACKAGE_COMMAND) freeze > $(INSTALLED_PACKAGES)
	@touch $(PACKAGES_TARGET)

.PHONY: packages
packages: $(PACKAGES_TARGET)

.PHONY: packages-dirty
packages-dirty:
	@rm -f $(PACKAGES_TARGET)

.PHONY: packages-clean
packages-clean:
	@test -e $(FILES_TARGET) \
		&& test -e $(MXENV_PYTHON) \
		&& $(MXENV_PYTHON) -m pip uninstall -y -r $(FILES_TARGET) \
		|| :
	@rm -f $(PACKAGES_TARGET)

INSTALL_TARGETS+=packages
DIRTY_TARGETS+=packages-dirty
CLEAN_TARGETS+=packages-clean

##############################################################################
# test
##############################################################################

TEST_TARGET:=$(SENTINEL_FOLDER)/test.sentinel
$(TEST_TARGET): $(MXENV_TARGET)
	@echo "Install $(TEST_REQUIREMENTS)"
	@$(PYTHON_PACKAGE_COMMAND) install $(TEST_REQUIREMENTS)
	@touch $(TEST_TARGET)

.PHONY: test
test: $(FILES_TARGET) $(SOURCES_TARGET) $(PACKAGES_TARGET) $(TEST_TARGET) $(TEST_DEPENDENCY_TARGETS)
	@test -z "$(TEST_COMMAND)" && echo "No test command defined" && exit 1 || :
	@echo "Run tests using $(TEST_COMMAND)"
	@/usr/bin/env bash -c "$(TEST_COMMAND)"

.PHONY: test-dirty
test-dirty:
	@rm -f $(TEST_TARGET)

.PHONY: test-clean
test-clean: test-dirty
	@test -e $(MXENV_PYTHON) && $(MXENV_PYTHON) -m pip uninstall -y $(TEST_REQUIREMENTS) || :
	@rm -rf .pytest_cache

INSTALL_TARGETS+=$(TEST_TARGET)
CLEAN_TARGETS+=test-clean
DIRTY_TARGETS+=test-dirty

##############################################################################
# coverage
##############################################################################

COVERAGE_TARGET:=$(SENTINEL_FOLDER)/coverage.sentinel
$(COVERAGE_TARGET): $(TEST_TARGET)
	@echo "Install Coverage"
	@$(PYTHON_PACKAGE_COMMAND) install -U coverage
	@touch $(COVERAGE_TARGET)

.PHONY: coverage
coverage: $(FILES_TARGET) $(SOURCES_TARGET) $(PACKAGES_TARGET) $(COVERAGE_TARGET)
	@test -z "$(COVERAGE_COMMAND)" && echo "No coverage command defined" && exit 1 || :
	@echo "Run coverage using $(COVERAGE_COMMAND)"
	@/usr/bin/env bash -c "$(COVERAGE_COMMAND)"

.PHONY: coverage-dirty
coverage-dirty:
	@rm -f $(COVERAGE_TARGET)

.PHONY: coverage-clean
coverage-clean: coverage-dirty
	@test -e $(MXENV_PYTHON) && $(MXENV_PYTHON) -m pip uninstall -y coverage || :
	@rm -rf .coverage htmlcov

INSTALL_TARGETS+=$(COVERAGE_TARGET)
DIRTY_TARGETS+=coverage-dirty
CLEAN_TARGETS+=coverage-clean

##############################################################################
# mypy
##############################################################################

MYPY_TARGET:=$(SENTINEL_FOLDER)/mypy.sentinel
$(MYPY_TARGET): $(MXENV_TARGET)
	@echo "Install mypy"
	@$(PYTHON_PACKAGE_COMMAND) install mypy $(MYPY_REQUIREMENTS)
	@touch $(MYPY_TARGET)

.PHONY: mypy
mypy: $(PACKAGES_TARGET) $(MYPY_TARGET)
	@echo "Run mypy"
	@mypy $(MYPY_SRC)

.PHONY: mypy-dirty
mypy-dirty:
	@rm -f $(MYPY_TARGET)

.PHONY: mypy-clean
mypy-clean: mypy-dirty
	@test -e $(MXENV_PYTHON) && $(MXENV_PYTHON) -m pip uninstall -y mypy || :
	@rm -rf .mypy_cache

INSTALL_TARGETS+=$(MYPY_TARGET)
TYPECHECK_TARGETS+=mypy
CLEAN_TARGETS+=mypy-clean
DIRTY_TARGETS+=mypy-dirty

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
	@prerelease $(ZEST_RELEASER_PRERELEASE_OPTIONS)

.PHONY: zest-releaser-release
zest-releaser-release: $(ZEST_RELEASER_TARGET)
	@echo "Run release"
	@release $(ZEST_RELEASER_RELEASE_OPTIONS)

.PHONY: zest-releaser-postrelease
zest-releaser-postrelease: $(ZEST_RELEASER_TARGET)
	@echo "Run postrelease"
	@postrelease $(ZEST_RELEASER_POSTRELEASE_OPTIONS)

.PHONY: zest-releaser-fullrelease
zest-releaser-fullrelease: $(ZEST_RELEASER_TARGET)
	@echo "Run fullrelease"
	@fullrelease $(ZEST_RELEASER_FULLRELEASE_OPTIONS)

.PHONY: zest-releaser-dirty
zest-releaser-dirty:
	@rm -f $(ZEST_RELEASER_TARGET)

.PHONY: zest-releaser-clean
zest-releaser-clean: zest-releaser-dirty
	@test -e $(MXENV_PYTHON) && $(MXENV_PYTHON) -m pip uninstall -y zest.releaser || :

INSTALL_TARGETS+=$(ZEST_RELEASER_TARGET)
DIRTY_TARGETS+=zest-releaser-dirty
CLEAN_TARGETS+=zest-releaser-clean

-include $(INCLUDE_MAKEFILE)

##############################################################################
# Default targets
##############################################################################

INSTALL_TARGET:=$(SENTINEL_FOLDER)/install.sentinel
$(INSTALL_TARGET): $(INSTALL_TARGETS)
	@touch $(INSTALL_TARGET)

.PHONY: install
install: $(INSTALL_TARGET)
	@touch $(INSTALL_TARGET)

.PHONY: run
run: $(RUN_TARGET)

.PHONY: deploy
deploy: $(DEPLOY_TARGETS)

.PHONY: dirty
dirty: $(DIRTY_TARGETS)
	@rm -f $(INSTALL_TARGET)

.PHONY: clean
clean: dirty $(CLEAN_TARGETS)
	@rm -rf $(CLEAN_TARGETS) $(MXMAKE_FOLDER) $(CLEAN_FS)

.PHONY: purge
purge: clean $(PURGE_TARGETS)

.PHONY: runtime-clean
runtime-clean:
	@echo "Remove runtime artifacts, like byte-code and caches."
	@find . -name '*.py[c|o]' -delete
	@find . -name '*~' -exec rm -f {} +
	@find . -name '__pycache__' -exec rm -fr {} +

.PHONY: check
check: $(CHECK_TARGETS)

.PHONY: typecheck
typecheck: $(TYPECHECK_TARGETS)

.PHONY: format
format: $(FORMAT_TARGETS)
