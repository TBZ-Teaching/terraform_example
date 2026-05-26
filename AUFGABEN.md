# Praktische Aufgaben: Webserver mit Terraform

Willkommen zum praktischen Teil. In diesem Abschnitt wirst du einen echten Webserver in der AWS Cloud deployen und dabei lernen, wie man Terraform-Variablen nutzt.

## Vorbereitung
Stelle sicher, dass du die Installation gemäss [SETUP_GUIDE.md](SETUP_GUIDE.md) abgeschlossen hast.

## Aufgabe 1: Authentifizierung einrichten

Bevor Terraform mit AWS sprechen kann, müssen wir uns authentifizieren.

**Wichtig:** Verwende IAM-Benutzer, nicht den Root-Account!

### Option A: AWS CLI (Empfohlen)
Wenn du die AWS CLI installiert hast, ist dies der einfachste Weg:

```bash
aws configure
```
Gib nun deine *Access Key ID*, *Secret Access Key* und als Region `us-east-1` ein.

### Option B: Temporäre Credentials (für AWS Academy)
Erstelle die Datei `~/.aws/credentials` (Linux/Mac) oder `%USERPROFILE%\.aws\credentials` (Windows) und füge die Daten aus dem AWS Academy "AWS Details" Fenster ein:

```ini
[default]
aws_access_key_id = <DEIN_KEY>
aws_secret_access_key = <DEIN_SECRET>
aws_session_token = <DEIN_TOKEN>
```

### Option C: Umgebungsvariablen (Schnelltest)
Du kannst die Keys auch direkt im Terminal setzen (gilt nur für das offene Terminal-Fenster):

*Linux/Mac:*
```bash
export AWS_ACCESS_KEY_ID=<DEIN_KEY>
export AWS_SECRET_ACCESS_KEY=<DEIN_SECRET>
# export AWS_SESSION_TOKEN=<DEIN_TOKEN> # Nur bei AWS Academy nötig
```

*Windows:*
```cmd
set AWS_ACCESS_KEY_ID=<DEIN_KEY>
set AWS_SECRET_ACCESS_KEY=<DEIN_SECRET>
# set AWS_SESSION_TOKEN=<DEIN_TOKEN> # Nur bei AWS Academy nötig
```

## Aufgabe 2: Projekt initialisieren

Wechsle im Terminal in das Projektverzeichnis und führe aus:

```bash
terraform init -backend=false
```
Dies lädt den "AWS Provider" herunter. Ein Ordner `.terraform` wird erstellt.

Mit `-backend=false` arbeitet Terraform lokal mit der Datei `terraform.tfstate` im Projektordner.

**Hinweis (späterer Remote State via S3 Backend):**
Wenn du den State später in S3 ablegen willst (für CI/CD empfohlen), führst du zuerst den Bootstrap-Stack aus und migrierst danach den lokalen State.

```bash
cd bootstrap
terraform init
terraform apply

cd ..
terraform init \
    -migrate-state \
    -backend-config="bucket=<DEIN_BUCKET>" \
    -backend-config="key=state/main/terraform.tfstate" \
    -backend-config="region=us-east-1"
```

Damit wird dein bestehender lokaler State in den S3 Bucket verschoben.

## Aufgabe 3: Variablen nutzen (terraform.tfvars)

Wir wollen dem Server einen individuellen Namen geben, damit wir ihn in der AWS Konsole leichter finden.
Dazu nutzen wir die Variable `instance_name`.

Die sauberste Methode, Variablen dauerhaft zu setzen, ist eine Datei namens `terraform.tfvars`.
Terraform liest diese Datei automatisch ein.

1.  Nutze die bestehende Datei `terraform.tfvars` im Projektordner.
2.  Lege deinen Wunschnamen und einen eigenen Port (z.B. 8080 oder 8081) fest:

    ```hcl
    instance_name = "Mein-Web-Server"
    server_port   = 8081
    ```

