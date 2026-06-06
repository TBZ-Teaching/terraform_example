# Praktische Aufgaben: CI/CD Pipeline mit GitLab (Terraform + Docker)

Dieses Aufgabenblatt vertieft **Aufgabe 8** aus dem IaC-Teil und setzt sie praktisch um:

- Terraform soll in GitLab CI ausführbar sein
- `terraform plan` läuft automatisch
- `terraform apply` und `terraform destroy` laufen manuell
- Zusätzlich wird ein Docker Image gebaut und in die GitLab Registry gepusht

## Ziel (einfach)

Am Ende läuft in GitLab:

1. Terraform Plan automatisch.
2. Docker Build + Push automatisch auf `main`.
3. Terraform Apply manuell.
4. Terraform Destroy manuell.

## Voraussetzungen

- GitLab Projekt mit CI/CD
- AWS Zugangsdaten
- S3 Bucket für Terraform State

## GitLab Variablen anlegen

Unter **Settings -> CI/CD -> Variables**:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```

Den S3 Bucket setzt du direkt in `.gitlab-ci.yml` in der Variable `TF_STATE_BUCKET`.

## Aufgabe 1: Pipeline-Dateien verwenden

In diesem Repo sind bereits vorbereitet:

- `.gitlab-ci.yml` (Root)
- `cicd/docker/Dockerfile`
- `cicd/docker/.dockerignore`

Du musst nur committen und pushen.

## Aufgabe 2: Erster Testlauf

1. Push auf einen Branch.
2. Öffne GitLab -> CI/CD -> Pipelines.
3. Prüfe: `terraform-plan` läuft automatisch.

## Aufgabe 3: Merge auf main

1. Merge Request erstellen.
2. Nach dem Merge auf `main` prüfen:
   - `terraform-plan` läuft
   - `docker-build-push` läuft
   - Image ist in der GitLab Container Registry sichtbar

## Aufgabe 4: Manuelle Jobs

1. Starte `terraform-apply` manuell in GitLab.
2. Prüfe in AWS, ob Ressourcen erstellt/angepasst wurden.
3. Starte danach `terraform-destroy` manuell.
4. Prüfe in AWS, ob alles gelöscht wurde.

## Merksätze

- `plan` darf automatisch laufen.
- `apply` und `destroy` nur manuell.
- Ohne Remote State (S3) ist CI mit Terraform unzuverlässig.
