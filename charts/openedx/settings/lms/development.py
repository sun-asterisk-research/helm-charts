# -*- coding: utf-8 -*-
import os
from lms.envs.devstack import *

{{ tpl (.Files.Get "settings/partials/common_lms.py") . }}

# Setup correct webpack configuration file for development
WEBPACK_CONFIG_PATH = "webpack.dev.config.js"

SESSION_COOKIE_DOMAIN = ".{{ .Values.baseDomain }}"

LMS_BASE = "{{ include "openedx.lmsDomain" . }}:8000"
LMS_ROOT_URL = "http://{}".format(LMS_BASE)
LMS_INTERNAL_ROOT_URL = LMS_ROOT_URL
SITE_NAME = LMS_BASE
CMS_BASE = "{{ include "openedx.cmsDomain" . }}:8001"
CMS_ROOT_URL = "http://{}".format(CMS_BASE)
LOGIN_REDIRECT_WHITELIST.append(CMS_BASE)

FEATURES['ENABLE_COURSEWARE_MICROFRONTEND'] = False
COMMENTS_SERVICE_URL = "http://{{ include "openedx.fullname" . }}-forum:4567"

LOGGING["loggers"]["oauth2_provider"] = {
    "handlers": ["console"],
    "level": "DEBUG"
}

# Patches openedx-settings-development
AWS_S3_ENDPOINT_URL = "{{- if eq .Values.openedx.enabledHttps true }}https{{ else }}http{{ end }}://{{ include "openedx.minio.host" . }}:9000"
