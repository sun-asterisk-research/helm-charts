####### Settings common to LMS and CMS
import json
import os
import struct
import base64
from Cryptodome.PublicKey import RSA

from xmodule.modulestore.modulestore_settings import update_module_store_settings

def long_to_base64(n):
    def long2intarr(long_int):
        _bytes = []
        while long_int:
            long_int, r = divmod(long_int, 256)
            _bytes.insert(0, r)
        return _bytes

    bys = long2intarr(n)
    data = struct.pack("%sB" % len(bys), *bys)
    if not data:
        data = "\x00"
    s = base64.urlsafe_b64encode(data).rstrip(b"=")
    return s.decode("ascii")

# Mongodb connection parameters: simply modify `mongodb_parameters` to affect all connections to MongoDb.
mongodb_parameters = {
    "host": "{{ include "openedx.mongodb.host" . }}",
    "port": {{ include "openedx.mongodb.port" . }},
    {{ if and .Values.mongodb.auth.username .Values.mongodb.auth.password }}
    "user": "{{ .Values.mongodb.auth.username }}",
    "password": "{{ .Values.mongodb.auth.password }}",
    {{ else }}
    "user": None,
    "password": None,
    {{ end }}
    "db": "{{ .Values.mongodb.auth.database }}",
}
DOC_STORE_CONFIG = mongodb_parameters
CONTENTSTORE = {
    "ENGINE": "xmodule.contentstore.mongo.MongoContentStore",
    "ADDITIONAL_OPTIONS": {},
    "DOC_STORE_CONFIG": DOC_STORE_CONFIG
}
# Load module store settings from config files
update_module_store_settings(MODULESTORE, doc_store_settings=DOC_STORE_CONFIG)
DATA_DIR = "/openedx/data/"
for store in MODULESTORE["default"]["OPTIONS"]["stores"]:
    store["OPTIONS"]["fs_root"] = DATA_DIR

# Behave like memcache when it comes to connection errors
DJANGO_REDIS_IGNORE_EXCEPTIONS = True

