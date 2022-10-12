CHARTS ?= *
REPO ?=
FORCE ?= false
SKIPDEPS ?= false
SKIPREFRESH ?= false

ifneq ($(filter $(FORCE),true yes),)
	_force := -f
endif

ifneq ($(filter $(SKIPDEPS),true yes),)
	_skipdeps := true
endif

ifneq ($(filter $(SKIPREFRESH),true yes),)
	_skiprefresh := --skip-refresh
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
	@for chart in $(CHARTS); do \
		readme-generator -v charts/$$chart/values.yaml -r charts/$$chart/README.md \
	; done

package:
ifeq "$(CHARTS)" "*"
	@helm package charts/* -u -d .deploy
else
	@for chart in $(CHARTS); do \
		helm package charts/$$chart -u -d .deploy \
	; done
endif

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

push-packaged:
	for package in .deploy/*; do \
		helm push $(_force) $$package $(REPO) \
	; done

clean:
	rm -r .deploy
