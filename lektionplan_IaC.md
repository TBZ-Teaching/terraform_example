# Terraform Tutorial: Webspace & Variables (Didaktisches Konzept)

Dieses Konzept basiert auf dem **AVIVA-Modell** und ist optimiert für **technisch versierte Teilnehmer (Informatiker)** in **45 Minuten**.

## Zeitplan (45-Minuten-Sprint)
*Dieser Ablauf setzt voraus, dass Terraform & AWS Access Keys bereits installiert sind!*

| Phase | Zeit | Inhalt | Ziel |
| :--- | :--- | :--- | :--- |
| **1. Ankommen (A)** | 00:00 - 05:00 | Begrüssung, PPTX (Kurzfassung) | Motivation klären ("Warum IaC?") |
| **2. Vorwissen (V)** | 05:00 - 10:00 | Setup-Check (`terraform -v`), `git clone` | Arbeitsfähigkeit herstellen |
| **3. Informieren (I)** | 10:00 - 15:00 | Code-Scan (`main.tf`, `vars.tf`) | Struktur verstehen (Provider vs. Resource) |
| **4. Verarbeiten (V)** | 15:00 - 25:00 | **Aufgabe 1-5**: Deployment mit Variable | Erstes Erfolgs-Erlebnis (Server läuft) |
| **5. Chaos-Test** | 25:00 - 35:00 | **Aufgabe 6**: Manuelles Löschen & Restore | "Self-Healing" erleben (Aha-Moment!) |
| **5. Bonus-Aufgaben** | 35:00 - 42:00 | **Aufgabe 7**: Code erweitern | Vertiefung (Variablen, Templates) |
| **6. Auswerten (A)** | 42:00 - 45:00 | **Aufgabe 8**: Diskussion `tfstate` & CI/CD | Transferleistung (Pipeline-Denken) |
| **7. Cleanup** | 45:00 - 48:00 | **Aufgabe 9**: `terraform destroy` | Sauberes Ende |

## Didaktisches Fundament
Das Tutorial folgt dem Prinzip des **Scaffolding** (Gerüstbau nach Vygotsky): Wir bieten den Teilnehmern zu Beginn ein festes Gerüst (funktionierender Code, klare Installationsanleitung), das wir im Verlauf schrittweise abbauen, um selbstständiges Problemlösen zu ermöglichen.

Durch die Zerlegung des komplexen Themas "Infrastructure as Code" in kleine Einheiten (Installation -> Code lesen -> Variablen nutzen -> Deployment) berücksichtigen wir die **Cognitive Load Theory** (Sweller), indem wir die kognitive Belastung gering halten und "Overwhelm" vermeiden.

## 1. Ankommen (A) & Vorwissen (V)
*Didaktisches Ziel: Affektive Aktivierung (Motivation) & Kognitive Aktivierung (Vorwissen).*

### Einstieg (Ankommen) - 5 Min.
*   **Methode**: **Blitzlicht / Advanced Organizer**.
*   **Material**: `Infrastructure_as_code_intro.pptx`.
*   **Theorie**: Informatiker holen wir am besten über **Problemlösung** ab: "Ihr habt sicher keine Lust, 50 Server zu klicken. Hier ist die Lösung."
*   **Ablauf**:
    *   Begrüssung.
    *   Visualisierung: "Klick-Orgie vs. Code-Zeilen".

### Vorwissen überprüfen (V) - 5 Min.
*   **Methode**: **Technical Check**.
*   **Material**: Terminal.
*   **Ablauf**:
    *   Alle tippen `terraform --version` und `aws --version`.
    *   Repo klonen.
    *   Wer Probleme hat: **Peer-Learning** (Nachbar hilft), sonst verliert der Dozent zu viel Zeit.

## 2. Informieren (I) - 5 Min.
*Didaktisches Ziel: Aufbau von deklarativem Wissen (Verstehen)*

### Code-Walkthrough ("Code-Reading")
*   **Methode**: **Guided Walkthrough**.
*   **Material**: `main.tf`, `vars.tf`.
*   **Ablauf**:
    *   Nicht Zeile für Zeile vorlesen!
    *   Stattdessen: "Findet den Block, der die AWS-Region definiert." -> `provider`.
    *   "Findet den Block, der den Server definiert." -> `resource`.
    *   **Fokus**: Auf `var.server_port` oder `var.instance_name`.

## 3. Verarbeiten (V) - Der PADUA Zyklus - 10 Min.
*Didaktisches Ziel: Transformation von Wissen in Können (Prozedurales Wissen).*

### P - Problematisierung
*   **Szenario**: "Wir brauchen Namen (Tags). Hartkodieren ist verboten."

### A - Aufbau & D - Durcharbeiten (Instruktion)
*   **Ablauf**:
    *   Kurz die Precedence zeigen (CLI > File > Env > Default).

### U - Üben (Elaboration & Transfer)
*   **Aufgaben (aus AUFGABEN.md)**:
    *   Fokus auf **Aufgabe 3 & 4**.
    *   Wir nutzen die **`terraform.tfvars`** Datei als Best Practice.
    *   Teilnehmer passen **Instanz-Namen** und **Port** an (Erfolgskontrolle: Individuelle URL).

### A - Anwenden (Konstruktion)
*   `terraform apply` -> Server läuft.

## 4. Auswerten (A) - 15 Min. (Kernphase für Fortgeschrittene!)
*Didaktisches Ziel: Metakognition, Reflexion und Ergebnissicherung.*

### Self-Healing & Drift (Aufgabe 6)
*   **Theorie**: **Kognitive Dissonanz**.
*   **Ablauf**:
    *   "Löscht die Instanz in der AWS GUI!" (Freude am Zerstören).
    *   `terraform plan` -> Terraform erkennt den Drift.
    *   `terraform apply` -> Magische Heilung.

### Bonus-Aufgabe: Code erweitern (Aufgabe 7)
*   **Theorie**: **Selbstbestimmungstheorie** (Deci & Ryan) - Autonomie durch Erweiterung.
*   **Ablauf**:
    *   Variable `server_text` hinzufügen.
    *   `user_data` anpassen.
    *   `terraform apply` -> Individuelle Webseite.

### Exkurs & Diskussion (Aufgabe 8): Terraform in der Pipeline (CI/CD)
*   **Wichtig**: Dies ist für Informatiker der spannendste Teil.
*   **Aktivität**: Kurzer Blick in `terraform.tfstate` (lokal).
*   **Diskussion**:
    1.  **State-Problem**: "Container weg = State weg?" -> Remote Backend (S3).
    2.  **Concurrency**: "Race Conditions?" -> Locking.

### Clean-Up (Aufgabe 9) - 3 Min.
*   `terraform destroy`.
