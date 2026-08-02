# Client installieren

## Voraussetzungen

1. Aktuellen Prism Launcher installieren.
2. Microsoft-Konto in Prism anmelden.
3. Prism die passende Java-21-Laufzeit automatisch verwalten lassen.

## Profil wählen

- `fluffy`: RX 7900 XT, 10 GiB Heap, 14 Chunks Vanilla-Sichtweite, DH-Ziel 256 Chunks.
- `cozy`: GTX 1080, 8 GiB Heap, 10 Chunks Vanilla-Sichtweite, DH-Ziel 96–128 Chunks.
- `eco`: schwächere Rechner, 6 GiB Heap, 8 Chunks Vanilla-Sichtweite, DH-Ziel 64 Chunks; startet ohne Shader und Fresh Animations.

Alle drei Profile verwenden exakt dieselben Spielinhalte. Nur lokale Grafik-, Ressourcenpack- und Speicherwerte unterscheiden sich.

## Import

1. In Prism `Instanz hinzufügen` → `Importieren` wählen.
2. Die passende `Hasencraft-*.zip` auswählen.
3. Instanz einmal starten. Der Pre-Launch-Updater lädt den freigegebenen Packstand.
4. Bei `fluffy` und `cozy` im Hauptmenü kontrollieren, dass Complementary Reimagined aktiv ist. `eco` startet absichtlich ohne Shader.
5. Unter Distant Horizons den Renderer auf `Auto` lassen.

## Empfohlene Distant-Horizons-Werte

### Fluffy / RX 7900 XT

- LoD-Distanz: 256; 384 nur für Screenshots oder ruhiges Erkunden
- CPU-Auslastung: `Balanced`
- Vanilla-Sichtweite: 12–16
- Complementary: High

### Cozy / GTX 1080

- LoD-Distanz: 96–128
- CPU-Auslastung: `Low Impact` oder `Balanced`
- Vanilla-Sichtweite: 8–10
- Complementary: Medium oder Potato
- volumetrische Wolken und teure Reflexionen deaktivieren

### Eco / schwächere Rechner

- LoD-Distanz: 64; höchstens 96 erst nach einem ruckelfreien Test
- CPU-Auslastung: `Low Impact`
- Vanilla-Sichtweite: 6–8
- Shader aus lassen; Fresh Animations bei Bedarf später bewusst aktivieren

## Wichtige Regel

Die Instanz nie durch „alle Mods auf neueste Version“ verändern. Iris `1.8.14-beta.1` benötigt hier absichtlich Sodium `0.8.12`; ein unabhängiges Sodium-Update bricht den getesteten Shaderstack.
