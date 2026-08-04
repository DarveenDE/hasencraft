# BlueMap

Stand: 2. August 2026. Bezug: [GitHub Issue #7](https://github.com/DarveenDE/hasencraft/issues/7).

## Aktueller Stand

Die oeffentliche Bereitstellung ist auf der vorgesehenen Serverarchitektur
aktiv und wurde direkt geprueft:

- sechs Karten sind freigegeben: Overworld, Nether, Ende, Aether, Twilight
  Forest und Bumblezone;
- AE2 Spatial Storage ist weder in der aktiven Map-Konfiguration noch im
  Webroot veroeffentlicht;
- die BlueMap-Oberflaeche wird ueber einen HTTPS-Reverse-Proxy ausgeliefert;
- der BlueMap-Port ist nicht am oeffentlichen Netzwerkinterface geoeffnet;
- Live-Spielerpositionen und Skin-Downloads sind deaktiviert;
- der direkte Spieler-Payload ist leer, wenn keine Spielenden sichtbar sein
  sollen;
- die Overworld erzeugt bereits Tile-Daten. Die uebrigen Karten werden wegen
  `min-inhabited-time: 1` erst befuellt, sobald dort besuchte Chunks vorhanden
  sind.

## Architektur

BlueMap und Create BlueMap sind als serverseitige, gepinnte Pack-Dateien
enthalten. Der Minecraft-Server hostet BlueMap nur auf einer privaten
Tailscale-Adresse. Der oeffentliche Proxy sitzt auf dem vorgeschalteten Host
und leitet nur HTTPS auf diesen privaten Upstream weiter. Die konkrete Domain,
Tailscale-Adresse und Proxy-Datei bleiben serverlokal und gehoeren nicht in
das Pack-Repository.

Die versionierte Datei `config/bluemap/webserver.conf` bindet standardmaessig
an Loopback. Auf einem Server mit vorgeschaltetem Proxy wird in der
serverlokalen `hasencraft.env` ein `BLUEMAP_BIND_IP` gesetzt. Der Deploy-Befehl
setzt damit nach einem Pack-Update die konkrete private Bind-Adresse erneut,
ohne eine private IP in einen Release-Snapshot zu schreiben.

Der Proxy benoetigt:

1. eine HTTP-Route mit permanenter Weiterleitung auf HTTPS;
2. eine HTTPS-Route mit ACME/Let's Encrypt;
3. einen HTTP-Upstream auf der Tailscale-Adresse des Spielservers;
4. keinen oeffentlichen Listener auf BlueMaps Port 8100.

## Laufzeitpolicy

Die serverlokalen BlueMap-Dateien werden nicht versioniert, weil sie
Renderzustand, Weltbezug und umgebungsabhaengige Bind-Adressen enthalten. Die
aktuell eingesetzte Policy lautet:

| Bereich | Wert | Zweck |
| --- | --- | --- |
| `core.conf` | `accept-download: true` | einmalige Zustimmung zum Download der Mojang-Ressourcen |
| `core.conf` | `render-thread-count: 1` | CPU-Limit fuer den Renderer |
| `plugin.conf` | `live-player-markers: false` | keine Spielerpositionen im oeffentlichen Web |
| `plugin.conf` | `hide-different-world: true` | zusaetzlicher Schutz bei einer spaeteren Marker-Aktivierung |
| `plugin.conf` | `skin-download: false` | keine Skin-Abfragen fuer oeffentliche Marker |
| `plugin.conf` | `player-render-limit: 2` | Rendering pausiert ab zwei Spielenden |
| Map-Dateien | `min-inhabited-time: 1` | nur besuchte Chunks werden gerendert |
| Waystones | `includeSharestones = false` | private Sharestones nicht als Marker veroeffentlichen |
| Maps | AE2 Spatial Storage deaktiviert | private/interne Dimension nicht anzeigen |

## Betrieb

Vor jeder Aenderung an Maps oder Rendergrenzen:

~~~text
systemctl stop hasencraft
sudo -u hasencraft /usr/local/libexec/hasencraft-backup
systemctl start hasencraft
~~~

Die BlueMap-Ressourcenfreigabe wird nur bewusst auf dem Server gesetzt. Danach
werden Status und Aufgaben ueber die BlueMap-Befehle kontrolliert:

~~~text
/bluemap
/bluemap tasks
/bluemap maps
/bluemap update [map-id]
/bluemap force-update [map-id]
~~~

`force-update` nur nach einer bewusst entschiedenen Konfigurationsaenderung
verwenden. Fuer die normale Pflege soll
BlueMaps automatische Aenderungserkennung arbeiten.

Weiterfuehrend:

- [BlueMap Commands and Permissions](https://bluemap.bluecolored.de/wiki/getting-started/Commands.html)
- [BlueMap Configuration](https://bluemap.bluecolored.de/wiki/getting-started/Configuration.html)
- [BlueMap Reverse Proxy](https://bluemap.bluecolored.de/wiki/webserver/ReverseProxy.html)
