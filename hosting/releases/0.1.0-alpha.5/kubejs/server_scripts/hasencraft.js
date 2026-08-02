// Keep equivalent cooked eggs interchangeable across mods.
ServerEvents.tags('item', event => {
  const cookedEggs = [
    'farmersdelight:fried_egg',
    'naturalist:cooked_egg'
  ]

  event.add('c:foods/cooked_egg', cookedEggs)
  event.add('c:cooked_eggs', cookedEggs)
})
