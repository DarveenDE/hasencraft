# Lokalen Client testen

Der Entwicklerclient testet den aktuellen Arbeitsstand auf deinem Rechner –
auch mit noch nicht committeten Änderungen. Er erstellt keinen Release und
startet keinen Server.

## Einmal einrichten

Im Wurzelverzeichnis des Repositories ausführen:

```powershell
.\scripts\start-client-dev.ps1 -Import
```

Das Skript aktualisiert und prüft den packwiz-Index, erzeugt eine lokale
Dev-Instanz und öffnet Prism für den Import. Die Transport-ZIP liegt nur lokal
unter `build/dev-client/`; sie ist kein Release-Artefakt.

Nach dem Import heißt die Instanz beispielsweise `Hasencraft Cozy Dev`. Sie
getrennt von Stable und Beta behalten.

Ist `packwiz` noch nicht installiert, einmalig dieselbe Version wie in der CI
installieren:

```powershell
go install github.com/packwiz/packwiz@dfd8b68a4796
```

Das Skript findet anschließend `%USERPROFILE%\go\bin\packwiz.exe`
automatisch.

`cozy` ist der schnelle Standard. Für Shader-, Sichtweiten- und Leistungstests
gibt es `-Profile fluffy`; auf schwächeren Rechnern steht `-Profile eco` zur
Verfügung.

## Danach: nur noch Prism starten

Für normale Pack-, KubeJS-, Config- oder Ressourcenänderungen einfach in Prism
auf **Hasencraft … Dev** → **Spielen** klicken. Kein Terminal und kein lokaler
Webserver sind nötig: Der Dev-Pre-Launch-Hook aktualisiert den Index im
Arbeitsordner und lädt ihn direkt über eine lokale `file:`-Adresse.

Warte mindestens bis zum Titelbildschirm und erstelle anschließend eine neue
Singleplayer-Welt. Nach Änderungen an Mods, Registries oder Datapacks immer
eine frische Testwelt verwenden; bestehende Welten sind kein Wegwerf-Teststand.

## Wann erneut einrichten?

Den Einrichtungsbefehl mit `-Import` erneut ausführen, wenn der Checkout oder
die `packwiz.exe` verschoben wurde oder wenn Launcher-Templates bzw. das
gewählte Profil geändert wurden. Prism-Instanzen und ihre Welten werden dabei
nie automatisch gelöscht; eine alte Dev-Instanz nur bewusst manuell entfernen.

`packwiz refresh` kann `index.toml` und den Index-Hash in `pack.toml` ändern.
Das ist nach Pack-Anpassungen erwartbar und gehört vor einem Commit zur Prüfung
dazu. Die Dev-ZIP enthält lokale Pfade und ist nur für diesen Windows-Rechner
bestimmt – nicht weitergeben.
