# Bekannte Prüfpunkte

- Distant Horizons `3.2.0-b` ist offiziell Beta, wird aber wegen wichtiger AMD-, Speicher- und Iris-Korrekturen verwendet. Renderer auf `Auto` lassen.
- Entity Culling muss bei fehlerhaft verschwindenden Create-Seilrollen oder großen IE-Renderern gezielt erweitert werden.
- Create: Connected, Enchantment Industry und Dragons Plus liefern einige Loot-Tabellen für nicht installierte optionale Integrationen mit. NeoForge meldet deshalb fehlende optionale Gegenstände; die eigentlichen Registrierungen, Rezepte und Welten sind davon nicht betroffen.
- Dungeons & Taverns `4.4.4` besitzt zwei vom Autor dokumentierte fehlerhafte technische Advancements. Strukturen laden; nur die daran gekoppelten Händler-/Kartenfunktionen können ausbleiben.
- Bumblezone verwirft vier fehlerhaft formatierte optionale Bee-Queen-Rewards für Regions Unexplored. Dimension, Queen und die übrigen Trades laden normal.
- Naturalist 2.0 enthält bereits viele Meerestiere. Hybrid Aquatic bleibt deshalb bis zu Spawn- und TPS-Tests außerhalb von Stable.
- Bugs Aplenty bleibt wegen zusätzlicher Entitäten, Termitenmechanik und eingeschränkter automatischer Verteilung außerhalb des Packs.
- Chunky wird nicht mitgeliefert und Alpha 5 verwendet bewusst keine harte Worldborder oder flaechige Vorabgenerierung. Neue Chunks entstehen nur bei Erkundung; die Gruende und Schwellen fuer eine spaetere Neubewertung stehen in `server/COMMUNITY-OPERATIONS.md`.
- Create: Steam 'n' Rails hat keinen 1.21.1-NeoForge-Build.
- Doggy Talents besitzt ein eigenes Rückkehrsystem und wird deshalb von Redomesticate-Pet-Betten und Halsbändern ausgenommen.
- Adorable Hamster Pets und Redomesticate starten gemeinsam fehlerfrei; Bettbindung, Tod, Dimensionswechsel und Respawn benötigen noch einen echten Zwei-Client-Spieltest.
- Simple Voice Chat benötigt UDP-Port `24454` auf VM-, Proxmox- und Router-Firewall.
- More Culling und BadOptimizations bleiben absichtlich außerhalb des stabilen Packs. Beide sind erst nach einem vollständigen Shader-/Distant-Horizons-Test auf einem frischen Client als mögliche A/B-Kandidaten zu bewerten.
- Der Headless-Server ist validiert, ein echter Prism-GUI-Import samt Shaderbild und GTX-1080-FPS-Test steht noch aus.
