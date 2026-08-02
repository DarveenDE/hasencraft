# Lokalen Client testen

Der Entwicklerclient testet den aktuellen Arbeitsstand auf deinem Rechner,
auch mit noch nicht committeten Änderungen. Er erstellt keinen Release und
startet keinen Server.

## Starten

Im Wurzelverzeichnis des Repositories ausführen:

```powershell
.\scripts\start-client-dev.ps1 -Profile cozy
```

Das Skript aktualisiert und prüft zuerst den packwiz-Index, baut anschließend
`dist/Hasencraft-dev-cozy.zip` und startet einen lokalen packwiz-Server. Das
Terminal muss geöffnet bleiben, solange die Dev-Instanz in Prism startet.
`packwiz refresh` kann dabei `index.toml` und den Index-Hash in `pack.toml`
ändern; diese Quelländerungen sind nach Pack-Anpassungen erwartbar und gehören
vor einem Commit zur Prüfung dazu.

Ist `packwiz` noch nicht installiert, einmalig dieselbe Version wie in der CI
installieren und den Go-Bin-Ordner in die aktuelle PowerShell-Sitzung aufnehmen:

```powershell
go install github.com/packwiz/packwiz@dfd8b68a4796
$env:Path = "$env:USERPROFILE\go\bin;$env:Path"
```

Beim ersten Mal in Prism **Instanz hinzufügen** → **Importieren** wählen und
die erzeugte ZIP importieren. Sie heißt anschließend beispielsweise
`Hasencraft Cozy Dev`. Die Dev-Instanz getrennt von Stable und Beta behalten.

`cozy` ist der schnelle Standard. Für Shader-, Sichtweiten- und Leistungstests
gibt es `-Profile fluffy`; auf schwächeren Rechnern steht `-Profile eco` zur
Verfügung. Ein abweichender lokaler Port ist ebenfalls möglich:

```powershell
.\scripts\start-client-dev.ps1 -Profile fluffy -Port 18080
```

## Während der Entwicklung

Solange das Skript läuft, genügt nach Änderungen am Pack ein Neustart der
bereits importierten Dev-Instanz. `packwiz serve` aktualisiert den Index bei
jeder Abfrage und die Instanz synchronisiert den lokalen Arbeitsstand vor dem
Minecraft-Start. Das gilt auch für uncommittete Änderungen.

Das Skript bei einem neuen Terminal erneut ausführen. Auch nach Änderungen an
Launcher-Templates oder dem Dev-Profil die ZIP neu erzeugen und die Instanz in
Prism erneut importieren.

## Prüfen

Warte mindestens bis zum Titelbildschirm und erstelle anschließend eine neue
Singleplayer-Welt. Nach Änderungen an Mods, Registries oder Datapacks immer
eine frische Testwelt verwenden; bestehende Welten sind kein Wegwerf-Teststand.

Die importierte Instanz verwendet `127.0.0.1` und funktioniert ausschließlich
auf deinem Rechner. Den laufenden packwiz-Testserver nach dem Test mit
`Strg+C` beenden und den Port nicht in der Firewall freigeben. Der Ablauf
ersetzt weder den veröffentlichten Beta-/Stable-Feed noch einen Server- oder
Mehrspieler-Test. Die erzeugten Verzeichnisse `build/` und `dist/` bleiben
lokal und werden nicht committed.
