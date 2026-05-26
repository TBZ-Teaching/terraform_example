# Terraform Webserver Example

Dies ist ein Beispiel-Projekt für das Modul **Infrastructure as Code**. Es zeigt, wie man mit Terraform einen einfachen Webserver auf AWS bereitstellt und dabei Variablen flexibel einsetzt.

## Inhalt
*   `main.tf`: Die Hauptkonfiguration (Provider & Ressourcen).
*   `vars.tf`: Definition der Eingabevariablen.
*   `outputs.tf`: Definition der Ausgabewerte (z.B. IP-Adresse).
*   `AUFGABEN.md`: **Starte hier!** Die Schritt-für-Schritt Anleitung.
*   `SETUP_GUIDE.md`: Installationsanleitung für alle Tools.
*   `lektionplan_IaC.md`: Didaktisches Konzept für Dozenten (inkl. **45-Minuten-Version**).

## Schnellstart

1.  Installiere die Tools gemäss [SETUP_GUIDE.md](SETUP_GUIDE.md).
2.  Folge den Aufgaben in [AUFGABEN.md](AUFGABEN.md). *Optional: Für den 45-Min-Schnelldurchlauf siehe Hinweise dort.*

## Voraussetzungen
*   Terraform >= 1.2.0
*   AWS Account & Access Keys

## State-Strategie (lokal zuerst, S3 später)

Dieses Projekt kann zuerst mit lokalem State verwendet werden:

```bash
terraform init -backend=false
```

Danach arbeitet Terraform mit `terraform.tfstate` im Projektordner.

Sobald dein S3 Bucket vorhanden ist (z.B. via `bootstrap/`), kannst du den lokalen State nach S3 migrieren:

```bash
terraform init \
	-migrate-state \
	-backend-config="bucket=<DEIN_BUCKET>" \
	-backend-config="key=state/main/terraform.tfstate" \
	-backend-config="region=us-east-1"
```

## GitHub Actions (Terraform Plan/Apply)

Dieses Repo enthält GitHub Workflows für:

*   **terraform-plan**: läuft automatisch bei Pull Requests (und Push auf `main`) und macht `fmt`, `init`, `validate`, `plan`.
	*   Hinweis: Der Plan läuft mit `-refresh=false`, damit er **keine AWS Credentials** braucht.
*   **terraform-apply**: **manuell** auslösbar (Workflow Dispatch) und führt `plan` + `apply` aus.

### Benötigte Secrets

Lege in GitHub unter **Settings → Secrets and variables → Actions → Secrets** folgende Secrets an:

*   `AWS_ACCESS_KEY_ID`
*   `AWS_SECRET_ACCESS_KEY`
*   `AWS_SESSION_TOKEN` (optional, z.B. AWS Academy)
*   `AWS_REGION` (optional, Default ist `us-east-1`)

### Empfohlen: State in S3 persistieren (mit Bootstrap)

Da GitHub Runner nach dem Job gelöscht werden, ist ein persistenter State wichtig, damit Terraform zuverlässig weiterarbeiten kann.

In diesem Repo gibt es dafür einen **Bootstrap-Stack** unter `bootstrap/`, der einen S3 Bucket erstellt.

1.  Einmalig lokal bootstrap ausführen:

		```bash
		cd bootstrap
		terraform init
		terraform apply
		```

2.  Danach im Root-Verzeichnis das S3 Backend nutzen (GitHub Actions macht das automatisch, lokal geht z.B. so):

		```bash
		terraform init \
			-backend=false
		```

		Später Migration auf S3:

		```bash
		terraform init \
			-migrate-state \
			-backend-config="bucket=<DEIN_BUCKET>" \
			-backend-config="key=state/main/terraform.tfstate" \
			-backend-config="region=us-east-1"
		```

Für GitHub Actions werden folgende Secrets verwendet:

*   `TF_STATE_BUCKET` (Name des S3 Buckets)
*   optionaler Input `state_key` beim manuellen Starten des Apply-Workflows (Default: `state/<branch>/terraform.tfstate`)

Ohne `TF_STATE_BUCKET` kann Terraform in GitHub Actions den State nicht persistent halten.

Viel Erfolg!
