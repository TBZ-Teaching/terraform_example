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
terraform init
```
Dies lädt den "AWS Provider" herunter. Ein Ordner `.terraform` wird erstellt.

## Aufgabe 3: Variablen verstehen & nutzen

*(Hinweis für Eilige: Wähle nur **eine** der folgenden Methoden 3.1 bis 3.3 aus!)*

Wir wollen dem Server einen individuellen Namen geben, damit wir ihn in der AWS Konsole leichter finden.
Dazu nutzen wir die Variable `instance_name`.

### 3.1 CLI Flag (Die "Mal eben schnell"-Methode)
Wir überschreiben den Namen direkt beim Befehl:

```bash
terraform plan -var 'instance_name=Mein-Test-Server'
```
* Beobachte die Ausgabe: Findest du die Zeile `+ Name = "Mein-Test-Server"`?

### 3.2 Environment Variable (Die "Pipeline"-Methode)
Terraform liest automatisch Variablen, die mit `TF_VAR_` beginnen.

```bash
# Linux/Mac
export TF_VAR_instance_name=Server-Aus-Env-Var

# Windows
set TF_VAR_instance_name=Server-Aus-Env-Var

# Testen
terraform plan
```
* Beobachte: Wird der neue Name übernommen?

### 3.3 tfvars Datei (Die "Persistente"-Methode)
Erstelle eine Datei namens `terraform.tfvars` im selben Ordner:

```hcl
instance_name = "Server-Aus-Datei"
```
Führe erneut `terraform plan` aus.
* Frage: Welche Methode gewinnt? Env Var oder Datei?

### 3.4 Default Wert (Der "Fallback")
Schaue in die Datei `vars.tf`. Dort steht ein `default` Wert.
Dies wird genutzt, wenn nichts anderes definiert ist.

**Merke die Rangfolge:**
CLI Flag > tfvars Datei > Environment Variable > Default Wert

## Aufgabe 4: Deployment

Entscheide dich für deinen Wunsch-Namen (z.B. "Mein-Erster-Server").

1.  Führe den Plan aus:
    ```bash
    terraform plan -var 'instance_name=Mein-Erster-Server' -out=meinplan
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

---

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

## Aufgabe 7: Code erweitern (Optional / Für Schnelle)

Wir wollen nicht nur die IP-Adresse, sondern auch wissen, in welchem Rechenzentrum (Availability Zone) unser Server steht.

1.  Öffne die Datei `outputs.tf` in VS Code.
2.  Füge folgenden Block hinzu:
    ```hcl
    output "availability_zone" {
      value = aws_instance.example.availability_zone
      description = "Das Rechenzentrum, in dem der Server steht"
    }
    ```
3.  Wende die Änderung an:
    ```bash
    terraform apply
    ```
    (Bestätige mit `yes`).
4.  **Ergebnis:** Du siehst am Ende nun zwei Outputs (IP und Zone).

## Aufgabe 8: Denkanstösse (Pipeline & CI/CD)

Stell dir vor, du führst das nicht auf deinem Laptop aus, sondern automatisch in einer Pipeline (GitLab CI / GitHub Actions). Diskutiere folgende Fragen:

1.  **Das Gedächtnis-Problem:** Wenn der Pipeline-Container nach dem Job gelöscht wird, wo bleibt dann deine `terraform.tfstate` Datei? (Stichwort: Remote Backend / S3).
2.  **Die Sicherheit:** Wie kommen deine AWS Keys in die Pipeline, ohne dass sie im Code stehen? (Stichwort: Secrets / Environment Variables).
3.  **Die Gefahr:** Was passiert, wenn zwei Kollegen gleichzeitig einen Commit pushen und zwei Pipelines gleichzeitig `terraform apply` ausführen? (Stichwort: State Locking).

## Aufgabe 9: Aufräumen

Damit keine Kosten entstehen, löschen wir alles wieder.

```bash
terraform destroy
```
Bestätige mit `yes`. 

**Fertig!** Du hast erfolgreich Infrastructure as Code betrieben.
