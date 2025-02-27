REPO ?=
CHARTS ?= *
FORCE ?= false
SKIPDEPS ?= false
NOREFRESH ?= true
PACKAGE_DIR ?= .deploy

ifneq ($(filter $(FORCE),true yes 1),)
	_force := true
else
	_force := false
endif

ifneq ($(filter $(SKIPDEPS),true yes 1),)
	_skipdeps := true
else
	_skipdeps := false
endif

ifneq ($(filter $(NOREFRESH),true yes 1),)
	_norefresh := --skip-refresh
endif

ifeq "$(CHARTS)" "*"
	_charts := $(shell find charts/* -maxdepth 0 -type d)
else ifneq "$(CHARTS)" ""
	_charts := $(shell for chart in $(CHARTS); do echo charts/$$chart; done)
endif

AUTH := $(shell cat auth 2>/dev/null)

ifneq "$(AUTH)" ""
# Explicitly set auth flags if an auth file exists
	auth_parts = $(subst :, ,$(AUTH))
	_auth_str := -u "$(word 1,$(auth_parts))" -p "$(word 2,$(auth_parts))"
	_repo := $(REPO)
else ifneq ($(filter $(MAKECMDGOALS),helm-cm-push),)
# Try to get a name from managed Helm repos
	_repo := $(shell helm repo ls | tail -n +2 | grep -E "(^|[[:space:]])$(REPO)($$|[[:space:]])" | awk '{print $$1}')
endif

docs:
	@for chart in $(_charts); do \
		readme-generator -v charts/$$chart/values.yaml -r charts/$$chart/README.md \
	; done

package:
	@for chart in $(_charts); do \
		$(_skipdeps) || helm dep build $$chart $(_norefresh); \
		helm package $$chart -d $(PACKAGE_DIR); \
	done

push:
	@$(MAKE) -s clean PACKAGE_DIR=.tmpdeploy
	@$(MAKE) -s package PACKAGE_DIR=.tmpdeploy
	@$(MAKE) -s push-packaged PACKAGE_DIR=.tmpdeploy
	@$(MAKE) -s clean PACKAGE_DIR=.tmpdeploy

push-packaged:
	@for package in $(PACKAGE_DIR)/*; do \
		name="$$(helm show chart $$package | yq '.name')"; \
		version="$$(helm show chart $$package | yq '.version')"; \
		if [ $(_force) != "true" ]; then \
			if helm show chart $(REPO)/$$name --version "$$version" >/dev/null 2>&1; then \
				echo "ERROR: version $$version already exists for chart $$name"; \
				continue; \
			fi; \
		fi; \
		helm push $$package $(REPO); \
	done

clean:
	@rm -rf $(PACKAGE_DIR)

helm-cm-push:
	@test $(_skipdeps) || helm dep build $(CHART) $(_skiprefresh)
	@helm cm-push $(_auth_str) $(_force) "$(CHART)" $(_repo)

cm-push:
	@test $(_skipdeps) || test $(_skiprefresh) || helm repo update
ifeq "$(CHARTS)" "*"
	@for chart in charts/*; do \
		$(MAKE) --no-print-directory helm-cm-push SKIPREFRESH=true CHART="$$chart" \
	; done
else
	@for chart in $(CHARTS); do \
		$(MAKE) --no-print-directory helm-cm-push SKIPREFRESH=true CHART="charts/$$chart" \
	; done
endif
