# Community-Operationen

Vor jeder Aenderung der Welt einen vollstaendigen, pruefbaren Backup-Snapshot
anlegen. Neue Betriebsverfahren werden zuerst auf Beta/Staging erprobt und erst
nach erfolgreicher Pruefung auf Stable uebernommen.

## Entscheidung gegen Weltgrenze und Vorabgenerierung (Issue #6)

Alpha 5 setzt bewusst keine kuenstliche Worldborder und fuehrt kein flaechiges
Chunky-Pregen aus. Der Vanilla-Grenzwert bleibt unveraendert. Das erhaelt neue
Weltgeneration fuer spaetere Modupdates, vermeidet grosse Mengen unbesuchter
Alt-Chunks und schuetzt die 120-GB-SSD vor einem schwer kalkulierbaren modded
Pregen. Nether, Ende und Moddimensionen werden ebenfalls nur bei Bedarf erzeugt.

Die verbleibenden Generierungs-Lagspitzen werden stattdessen begrenzt durch:

- `view-distance=5` und `simulation-distance=5`, damit der gesamte sichtbare
  Bereich tickt und Felder am Rand der Sichtweite weiterwachsen;
- ServerCore, Noisium, Structure Layout Optimizer und FastSuite;
- Distant Horizons im Modus `PRE_EXISTING_ONLY`, ohne Client-
  Generierungsanforderungen und mit einem Worker bei 25 Prozent Laufzeit;
- regelmaessige Spark-/TPS- und SSD-Beobachtung waehrend neuer Erkundung.

Eine Grenze wird erst neu bewertet, wenn wiederholte Profile langsame Ticks
durch Weltgenerierung belegen oder der freie SSD-Platz unter die betriebliche
Reserve faellt. Dann wird zuerst auf Beta ein vollstaendiger Snapshot erstellt,
ein begrenzter Durchmesser beschlossen und jede Dimension separat getestet.
Eine spaetere Erweiterung erfolgt nur nach erneutem Snapshot, Kapazitaetscheck
und schrittweise in dokumentierten Ringen. Chunky bleibt bis zu diesem Beschluss
aus dem Pack und vom Stable-Server entfernt.

## BlueMap und Create BlueMap (Issue #7)

BlueMap 5.7 und das Create-Add-on sind serverseitig gepinnt. Die
Laufzeitkonfiguration und Renderdaten bleiben serverlokal; die Betriebsdetails
stehen in `docs/BLUEMAP.md`.

Die umgesetzte Datenschutz-/Lastpolitik ist:

- `render-thread-count = 1` und `min-inhabited-time = 1`: nur besuchte Chunks
  werden verarbeitet, damit der Initialrender nicht ungeplant die gesamte Welt
  erfasst.
- Live-Spielerpositionen und Skin-Downloads sind deaktiviert; Waystones bleiben
  als Marker aktiv, Sharestones und unentdeckte Waystones nicht.
- Overworld, Nether, Ende, Aether, Twilight Forest und Bumblezone sind als
  Karten freigegeben. AE2 Spatial Storage bleibt aus dem Webroot und wird nicht
  veröffentlicht.
- BlueMap bindet auf dem Spielserver nur an eine Tailscale-Adresse. Der
  öffentliche Zugang läuft ausschließlich über den vorhandenen HTTPS-Reverse-
  Proxy; Port 8100 wird nicht am Internet-Interface freigegeben.

Für neue Installationen bleibt `config/bluemap/webserver.conf` bewusst auf
Loopback. Auf einem Host mit öffentlichem Reverse Proxy wird die konkrete
Tailscale-Adresse über `BLUEMAP_BIND_IP` in der serverlokalen
` hasencraft.env` gesetzt; der Deploy-Befehl wendet sie nach einem Pack-Update
erneut an. So gelangen private Hostadressen nicht in Release-Dateien.

Vor einer weiteren Dimension oder einer höheren Renderlast:

1. Ein vollständiges Backup bei gestopptem Dienst erstellen.
2. Die Dimension in `config/bluemap/maps/` freigeben und zunächst nur besuchte
   Chunks rendern.
3. BlueMap-Status/Tasks, Spark/TPS, Speicher und SSD beobachten.
4. Mit mindestens zwei gleichzeitig verbundenen Clients einen neuen,
   besuchten Bereich erkunden und danach erst den Freigabestand erweitern.

