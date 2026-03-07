# Installations-Guide für den Workshop

Jeder Teilnehmer **muss** folgende Tools vor Beginn installiert haben.

## 0. Paketmanager installieren (Nur Windows)

Falls du Windows nutzt und noch kein **Chocolatey** hast, installiere es zuerst.
Öffne **PowerShell als Administrator** und führe folgenden Befehl aus:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Starten danach die PowerShell neu!

## 1. Terraform installieren

### Windows
Am einfachsten über Chocolatey oder Winget:
```powershell
choco install terraform
# ODER
winget install HashiCorp.Terraform
```
Alternativ: [Download Binary](https://developer.hashicorp.com/terraform/downloads) -> Entpacken -> In `PATH` Umgebungsvariable hinzufügen.

### MacOS
Mit Homebrew:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Linux (Ubuntu/Debian)
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

## 2. AWS CLI installieren

### Windows
*   Lade den MSI Installer herunter und führe ihn aus: https://awscli.amazonaws.com/AWSCLIV2.msi

### MacOS
```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

### Linux
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

## 3. VS Code & Extensions (Empfohlen)

1.  VS Code installieren: https://code.visualstudio.com/
2.  **Terraform Extension** installieren (von HashiCorp).
    *   Öffne VS Code -> Extensions (Strg+Shift+X) -> Suche "Terraform" -> Installieren.

## 4. Testen ob alles klappt

Öffne ein **neues** Terminal und prüfe:

```bash
terraform --version
aws --version
git --version
```
Wenn überall eine Version ausgegeben wird, bist du bereit!