DEFAULT_FROM_EMAIL = ENV_TOKENS.get("DEFAULT_FROM_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
DEFAULT_FEEDBACK_EMAIL = ENV_TOKENS.get("DEFAULT_FEEDBACK_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
SERVER_EMAIL = ENV_TOKENS.get("SERVER_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
TECH_SUPPORT_EMAIL = ENV_TOKENS.get("TECH_SUPPORT_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
CONTACT_EMAIL = ENV_TOKENS.get("CONTACT_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
BUGS_EMAIL = ENV_TOKENS.get("BUGS_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
UNIVERSITY_EMAIL = ENV_TOKENS.get("UNIVERSITY_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
PRESS_EMAIL = ENV_TOKENS.get("PRESS_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
PAYMENT_SUPPORT_EMAIL = ENV_TOKENS.get("PAYMENT_SUPPORT_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
BULK_EMAIL_DEFAULT_FROM_EMAIL = ENV_TOKENS.get("BULK_EMAIL_DEFAULT_FROM_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
API_ACCESS_MANAGER_EMAIL = ENV_TOKENS.get("API_ACCESS_MANAGER_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])
API_ACCESS_FROM_EMAIL = ENV_TOKENS.get("API_ACCESS_FROM_EMAIL", ENV_TOKENS["CONTACT_EMAIL"])

# Get rid completely of coursewarehistoryextended, as we do not use the CSMH database
INSTALLED_APPS.remove("lms.djangoapps.coursewarehistoryextended")
DATABASE_ROUTERS.remove(
    "openedx.core.lib.django_courseware_routers.StudentModuleHistoryExtendedRouter"
)

# Set uploaded media file path
MEDIA_ROOT = "/openedx/media/"

# Add your MFE and third-party app domains here
CORS_ORIGIN_WHITELIST = []

# Video settings
VIDEO_IMAGE_SETTINGS["STORAGE_KWARGS"]["location"] = MEDIA_ROOT
VIDEO_TRANSCRIPTS_SETTINGS["STORAGE_KWARGS"]["location"] = MEDIA_ROOT

GRADES_DOWNLOAD = {
    "STORAGE_TYPE": "",
    "STORAGE_KWARGS": {
        "base_url": "/media/grades/",
        "location": "/openedx/media/grades",
    },
}

ORA2_FILEUPLOAD_BACKEND = "filesystem"
ORA2_FILEUPLOAD_ROOT = "/openedx/data/ora2"
ORA2_FILEUPLOAD_CACHE_NAME = "ora2-storage"

# Change syslog-based loggers which don't work inside docker containers
LOGGING["handlers"]["local"] = {
    "class": "logging.handlers.WatchedFileHandler",
    "filename": os.path.join(LOG_DIR, "all.log"),
    "formatter": "standard",
}
LOGGING["handlers"]["tracking"] = {
    "level": "DEBUG",
    "class": "logging.handlers.WatchedFileHandler",
    "filename": os.path.join(LOG_DIR, "tracking.log"),
    "formatter": "standard",
}
LOGGING["loggers"]["tracking"]["handlers"] = ["console", "local", "tracking"]

# Email
EMAIL_USE_SSL = {{ .Values.smtp.useSsl }}
# Forward all emails from edX's Automated Communication Engine (ACE) to django.
ACE_ENABLED_CHANNELS = ["django_email"]
ACE_CHANNEL_DEFAULT_EMAIL = "django_email"
ACE_CHANNEL_TRANSACTIONAL_EMAIL = "django_email"
EMAIL_FILE_PATH = "/tmp/openedx/emails"

LOCALE_PATHS.append("/openedx/locale/contrib/locale")
LOCALE_PATHS.append("/openedx/locale/user/locale")

# Allow the platform to include itself in an iframe
X_FRAME_OPTIONS = "SAMEORIGIN"

jwt_rsa_key = RSA.import_key("""{{ .Values.openedx.jwt.privateKey }}""".encode())
JWT_AUTH["JWT_ISSUER"] = "{{ include "openedx.jwt.issuer" . }}"
JWT_AUTH["JWT_AUDIENCE"] = "{{ .Values.openedx.jwt.common.audience }}"
JWT_AUTH["JWT_SECRET_KEY"] = "{{ .Values.openedx.jwt.common.secret_key }}"
JWT_AUTH["JWT_PRIVATE_SIGNING_JWK"] = json.dumps(
    {
        "kid": "openedx",
        "kty": "RSA",
        "e": long_to_base64(jwt_rsa_key.e),
        "d": long_to_base64(jwt_rsa_key.d),
        "n": long_to_base64(jwt_rsa_key.n),
        "p": long_to_base64(jwt_rsa_key.p),
        "q": long_to_base64(jwt_rsa_key.q),
    }
)
JWT_AUTH["JWT_PUBLIC_SIGNING_JWK_SET"] = json.dumps(
    {
        "keys": [
            {
                "kid": "openedx",
                "kty": "RSA",
                "e": long_to_base64(jwt_rsa_key.e),
                "n": long_to_base64(jwt_rsa_key.n),
    }
        ]
    }
)
JWT_AUTH["JWT_ISSUERS"] = [
    {
        "ISSUER": "{{ include "openedx.jwt.issuer" . }}",
        "AUDIENCE": "{{ .Values.openedx.jwt.common.audience }}",
        "SECRET_KEY": "{{ include "openedx.secretKey" . }}"
    }
]

# Patches openedx-common-settings

DEFAULT_FILE_STORAGE = "storages.backends.s3boto3.S3Boto3Storage"
VIDEO_IMAGE_SETTINGS["STORAGE_KWARGS"]["location"] = VIDEO_IMAGE_SETTINGS["STORAGE_KWARGS"]["location"].lstrip("/")
VIDEO_TRANSCRIPTS_SETTINGS["STORAGE_KWARGS"]["location"] = VIDEO_TRANSCRIPTS_SETTINGS["STORAGE_KWARGS"]["location"].lstrip("/")
GRADES_DOWNLOAD["STORAGE_KWARGS"]["location"] = GRADES_DOWNLOAD["STORAGE_KWARGS"]["location"].lstrip("/")

# Ora2 setting
ORA2_FILEUPLOAD_BACKEND = "s3"
FILE_UPLOAD_STORAGE_BUCKET_NAME = "{{ .Values.openedx.aws.minio.fileUpload }}"

AWS_S3_SIGNATURE_VERSION = "s3v4"
AWS_S3_ENDPOINT_URL = "{{- if eq .Values.openedx.enabledHttps true }}https{{ else }}http{{ end }}://{{ include "openedx.minio.host" . }}:9000"
AWS_AUTO_CREATE_BUCKET = False # explicit is better than implicit
AWS_DEFAULT_ACL = None
AWS_QUERYSTRING_EXPIRE = 7 * 24 * 60 * 60  # 1 week: this is necessary to generate valid download urls

######## End of settings common to LMS and CMS
