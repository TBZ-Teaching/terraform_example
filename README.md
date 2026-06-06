# Terraform Webserver Example

Dies ist ein Beispiel-Projekt für das Modul **Infrastructure as Code**. Es zeigt, wie man mit Terraform einen einfachen Webserver auf AWS bereitstellt und dabei Variablen flexibel einsetzt.

## Inhalt
*   `terraform/`: Terraform Root-Modul (Hauptkonfiguration).
*   `terraform/bootstrap/`: Bootstrap Stack für S3 Backend.
*   `.gitlab-ci.yml`: GitLab Pipeline Definition (im Root).
*   `cicd/docker/`: Dockerfile und `.dockerignore`.
*   `terraform/AUFGABEN.md`: **Starte hier!** Die Terraform-Schritt-für-Schritt Anleitung.
*   `cicd/AUFGABEN_CICD.md`: CI/CD Aufgabenblatt (GitLab + Docker Registry).
*   `SETUP_GUIDE.md`: Installationsanleitung für alle Tools.

## Schnellstart

1.  Installiere die Tools gemäss [SETUP_GUIDE.md](SETUP_GUIDE.md).
2.  Folge den Aufgaben in [terraform/AUFGABEN.md](terraform/AUFGABEN.md). *Optional: Für den 45-Min-Schnelldurchlauf siehe Hinweise dort.*
3.  Vertiefe mit [cicd/AUFGABEN_CICD.md](cicd/AUFGABEN_CICD.md) die Pipeline-Themen aus Aufgabe 8.

## Voraussetzungen
*   Terraform >= 1.2.0
*   AWS Account & Access Keys

## State-Strategie (lokal zuerst, S3 später)

Dieses Projekt kann zuerst mit lokalem State verwendet werden:

```bash
cd terraform
terraform init -backend=false
```

Danach arbeitet Terraform mit `terraform.tfstate` im Projektordner.

Sobald dein S3 Bucket vorhanden ist (z.B. via `terraform/bootstrap/`), kannst du den lokalen State nach S3 migrieren:

```bash
cd terraform
terraform init \
	-migrate-state \
	-backend-config="bucket=<DEIN_BUCKET>" \
	-backend-config="key=state/main/terraform.tfstate" \
	-backend-config="region=us-east-1"
```

## GitLab CI/CD (Terraform + Docker)

Dieses Repo nutzt GitLab CI/CD über die Datei `.gitlab-ci.yml` im Root.

Pipeline-Verhalten:

*   **terraform-plan**: läuft automatisch auf Branches und Merge Requests.
*   **docker-build-push**: läuft automatisch auf `main` und pusht in die GitLab Registry.
*   **terraform-apply**: manuell auf `main`.
*   **terraform-destroy**: manuell auf `main`.

### Benötigte Variablen in GitLab

Lege in GitLab unter **Settings -> CI/CD -> Variables** folgende Variablen an:

*   `AWS_ACCESS_KEY_ID`
*   `AWS_SECRET_ACCESS_KEY`
*   `AWS_SESSION_TOKEN`

Der Name des S3 Buckets wird direkt in `.gitlab-ci.yml` über `TF_STATE_BUCKET` gesetzt.

### Empfohlen: State in S3 persistieren (mit Bootstrap)

Da GitLab Runner nach dem Job gelöscht werden, ist ein persistenter State wichtig, damit Terraform zuverlässig weiterarbeiten kann.

In diesem Repo gibt es dafür einen **Bootstrap-Stack** unter `terraform/bootstrap/`, der einen S3 Bucket erstellt.

1.  Einmalig lokal bootstrap ausführen:

		```bash
		cd terraform/bootstrap
		terraform init
		terraform apply
		```

2.  Danach den State im Hauptstack auf S3 migrieren:

		```bash
		cd ../
		terraform init \
			-migrate-state \
			-backend-config="bucket=<DEIN_BUCKET>" \
			-backend-config="key=state/main/terraform.tfstate" \
			-backend-config="region=us-east-1"
		```

Wenn `TF_STATE_BUCKET` in `.gitlab-ci.yml` nicht korrekt gesetzt ist, kann Terraform in GitLab CI/CD den State nicht persistent halten.

Viel Erfolg!
