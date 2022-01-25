{{/* Define the configmap */}}
{{- define "docspell-joex.configmap" -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: docspell-joex-env
data:
  DOCSPELL_JOEX_JDBC_USER: "{{ .Values.postgresql.postgresqlUsername }}"
  {{/* General */}}
  DOCSPELL_JOEX_APP__ID: "joex-{{ randAlphaNum 10 }}"
  DOCSPELL_JOEX_FILES_CHUNK__SIZE: "{{ .Values.joex.app.chunk_size }}"
  DOCSPELL_JOEX_BASE__URL: "{{ .Values.joex.app.base_url }}"
  DOCSPELL_JOEX_BIND_ADDRESS: "{{ .Values.joex.app.bind_address }}"
  DOCSPELL_JOEX_BIND_PORT: "{{ .Values.service.joex.ports.joex.port }}"
  {{/* Mail */}}
  DOCSPELL_JOEX_MAIL__DEBUG: "{{ .Values.joex.mail.debug_enabled }}"
  DOCSPELL_JOEX_SEND__MAIL_LIST__ID: "{{ .Values.joex.mail.send_mail_list_id }}"
  {{/* SOLR */}}
  DOCSPELL_JOEX_FULL__TEXT__SEARCH_ENABLED: "{{ .Values.joex.solr.enabled }}"
  DOCSPELL_JOEX_FULL__TEXT__SEARCH_SOLR_URL: "http://{{ include "common.names.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.service.solr.ports.solr.port }}/solr/docspell"
  DOCSPELL_JOEX_FULL__TEXT__SEARCH_SOLR_COMMIT__WITHIN: "{{ .Values.joex.solr.commit_within }}"
  DOCSPELL_JOEX_FULL__TEXT__SEARCH_SOLR_DEF__TYPE: "{{ .Values.joex.solr.parser }}"
  DOCSPELL_JOEX_FULL__TEXT__SEARCH_SOLR_Q__OP: "{{ .Values.joex.solr.combiner }}"
  DOCSPELL_JOEX_FULL__TEXT__SEARCH_MIGRATION_INDEX__ALL__CHUNK: "{{ .Values.joex.solr.index_chunk }}"
  DOCSPELL_JOEX_FULL__TEXT__SEARCH_SOLR_LOG__VERBOSE: "{{ .Values.joex.solr.logs_verbose }}"
  {{/* Convert */}}
  DOCSPELL_JOEX_CONVERT_CHUNK__SIZE: "{{ .Values.joex.convert.chunk_size }}"
  DOCSPELL_JOEX_CONVERT_CONVERTED__FILENAME__PART: "{{ .Values.joex.convert.converted_filename_part }}"
  DOCSPELL_JOEX_CONVERT_DECRYPT__PDF_ENABLED: "{{ .Values.joex.convert.decrypt_pdf_enabled }}"
  DOCSPELL_JOEX_CONVERT_MARKDOWN_INTERNAL__CSS: "{{ .Values.joex.convert.md_internal_css }}"
  DOCSPELL_JOEX_CONVERT_MAX__IMAGE__SIZE: "{{ .Values.joex.convert.md_internal_css }}"
  DOCSPELL_JOEX_CONVERT_OCRMYPDF_ENABLED: "{{ .Values.joex.convert.ocrmypdf_enabled }}"
  DOCSPELL_JOEX_CONVERT_OCRMYPDF_COMMAND_PROGRAM: "{{ .Values.joex.convert.ocrmypdf_cmd_program }}"
  DOCSPELL_JOEX_CONVERT_OCRMYPDF_COMMAND_TIMEOUT: "{{ .Values.joex.convert.ocrmypdf_cmd_timeout }}"
  DOCSPELL_JOEX_CONVERT_OCRMYPDF_WORKING__DIR: "{{ .Values.joex.convert.ocrmypdf_workdir }}"
  DOCSPELL_JOEX_CONVERT_TESSERACT_COMMAND_PROGRAM: "{{ .Values.joex.convert.tesseract_cmd_program }}"
  DOCSPELL_JOEX_CONVERT_TESSERACT_COMMAND_TIMEOUT: "{{ .Values.joex.convert.tesseract_cmd_timeout }}"
  DOCSPELL_JOEX_CONVERT_TESSERACT_WORKING__DIR: "{{ .Values.joex.convert.tesseract_workdir }}"
  DOCSPELL_JOEX_CONVERT_UNOCONV_COMMAND_PROGRAM: "{{ .Values.joex.convert.unoconv_cmd_program}}"
  DOCSPELL_JOEX_CONVERT_UNOCONV_COMMAND_TIMEOUT: "{{ .Values.joex.convert.unoconv_cmd_timeout }}"
  DOCSPELL_JOEX_CONVERT_UNOCONV_WORKING__DIR: "{{ .Values.joex.convert.unoconv_workdir }}"
  DOCSPELL_JOEX_CONVERT_WKHTMLPDF_COMMAND_PROGRAM: "{{ .Values.joex.convert.wkhtmlpdf_cmd_program }}"
  DOCSPELL_JOEX_CONVERT_WKHTMLPDF_COMMAND_TIMEOUT: "{{ .Values.joex.convert.wkhtmlpdf_cmd_timeout }}"
  DOCSPELL_JOEX_CONVERT_WKHTMLPDF_WORKING__DIR: "{{ .Values.joex.convert.whhtmlpdf_workdir }}"
  {{/* Extraction */}}
  DOCSPELL_JOEX_EXTRACTION_OCR_GHOSTSCRIPT_COMMAND_PROGRAM: "{{ .Values.joex.extraction.gs_cmd }}"
  DOCSPELL_JOEX_EXTRACTION_OCR_GHOSTSCRIPT_COMMAND_TIMEOUT: "{{ .Values.joex.extraction.gs_cmd_timeout }}"
  DOCSPELL_JOEX_EXTRACTION_OCR_GHOSTSCRIPT_WORKING__DIR: "{{ .Values.joex.extraction.gs_workdir }}"
  DOCSPELL_JOEX_EXTRACTION_OCR_MAX__IMAGE__SIZE: "{{ .Values.joex.extraction.max_image_size }}"
  DOCSPELL_JOEX_EXTRACTION_OCR_PAGE__RANGE_BEGIN: "{{ .Values.joex.extraction.page_range_begin }}"
  DOCSPELL_JOEX_EXTRACTION_OCR_TESSERACT_COMMAND_PROGRAM: "{{ .Values.joex.extraction.tesseract_cmd_program }}"
  DOCSPELL_JOEX_EXTRACTION_OCR_TESSERACT_COMMAND_TIMEOUT: "{{ .Values.joex.extraction.tesseract_cmd_timeout }}"
  DOCSPELL_JOEX_EXTRACTION_OCR_UNPAPER_COMMAND_PROGRAM: "{{ .Values.joex.extraction.unpaper_cmd_program }}"
  DOCSPELL_JOEX_EXTRACTION_OCR_UNPAPER_COMMAND_TIMEOUT: "{{ .Values.joex.extraction.unpaper_cmd_timeout }}"
  DOCSPELL_JOEX_EXTRACTION_PDF_MIN__TEXT__LEN: "{{ .Values.joex.extraction.pdf_min_text_length }}"
  DOCSPELL_JOEX_EXTRACTION_PREVIEW_DPI: "{{ .Values.joex.extraction.preview_dpi }}"
  {{/* House Keeping */}}
  DOCSPELL_JOEX_HOUSE__KEEPING_CHECK__NODES_ENABLED: "{{ .Values.joex.housekeeping.check_nodes_enabled }}"
  DOCSPELL_JOEX_HOUSE__KEEPING_CHECK__NODES_MIN__NOT__FOUND: "{{ .Values.joex.housekeeping.check_nodes_min_not_found }}"
  DOCSPELL_JOEX_HOUSE__KEEPING_CLEANUP__INVITES_ENABLED: "{{ .Values.joex.housekeeping.cleanup_invites_enabled }}"
  DOCSPELL_JOEX_HOUSE__KEEPING_CLEANUP__INVITES_OLDER__THAN: "{{ .Values.joex.housekeeping.cleanup_invites_older_than }}"
  DOCSPELL_JOEX_HOUSE__KEEPING_CLEANUP__JOBS_ENABLED: "{{ .Values.joex.housekeeping.cleanup_jobs_enabled }}"
  DOCSPELL_JOEX_HOUSE__KEEPING_CLEANUP__JOBS_DELETE__BATCH: "{{ .Values.joex.housekeeping.cleanup_jobs_delete_batch }}"
  DOCSPELL_JOEX_HOUSE__KEEPING_CLEANUP__JOBS_OLDER__THAN: "{{ .Values.joex.housekeeping.cleanup_jobs_older_than }}"
  DOCSPELL_JOEX_HOUSE__KEEPING_CLEANUP__REMEMBER__ME_ENABLED: "{{ .Values.joex.housekeeping.cleanup_remember_me_enabled }}"
  DOCSPELL_JOEX_HOUSE__KEEPING_CLEANUP__REMEMBER__ME_OLDER__THAN: "{{ .Values.joex.housekeeping.cleanup_remember_me_older_than }}"
  DOCSPELL_JOEX_HOUSE__KEEPING_SCHEDULE: "{{ .Values.joex.housekeeping.schedule }}"
  {{/* Scheduler */}}
  DOCSPELL_JOEX_PERIODIC__SCHEDULER_NAME: "{{ .Values.joex.scheduler.periodic_name }}"
  DOCSPELL_JOEX_PERIODIC__SCHEDULER_WAKEUP__PERIOD: "{{ .Values.joex.scheduler.periodic_wakeup_period }}"
  DOCSPELL_JOEX_SCHEDULER_COUNTING__SCHEME: "{{ .Values.joex.scheduler.counting_scheme }}"
  DOCSPELL_JOEX_SCHEDULER_LOG__BUFFER__SIZE: "{{ .Values.joex.scheduler.log_buffer_size }}"
  DOCSPELL_JOEX_SCHEDULER_NAME: "{{ .Values.joex.scheduler.name }}"
  DOCSPELL_JOEX_SCHEDULER_POOL__SIZE: "{{ .Values.joex.scheduler.pool_size }}"
  DOCSPELL_JOEX_SCHEDULER_RETRIES: "{{ .Values.joex.scheduler.retries }}"
  DOCSPELL_JOEX_SCHEDULER_RETRY__DELAY: "{{ .Values.joex.scheduler.retry_delay }}"
  DOCSPELL_JOEX_SCHEDULER_WAKEUP__PERIOD: "{{ .Values.joex.scheduler.wakeup_period }}"
  {{/* Text Analysis */}}
  DOCSPELL_JOEX_TEXT__ANALYSIS_CLASSIFICATION_ENABLED: "{{ .Values.joex.textanalysis.classification_enabled }}"
  DOCSPELL_JOEX_TEXT__ANALYSIS_CLASSIFICATION_ITEM__COUNT: "{{ .Values.joex.textanalysis.classification_item_count }}"
  DOCSPELL_JOEX_TEXT__ANALYSIS_MAX__LENGTH: "{{ .Values.joex.textanalysis.max_length }}"
  DOCSPELL_JOEX_TEXT__ANALYSIS_NLP_CLEAR__INTERVAL: "{{ .Values.joex.textanalysis.nlp_clear_interval }}"
  DOCSPELL_JOEX_TEXT__ANALYSIS_NLP_MAX__DUE__DATE__YEARS: "{{ .Values.joex.textanalysis.nlp_max_due_date_years }}"
  DOCSPELL_JOEX_TEXT__ANALYSIS_NLP_MODE: "{{ .Values.joex.textanalysis.nlp_mode }}"
  DOCSPELL_JOEX_TEXT__ANALYSIS_NLP_REGEX__NER_FILE__CACHE__TIME: "{{ .Values.joex.textanalysis.nlp_regex_ner_file_cache_time }}"
  DOCSPELL_JOEX_TEXT__ANALYSIS_NLP_REGEX__NER_MAX__ENTRIES: "{{ .Values.joex.textanalysis.nlp_regex_ner_max_entries }}"
  DOCSPELL_JOEX_TEXT__ANALYSIS_WORKING__DIR: "{{ .Values.joex.textanalysis.workdir }}"
  {{/* Update Check */}}
  DOCSPELL_JOEX_UPDATE__CHECK_ENABLED: "{{ .Values.joex.updatecheck.enabled }}"
  DOCSPELL_JOEX_UPDATE__CHECK_BODY: "{{ .Values.joex.updatecheck.body }}"
  DOCSPELL_JOEX_UPDATE__CHECK_SCHEDULE: "{{ .Values.joex.updatecheck.schedule }}"
  DOCSPELL_JOEX_UPDATE__CHECK_SENDER__ACCOUNT: "{{ .Values.joex.updatecheck.sender_account }}"
  DOCSPELL_JOEX_UPDATE__CHECK_SMTP__ID: "{{ .Values.joex.updatecheck.smtp_id }}"
  DOCSPELL_JOEX_UPDATE__CHECK_SUBJECT: "{{ .Values.joex.updatecheck.subject }}"
  DOCSPELL_JOEX_UPDATE__CHECK_TEST__RUN: "{{ .Values.joex.updatecheck.test_run }}"
  {{/* User Tasks */}}
  DOCSPELL_JOEX_USER__TASKS_SCAN__MAILBOX_MAIL__CHUNK__SIZE: "{{ .Values.joex.usertasks.scan_mailbox_chunk_size }}"
  DOCSPELL_JOEX_USER__TASKS_SCAN__MAILBOX_MAX__FOLDERS: "{{ .Values.joex.usertasks.scan_mailbox_max_folders }}"
  DOCSPELL_JOEX_USER__TASKS_SCAN__MAILBOX_MAX__MAILS: "{{ .Values.joex.usertasks.scan_mailbox_max_mails }}"
{{- end -}}
