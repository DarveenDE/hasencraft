// Keep equivalent cooked eggs interchangeable across mods.
ServerEvents.tags('item', event => {
  const cookedEggs = [
    'farmersdelight:fried_egg',
    'naturalist:cooked_egg'
  ]

  event.add('c:foods/cooked_egg', cookedEggs)
  event.add('c:cooked_eggs', cookedEggs)
})

// Give players a small, server-side reminder of the pack's most important
// navigation shortcuts without adding another client-only helper mod.
ServerEvents.basicCommand('hasencraft', event => {
  if (!event.player) return

  event.player.tell(Text.of('Hasencraft: FTB-Karte U | Xaero-Weltkarte M'))
  event.player.tell(Text.of('Das Questbuch führt euch durch die wichtigsten Systeme.'))
})
