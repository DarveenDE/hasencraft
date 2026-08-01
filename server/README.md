# Ubuntu-Server

Zielplattform: Ubuntu Server 24.04 LTS, Java 21, 6 vCPU, 16 GiB VM-RAM und 120 GiB SSD. Das mitgelieferte Java-Profil verwendet `-Xms8G -Xmx12G`; damit bleiben ungefähr 4 GiB für Betriebssystem, Dateicache, Zabbix und weitere Dienste frei.

## Installation

Repository auf die VM kopieren und aus dessen Wurzel ausführen:

```bash
sudo ./server/install-server.sh
```

Das Skript installiert Java 21 und zstd, legt den nicht-interaktiven Benutzer `hasencraft` an, installiert NeoForge `21.1.247`, kopiert den packwiz-Bootstrap und richtet den systemd-Dienst ein. Es startet den Server nicht und akzeptiert die Minecraft-EULA nicht stellvertretend.

Danach:

```bash
sudoedit /etc/hasencraft/hasencraft.env
sudo -u hasencraft cp /srv/hasencraft/server/server.properties.example \
  /srv/hasencraft/server/server.properties
sudoedit /srv/hasencraft/server/server.properties
sudoedit /srv/hasencraft/server/eula.txt

sudo systemctl stop hasencraft
sudo -u hasencraft /usr/local/libexec/hasencraft-deploy stable
sudo systemctl start hasencraft
```

## Updates

```bash
sudo systemctl stop hasencraft
sudo -u hasencraft /usr/local/libexec/hasencraft-deploy stable
sudo systemctl start hasencraft
```

Der Deploy-Befehl prüft die SHA-256-Summe des Updatewerkzeugs und lehnt Packs mit einer anderen NeoForge-Version ab. Vor jeder Änderung erstellt er ein vollständiges `.tar.zst` unter `/srv/hasencraft/backups/`. Vorher prüft er, ob mindestens die unkomprimierte Größe des Servers plus 2 GiB Reserve frei sind. Alte Backups werden absichtlich nicht automatisch gelöscht; bei der 120-GiB-SSD sollte ihre Belegung regelmäßig geprüft werden.

Serverlauf, Deployment, manuelle Backups und Rollback teilen sich denselben exklusiven Lifecycle-Lock. Ein konsistentes manuelles Backup wird deshalb nur bei gestopptem Dienst erstellt:

```bash
sudo systemctl stop hasencraft
sudo -u hasencraft /usr/local/libexec/hasencraft-backup
sudo systemctl start hasencraft
```

## Rollback

Zuerst den gehosteten Stable-Kanal auf das alte Release zurückstellen. Dann:

```bash
sudo systemctl stop hasencraft
sudo /usr/local/libexec/hasencraft-rollback \
  /srv/hasencraft/backups/pre-update-YYYYMMDDTHHMMSSZ.tar.zst
sudo systemctl start hasencraft
```

## Netzwerk

- Minecraft TCP `25565`
- Simple Voice Chat UDP `24454`

RCON bleibt deaktiviert. Die Ports sollten erst nach dem erfolgreichen Staging-Test und nur für die tatsächlich benötigten Netze geöffnet werden. Für einen privaten Betrieb sind LAN und Tailscale sinnvoller als eine pauschale öffentliche Freigabe, zum Beispiel:

```bash
sudo ufw allow from <LAN-CIDR> to any port 25565 proto tcp comment 'Hasencraft LAN'
sudo ufw allow in on tailscale0 to any port 25565 proto tcp comment 'Hasencraft Tailscale'
sudo ufw allow from <LAN-CIDR> to any port 24454 proto udp comment 'Hasencraft Voice LAN'
sudo ufw allow in on tailscale0 to any port 24454 proto udp comment 'Hasencraft Voice Tailscale'
```

Die Platzhalter sind vor der Ausführung bewusst durch die gewünschte lokale Netzfreigabe zu ersetzen. IP-Adressen, Hostnamen und SSH-Ziele gehören nicht in das veröffentlichte Modpack-Repository.
