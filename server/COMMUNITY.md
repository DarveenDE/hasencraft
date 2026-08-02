# Community-Betrieb

Diese Anleitung gilt fuer `0.1.0-alpha.5` und den Beta-/Staging-Kanal. Sie
beruehrt niemals den Stable-Server ohne vorherigen, erfolgreichen Test.

## Was Alpha 5 bereitstellt

- **FTB Chunks** nutzt die bereits vorhandenen FTB Teams fuer Claims und
  Schutz. Neue Teams erhalten 64 Claims, hoechstens 128 pro Team und acht
  force-geladene Chunks. Claims laufen nicht automatisch ab; nach 30 Tagen
  ohne Login werden nur die Offline-Lasten freigegeben.
- **LuckPerms** verwaltet die Rollen. Die Claim-Limits sind absichtlich als
  globale, nachvollziehbare Serverwerte konfiguriert; nur Offline-Chunkloading
  wird gezielt an die Rolle `builder` vergeben.

FTB Chunks liest die Pack-Vorlage unter `config/ftbchunks-world.snbt` als
Modpack-Standard und darf sie bei der ersten Benutzung mit kommentierten
Default-Werten ergänzen. Soll eine Anpassung einen Pack-Update ueberdauern,
kopiert der Server-Admin die geprüfte Datei bewusst nach
`world/serverconfig/ftbchunks-world.snbt`. Diese Welt-Override-Datei wird weder
von Git noch vom Pack-Update verwaltet:

```bash
sudo systemctl stop hasencraft
sudo -u hasencraft install -D -m 0640 \
  /srv/hasencraft/server/config/ftbchunks-world.snbt \
  /srv/hasencraft/server/world/serverconfig/ftbchunks-world.snbt
sudo systemctl start hasencraft
```

## Erster Staging-Start

1. Den Dienst stoppen und das vorhandene Backup-Verfahren ausfuehren.
2. Den Beta-Kanal mit `hasencraft-deploy beta` ausrollen und den Dienst starten.
3. Im Log pruefen, dass `FTB Chunks` und `LuckPerms` geladen
   wurden. Danach die geprüfte Pack-Vorlage nur dann als
   `world/serverconfig/ftbchunks-world.snbt` festschreiben, wenn die Werte den
   künftigen, serverlokalen Standard bilden sollen.
4. Zwei Testspielende in getrennten FTB Teams verbinden: einen Chunk claimen,
   in der anderen Claim-Abgrenzung abbauen/Container oeffnen testen sowie
   Piston und Explosion pruefen. Beide Clients muessen die FTB-Karte mit `U`
   und Xaero's Weltkarte mit `M` konfliktfrei oeffnen koennen.
5. Nach einem Reconnect erneut testen, dass der Claim, die Team-Zugehoerigkeit
   und die gewuenschten Containerrechte unveraendert gelten.

Ein Pack-Update darf nicht auf Stable promoted werden, solange einer dieser
Punkte fehlschlaegt.

## Rollen mit LuckPerms

Die folgenden Befehle werden als bestehender Server-Operator einmalig in der
Serverkonsole oder im Spiel ausgefuehrt. `default` bleibt die normale
Spielerrolle.

```text
lp creategroup member
lp creategroup builder
lp creategroup moderator
lp creategroup admin
lp group member parent add default
lp group builder parent add member
lp group moderator parent add member
lp group admin parent add moderator
lp group builder permission set ftbchunks.chunk_load_offline true
lp group admin permission set luckperms.* true
lp user <Minecraft-Name> parent add <member|builder|moderator|admin>
```

`builder` darf seine maximal acht force-geladenen Chunks auch ohne eingeloggtes
Teammitglied aktiv halten. Das ist eine begrenzte, messbare Ausnahme; die
globalen Limits werden nicht durch ungetestete numerische Permission-Knoten
ueberschrieben. Nach dem Einrichten mit einem Nicht-OP-Testkonto pruefen:

```text
lp user <Minecraft-Name> permission check ftbchunks.chunk_load_offline
```

## Betriebshinweise

- Wiederherstellungen erfolgen ausschliesslich ueber einen pruefbaren
  Server-Backup-Snapshot. Vor jeder Wiederherstellung zuerst die Ursache im
  Staging nachvollziehen und den betroffenen Weltstand sichern.
- Offline-Chunkloading verursacht echte Serverlast. Aenderungen an den
  Limits erst nach einem Spark-/TPS-Test im Staging vornehmen.
