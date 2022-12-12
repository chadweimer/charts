{{/*
Expand the name of the chart.
*/}}
{{- define "gomp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gomp.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gomp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gomp.labels" -}}
helm.sh/chart: {{ include "gomp.chart" . }}
{{ include "gomp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gomp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gomp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gomp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gomp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of data PVC
*/}}
{{- define "gomp.persistence.data.claimName" -}}
{{- if .Values.persistence.data.existingClaim }}
{{- .Values.persistence.data.existingClaim }}
{{- else }}
{{- $name := include "gomp.fullname" . }}
{{- printf "%s-%s" $name "data" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create the host name of the postgresql database
*/}}
{{- define "postgresql.service.host" -}}
{{- if .Values.postgresql.enabled }}
{{- $name := default "postgresql" .Values.postgresql.nameOverride }}
{{- if .Release.Namespace }}
{{- printf "%s-%s.%s" .Release.Name $name .Release.Namespace | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create the host and port of the postgresql database
*/}}
{{- define "postgresql.baseUrl" -}}
{{- if .Values.postgresql.enabled }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s:%v" (include "postgresql.service.host" .) .Values.postgresql.service.ports.postgresql }}
{{- end }}
{{- end }}
