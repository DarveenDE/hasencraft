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

- `view-distance=5` und `simulation-distance=2`;
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

BlueMap und sein Create-Add-on sind serverseitig gepinnt. Die vorhandene
Waystones-Konfiguration aktiviert ihre BlueMap-Marker bereits. Die mitgelieferte
`config/bluemap/webserver.conf` bindet den Webserver von Beginn an an
`127.0.0.1`; sie ist die einzige versionierte BlueMap-Datei. Weitere lokale
Konfiguration und Renderdaten bleiben absichtlich ausserhalb von Git.

1. Den ersten Start nur im Staging ausfuehren. In der neu erzeugten `core.conf`
   die vom Projekt geforderte Zustimmung zum Ressourcen-Download pruefen und
   bewusst setzen, dann `/bluemap reload` ausfuehren.
2. Den ersten Render ueber die BlueMap-Befehle (Tab-Completion in der
   Serverkonsole) anstossen und einen Overworld-Ausschnitt kontrollieren.
3. Den Webzugang zunaechst nur lokal, ueber SSH-Tunnel oder innerhalb des
   privaten Tailscale-Netzes pruefen. Keinen offenen Port und keinen
   oeffentlichen Reverse Proxy einrichten.
4. Vor der Veroeffentlichung Kartenbereich, Spielendenamen/Marker, URL und
   Zugriffsregel gemeinsam festlegen. Erst danach kommt ein authentifizierter
   Reverse Proxy in Frage.

## Discord Integration (Issue #8)

Discord Integration ist installiert, bleibt aber ohne serverlokale Einrichtung
inaktiv. Ein Bot-Token gehoert ausschliesslich in
`world/serverconfig/discordintegration-server.toml`; diese Datei ist doppelt
durch die Welt- und die explizite Ignore-Regel geschuetzt.

Fuer Staging:

1. Eine eigene Discord-Anwendung samt Bot anlegen und den Token nur im
   Passwortspeicher verwahren.
2. Token, Guild- und Test-Kanal-ID direkt auf dem Staging-Server eintragen.
   Niemals in Git, Releases, Screenshots oder Chat kopieren.
3. Erst mit einem Testkanal Chat-Bridging und das gewuenschte
   Whitelist-/Rollenverhalten pruefen. Discord-Rollen verleihen dabei keine
   Minecraft-OP-Rechte.
4. Nach einem erfolgreichen Test die Community festlegen lassen, ob Chat-
   Bridge, Whitelist-Verknuepfung, beide oder keine der Funktionen produktiv
   gewuenscht sind.

Damit ist die technische Option vorbereitet, ohne eine externe Community-
Plattform voreilig zu verbinden oder Geheimnisse auszuliefern.