Die öffentliche Route ist hostseitig und absichtlich nicht Teil des Pack-Repos:
HTTPS, Zertifikat per ACME, HTTP-Weiterleitung und ein Tailscale-Upstream auf
den BlueMap-Webserver. Die aktuelle Laufzeitpolicy steht in `docs/BLUEMAP.md`.

## Discord Integration (Issue #8)

Discord Integration `4.0.1` ist als serverseitige, gepinnte Mod im Pack
enthalten. Sie bleibt ohne serverlokale Einrichtung inaktiv. Die Konfiguration
liegt ausschließlich unter
`world/serverconfig/discordintegration-server.toml`; sie wird von Git, Packwiz
und den Server-Backups ausgeschlossen. Der systemd-Dienst verweigert den Start,
wenn DI aktiv ist und der letzte Deploy nicht aus `beta` stammt.

### Vorläufige Funktionsentscheidung

- **Status-/Join-/Leave-Meldungen:** im Staging-Managementkanal aktivieren.
- **Chat-Brücke:** ausschließlich in einem eigenen Staging-Testkanal prüfen;
  eine produktive Aktivierung folgt erst nach Datenschutz- und Moderationsfreigabe.
- **Whitelist-Verknüpfung:** für die erste produktive Alpha gegen eine
  Aktivierung entschieden. Sie bleibt im Staging optional testbar, aber
  `whitelist.enabled` bleibt zunächst `false`; die bestehende Minecraft-
  Whitelist bleibt serverseitig führend.
- **Moderationsbefehle:** keine Remote-Ausführung aus Discord. Kick, Ban,
  Whitelist, Teleport und Spectate bleiben bei LuckPerms und den In-Game-
  Rollen; Discord-Rollen verleihen niemals OP-Rechte.

Vor jedem Stable-Deploy muss `bot.active = false` gesetzt sein. Der
Start-Guard erzwingt diese Trennung und lässt eine aktive Discord-Instanz nur
auf einem zuletzt als `beta` deployten Server zu.

### Staging einrichten

1. Eine getrennte Discord-Anwendung samt Bot nur für Beta/Staging anlegen. Im
   Developer Portal mindestens Message Content Intent und Server Members Intent
   aktivieren; die benötigten Kanal-/Nachrichtenrechte auf die Testkanäle
   beschränken.
2. Den Bot nur in eine Test-Guild einladen. Bot-Token, Guild-ID, Kanal-ID und
   Rollen-ID ausschließlich im Passwortmanager beziehungsweise direkt auf der
   Staging-VM verwahren.
3. Beta deployen und den Server einmal mit DI deaktiviert starten, damit die
   Mod ihre Konfiguration erzeugt:

   ```bash
   sudo systemctl stop hasencraft
   sudo -u hasencraft /usr/local/libexec/hasencraft-deploy beta
   sudo systemctl start hasencraft
   sudo systemctl stop hasencraft
   sudoedit /srv/hasencraft/server/world/serverconfig/discordintegration-server.toml
   sudo chown hasencraft:hasencraft /srv/hasencraft/server/world/serverconfig/discordintegration-server.toml
   sudo chmod 0640 /srv/hasencraft/server/world/serverconfig/discordintegration-server.toml
   ```

   Als sichere Ausgangsbasis dient
   `server/discordintegration-staging.example.toml`. Die Platzhalter müssen vor
   dem Start ersetzt werden; die Datei selbst wird nicht in den Packstand
   übernommen.
4. Im erzeugten TOML mindestens diese Bereiche setzen:

   ```toml
   [bot]
   active = true
   bot_token = "TOKEN_NUR_LOKAL_EINTRAGEN"
   guild_id = 0 # echte Test-Guild-ID einsetzen

   [chat]
   enabled = true
   channel_id = 0 # eigener Staging-Testkanal
   max_char_count = 300
   transmit_bot_messages = false

   [management]
   enabled = true
   channel_id = 0 # privater Moderations-/Betriebskanal
   role_id = 0 # eigene Test-Moderationsrolle

   [whitelist]
   enabled = false
   ```

   Die IDs sind Discord-Schneeflocken und werden als Zahlen eingetragen. Keine
   ID oder kein Token in Git, Release-Snapshots, Screenshots, Chat oder ein
   Backup kopieren.