3.  Führe `terraform plan` aus.
    * Beobachte die Ausgabe: Findest du die Zeile `+ Name = "Mein-Web-Server"` und den neuen Port?

### Zusatz-Info: Variablen überschreiben
Falls du mal schnell etwas testen willst, ohne die Datei zu ändern, kannst du Variablen auch direkt beim Befehl überschreiben. Das hat Vorrang vor der Datei:

```bash
terraform plan -var 'instance_name=Test-Server-Temporary'
```

**Merke die Rangfolge:**
CLI Flag (`-var`) > tfvars Datei > Environment Variable (`TF_VAR_...`) > Default Wert (in `vars.tf`)

## Aufgabe 4: Deployment

Da wir unsere Wunsch-Konfiguration nun in der `terraform.tfvars` Datei haben, ist das Deployment einfach.

1.  Führe den Plan aus:
    ```bash
    terraform plan -out=meinplan
    ```
2.  Wende die Änderungen an:
    ```bash
    terraform apply "meinplan"
    ```
3.  Tippe `yes` (falls nicht vorbestätigt).


## Aufgabe 5: Testen

Prüfe in der AWS Konsole unter EC2 > Instances, ob dein Server wirklich so heisst!

Auch testen wir kurz die Website:
```bash
terraform output public_ip
```
Kopiere die IP und öffne sie im Browser (Standard Port 80, also einfach die IP).

## Aufgabe 6: Der Chaos-Test (Self-Healing)

Terraform überwacht den Zustand deiner Infrastruktur. Was passiert, wenn jemand manuell "pfuscht"?

1.  Gehe in die **AWS Console** -> **EC2** -> **Instances**.
2.  Wähle deine Instanz aus und klicke auf **Instance state** -> **Terminate instance**.
3.  Warte, bis sie weg ist ("Terminated").
4.  Gehe zurück ins Terminal und frage Terraform: "Wie ist die Lage?"
    ```bash
    terraform plan
    ```
5.  **Beobachtung:** Terraform merkt, dass die Realität (kein Server) nicht mehr mit dem Code (ein Server) übereinstimmt. Es wird vorschlagen: `Plan: 1 to add`.
6.  Repariere es:
    ```bash
    terraform apply -auto-approve
    ```
    Der Server ist wieder da! Das nennt man **Self-Healing Infrastructure**.

## Aufgabe 7: Code erweitern

Wir wollen nicht nur den Port, sondern auch den Text auf der Webseite ("Hello World") konfigurieren können.

1.  Definiere eine neue Variable `server_text` in der `vars.tf` (Setze einen Default-Wert).
2.  Gehe in die `main.tf` zum `user_data` Skript.
3.  Ersetze den statischen Text `"Hello World"` durch die Variable `${var.server_text}`.
4.  Setze deinen Wunsch-Text in der `terraform.tfvars`:
    ```hcl
    server_text = "Hallo von meinem Modul 300 Server!"
    ```
5.  Führe `terraform apply` aus. Prüfe die Webseite!

## Aufgabe 8: Denkanstösse (Pipeline & CI/CD)

Stell dir vor, du führst das nicht auf deinem Laptop aus, sondern automatisch in einer Pipeline (GitLab CI / GitHub Actions). Diskutiere folgende Fragen:

1.  **Das Gedächtnis-Problem:** Wenn der Pipeline-Container nach dem Job gelöscht wird, wo bleibt dann deine `terraform.tfstate` Datei?
2.  **Die Sicherheit:** Wie kommen deine AWS Keys in die Pipeline, ohne dass sie im Code stehen?
3.  **Die Gefahr:** Was passiert, wenn zwei Kollegen gleichzeitig einen Commit pushen und zwei Pipelines gleichzeitig `terraform apply` ausführen?

## Aufgabe 9: Aufräumen

Damit keine Kosten entstehen, löschen wir alles wieder.

```bash
terraform destroy
```
Bestätige mit `yes`. 

**Fertig!** Du hast erfolgreich Infrastructure as Code betrieben.
