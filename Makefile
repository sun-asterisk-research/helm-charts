CHARTS ?= *
REPO ?=
FORCE ?= false
SKIPDEPS ?= false

ifneq ($(filter $(FORCE),true yes),)
	force := -f
endif

ifneq ($(filter $(SKIPDEPS),true yes),)
	skipdeps := true
endif

AUTH := $(shell cat auth 2>/dev/null)

ifneq "$(AUTH)" ""
	auth_parts = $(subst :, ,$(AUTH))
	export auth_str := -u "$(word 1,$(auth_parts))" -p "$(word 2,$(auth_parts))"
endif

dep-update:
ifeq "$(CHARTS)" "*"
	@for chart in charts/*; do \
		echo "Updating $$chart ..."; \
		helm dep update --skip-refresh $$chart; \
	done
else
	@for chart in $(CHARTS); do \
		echo "Updating charts/$$chart ..."; \
		helm dep update --skip-refresh charts/$$chart; \
	done
endif

package:
ifeq "$(CHARTS)" "*"
	helm package charts/* -u -d .deploy
else
	@for chart in $(CHARTS); do \
		helm package charts/$$chart -u -d .deploy \
	; done
endif

cm-push:
ifeq "$(REPO)" ""
	@echo "You must provide a valid ChartMuseum repo URL e.g. \"make cm-push REPO=<your-url>\"" && false
endif
ifeq "$(CHARTS)" "*"
	@for chart in charts/*; do \
		test "$(skipdeps)" || helm dep build $$chart; \
		helm cm-push $(auth_str) $(force) $$chart $(REPO); \
	done
else
	@for chart in $(CHARTS); do \
		test "$(skipdeps)" || helm dep build "charts/$$chart"; \
		helm cm-push $(auth_str) $(force) "charts/$$chart" $(REPO); \
	done
endif

clean:
	rm -r .deploy
