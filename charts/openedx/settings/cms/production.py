# -*- coding: utf-8 -*-
import os
from cms.envs.production import *

{{ tpl (.Files.Get "settings/partials/common_cms.py") . }}

ALLOWED_HOSTS = [
    ENV_TOKENS.get("CMS_BASE"),
    "cms",
]
