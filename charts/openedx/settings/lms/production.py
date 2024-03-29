# -*- coding: utf-8 -*-
import os
from lms.envs.production import *

{{ tpl (.Files.Get "settings/partials/common_lms.py") . }}

ALLOWED_HOSTS = [
    ENV_TOKENS.get("LMS_BASE"),
    FEATURES["PREVIEW_LMS_BASE"],
    "lms",
]

{{- if eq .Values.openedx.enabledHttps true }}
# Properly set the "secure" attribute on session/csrf cookies. This is required in
# Chrome to support samesite=none cookies.
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
DCS_SESSION_COOKIE_SAMESITE = "None"
{{ else }}
# When we cannot provide secure session/csrf cookies, we must disable samesite=none
SESSION_COOKIE_SECURE = False
CSRF_COOKIE_SECURE = False
DCS_SESSION_COOKIE_SAMESITE = "Lax"
{{ end }}

# Required to display all courses on start page
SEARCH_SKIP_ENROLLMENT_START_DATE_FILTERING = True
