# Community-Operationen

Diese Schritte gehoeren ausschliesslich in den Beta-/Staging-Kanal. Vor jeder
Aenderung der Welt einen vollstaendigen, pruefbaren Backup-Snapshot anlegen.
Stable wird erst nach einem erfolgreichen Staging-Test aktualisiert.

## Weltgrenze und einmalige Vorabgenerierung (Issue #6)

Chunky bleibt absichtlich ausserhalb des Modpacks: Distant Horizons dokumentiert
bei paralleler Nutzung LoD-Luecken. Fuer eine einmalige Vorabgenerierung darf
ein zur Serverversion passender Chunky-Build deshalb nur voruebergehend auf
dem Staging-Server liegen. Waerendessen verbindet sich niemand mit Distant
Horizons.

Die Community legt vor dem Lauf einen Durchmesser `D` in Bloecken fest. Der
folgende Ablauf verwendet eine quadratische Weltgrenze um `0 0`; der Chunky-
Radius ist `D / 2`, damit auch die Ecken innerhalb der Grenze erzeugt werden.

1. Staging stoppen und den Backup-Snapshot pruefen. Den temporaeren Chunky-JAR
   nur in das *Server*-`mods`-Verzeichnis von Staging legen.
2. Server starten und in der Konsole ausfuehren:

   ```text
   /worldborder center 0 0
   /worldborder set <D>
   /chunky world minecraft:overworld
   /chunky center 0 0
   /chunky shape square
   /chunky radius <D/2>
   /chunky start
   ```

3. Zu Beginn und danach mindestens alle 30 Minuten in der Serverkonsole
   `/chunky progress` ausfuehren. Die Konsolen- beziehungsweise Journal-Ausgabe
   als Fortschrittsnachweis behalten. Gleichzeitig auf dem Host `free -h`
   (RAM und Swap) sowie `df -h <Serverdatentraeger>` (freier SSD-Platz)
   protokollieren. Bei Bedarf mit `/chunky pause` anhalten und mit
   `/chunky continue` fortsetzen.
4. Den Lauf erst als abgeschlossen markieren, wenn `/chunky progress` keine
   ausstehende Arbeit mehr meldet. Zeitstempel, finalen Fortschrittswert,
   Speicherwerte und die Kennung des vorherigen Backups gemeinsam im
   Staging-Betriebsprotokoll ablegen. Nether und Ende nur nach einem separaten
   Beschluss mit ihren eigenen Grenzen vorbereiten.
5. Nach Abschluss Staging stoppen und den temporaeren Chunky-JAR wieder
   entfernen. Erst dann einen Distant-Horizons-Client verbinden und die
   erzeugte Umgebung auf LoD-Luecken pruefen.

Die Grenze ist im Weltstand gespeichert. Sie gehoert daher in die
Serverdokumentation und in das Backup, nicht in die Client- oder Packdateien.

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
