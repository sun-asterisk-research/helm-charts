# -*- coding: utf-8 -*-
import os
from cms.envs.devstack import *

LMS_BASE = "{{ include "openedx.cmsDomain" . }}:8000"
LMS_ROOT_URL = "http://" + LMS_BASE
FEATURES["PREVIEW_LMS_BASE"] = "preview." + LMS_BASE

{{ tpl (.Files.Get "settings/partials/common_cms.py") . }}

# Setup correct webpack configuration file for development
WEBPACK_CONFIG_PATH = "webpack.dev.config.js"

# Patches openedx-settings-development
AWS_S3_ENDPOINT_URL = "{{- if eq .Values.openedx.enabledHttps true }}https{{- else }}http{{ end }}://{{ include "openedx.minio.host" . }}:9000"
