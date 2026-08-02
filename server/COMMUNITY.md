# Community-Betrieb

Diese Anleitung gilt fuer `0.1.0-alpha.4` und den Beta-/Staging-Kanal. Sie
beruehrt niemals den Stable-Server ohne vorherigen, erfolgreichen Test.

## Was Alpha 3 bereitstellt

- **FTB Chunks** nutzt die bereits vorhandenen FTB Teams fuer Claims und
  Schutz. Neue Teams erhalten 64 Claims, hoechstens 128 pro Team und acht
  force-geladene Chunks. Claims laufen nicht automatisch ab; nach 30 Tagen
  ohne Login werden nur die Offline-Lasten freigegeben.
- **LuckPerms** verwaltet die Rollen. Die Claim-Limits sind absichtlich als
  globale, nachvollziehbare Serverwerte konfiguriert; nur Offline-Chunkloading
  wird gezielt an die Rolle `builder` vergeben.
- **CoreProtectNeo** protokolliert Block-, Interaktions- und Inventarvorgaenge
  lokal in SQLite. Die Clients benoetigen diesen Mod nicht.

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
3. Im Log pruefen, dass `FTB Chunks`, `LuckPerms` und `CoreProtectNeo` geladen
   wurden. Danach die geprüfte Pack-Vorlage nur dann als
   `world/serverconfig/ftbchunks-world.snbt` festschreiben, wenn die Werte den
   künftigen, serverlokalen Standard bilden sollen.
4. Zwei Testspielende in getrennten FTB Teams verbinden: einen Chunk claimen,
   in der anderen Claim-Abgrenzung abbauen/Container oeffnen testen sowie
   Piston und Explosion pruefen. Beide Clients muessen die FTB-Karte mit `U`
   und Xaero's Weltkarte mit `M` konfliktfrei oeffnen koennen.
5. Einen Testblock setzen, mit `/co i` nachsehen und ausschliesslich im
   Testgebiet mit `/co rollback area 3 5m` rueckgaengig machen. Vor jedem
   produktiven Rollback zuerst ein vollstaendiges Server-Backup anlegen.

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

CoreProtectNeo laesst `/co i` fuer alle Spielenden zu. Seine `near`- und
Rollback-Befehle verlangen derzeit Minecraft-Adminrechte (OP-Stufe 2). Der
Rang `moderator` erhaelt diese Befehle in Alpha 3 bewusst nicht automatisch:
CoreProtectNeo dokumentiert keine passenden LuckPerms-Permission-Nodes. Nur
wenige, namentlich bekannte Personen kommen in `ops.json`. Eine getestete,
feingranulare Rechte-Bridge ist Voraussetzung, bevor der Moderator-Rang
Rollbacks ohne OP ausfuehren darf.

## Betriebshinweise

- CoreProtectNeo speichert seine SQLite-Daten in
  `config/coreprotectneo/database.db`. Diese Datenbank gehoert in die regulären
  Serverbackups; sie ist kein Packbestandteil.
- Bei einem Rollback zuerst mit `/co i` und `/co near <Radius>` die Ursache
  eingrenzen. Rollbacks immer klein und zeitlich knapp halten.
- Offline-Chunkloading verursacht echte Serverlast. Aenderungen an den
  Limits erst nach einem Spark-/TPS-Test im Staging vornehmen.
