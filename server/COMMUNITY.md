# Community-Betrieb

Diese Anleitung gilt fuer `0.1.0-alpha.6` und den Communityserver. Aenderungen
an Rollen oder Weltzustand erhalten vorher einen Offline-Snapshot und werden
anschliessend gegen den laufenden Serverzustand geprueft.

## Was der Communityserver bereitstellt

- **FTB Chunks** nutzt die bereits vorhandenen FTB Teams fuer Claims und
  Schutz. Neue Teams erhalten 64 Claims, hoechstens 128 pro Team und acht
  force-geladene Chunks. Claims laufen nicht automatisch ab; nach 30 Tagen
  ohne Login werden nur die Offline-Lasten freigegeben.
- **LuckPerms** verwaltet die Rollen. Die Claim-Limits sind absichtlich als
  globale, nachvollziehbare Serverwerte konfiguriert; nur Offline-Chunkloading
  wird gezielt an die Rolle `supporter` vergeben.

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

`default` bleibt die normale Spielerrolle. `supporter` darf innerhalb der
globalen FTB-Chunks-Limits eigene Team-Chunks offline geladen halten.
`moderator` erbt `supporter` und darf Spielende kicken, bannen und begnadigen,
die Whitelist verwalten, teleportieren und zuschauen. LuckPerms-Daten sind fuer
Moderation lesbar, aber nicht veraenderbar. OP, Serverstopp, Reload, Saves,
Gamerules, Worldborder und weitere Serverkonfiguration bleiben explizit
verweigert. `admin` erbt `moderator` und ist die einzige Rolle mit vollem
LuckPerms- und OP-Zugriff.

Die produktive Alpha-5-Zuweisung lautet:

- `Darveen`: `admin`, OP-Level 4
- `Amayia`: `moderator`, kein OP
- `supporter`: vorbereitet, derzeit ohne direkte Zuweisung

Die idempotente Einrichtung ueber die Serverkonsole lautet:

```text
lp creategroup supporter 10 Supporter
lp creategroup moderator 20 Moderator
lp creategroup admin 100 Admin
lp group supporter parent add default
lp group moderator parent add supporter
lp group admin parent add moderator
lp group supporter permission set ftbchunks.chunk_load_offline true
lp group moderator permission set minecraft.command.kick true
lp group moderator permission set minecraft.command.ban true
lp group moderator permission set minecraft.command.banlist true
lp group moderator permission set minecraft.command.pardon true
lp group moderator permission set minecraft.command.whitelist true
lp group moderator permission set minecraft.command.teleport true
lp group moderator permission set minecraft.command.spectate true
lp group moderator permission set luckperms.info true
lp group moderator permission set luckperms.user.info true
lp group moderator permission set luckperms.user.permission.check true
lp group moderator permission set luckperms.group.info true
lp group moderator permission set luckperms.group.permission.info true
lp group moderator permission set minecraft.command.op false
lp group moderator permission set minecraft.command.deop false
lp group moderator permission set minecraft.command.stop false
lp group moderator permission set minecraft.command.reload false
lp group moderator permission set minecraft.command.save-all false
lp group moderator permission set minecraft.command.save-off false
lp group moderator permission set minecraft.command.save-on false
lp group moderator permission set minecraft.command.gamerule false
lp group moderator permission set minecraft.command.worldborder false
lp group moderator permission set minecraft.command.difficulty false
lp group moderator permission set minecraft.command.forceload false
lp group moderator permission set minecraft.command.setidletimeout false
lp group moderator permission set minecraft.command.setworldspawn false
lp group admin permission set luckperms.* true
lp user Amayia parent add moderator
lp user Darveen parent add admin
deop Amayia
op Darveen
```

`supporter` darf maximal die global konfigurierten acht force-geladenen Chunks
auch ohne eingeloggtes Teammitglied aktiv halten. Die globalen Limits werden
nicht durch numerische Permission-Knoten ueberschrieben. Nach Aenderungen mit
den benannten Konten pruefen:

```text
lp user Amayia permission check ftbchunks.chunk_load_offline
lp user Amayia permission check minecraft.command.kick
lp user Amayia permission check minecraft.command.op
lp user Darveen permission check luckperms.*
```

Am 2. August 2026 bestaetigte ein serverlokaler LuckPerms-Export die komplette
Vererbung und alle True-/False-Nodes beider Konten. `ops.json` enthielt genau
einen Eintrag (`Darveen`, Level 4); `Amayia` war kein OP.

## Betriebshinweise

- Wiederherstellungen erfolgen ausschliesslich ueber einen pruefbaren
  Server-Backup-Snapshot. Vor jeder Wiederherstellung zuerst die Ursache im
  Staging nachvollziehen und den betroffenen Weltstand sichern.
- Offline-Chunkloading verursacht echte Serverlast. Aenderungen an den
  Limits erst nach einem Spark-/TPS-Test im Staging vornehmen.
