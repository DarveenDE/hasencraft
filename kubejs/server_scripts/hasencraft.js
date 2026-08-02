// Hasencraft server customizations.

const RIGHT_CLICK_HARVESTABLE_CROPS = {
  'minecraft:wheat': {
    ripeAge: 7,
    drops: () => [
      ['minecraft:wheat', 1],
      ['minecraft:wheat_seeds', Math.floor(Math.random() * 4)]
    ]
  },
  'minecraft:carrots': {
    ripeAge: 7,
    drops: () => [
      ['minecraft:carrot', 1 + Math.floor(Math.random() * 3)]
    ]
  },
  'minecraft:potatoes': {
    ripeAge: 7,
    drops: () => {
      const drops = [['minecraft:potato', 1 + Math.floor(Math.random() * 3)]]
      if (Math.random() < 0.02) {
        drops.push(['minecraft:poisonous_potato', 1])
      }
      return drops
    }
  },
  'minecraft:beetroots': {
    ripeAge: 3,
    drops: () => [
      ['minecraft:beetroot', 1],
      ['minecraft:beetroot_seeds', Math.floor(Math.random() * 4)]
    ]
  },
  'minecraft:nether_wart': {
    ripeAge: 3,
    drops: () => [
      ['minecraft:nether_wart', 1 + Math.floor(Math.random() * 3)]
    ]
  },
  'minecraft:cocoa': {
    ripeAge: 2,
    drops: () => [
      ['minecraft:cocoa_beans', 1 + Math.floor(Math.random() * 2)]
    ]
  }
}

BlockEvents.rightClicked(event => {
  if (event.level.isClientSide()) return
  if (event.hand !== 'MAIN_HAND') return

  const crop = RIGHT_CLICK_HARVESTABLE_CROPS[event.block.id]
  if (!crop) return

  const age = Number(event.block.properties.age)
  if (age !== crop.ripeAge) return

  event.cancel()

  crop.drops()
    .filter(([, count]) => count > 0)
    .forEach(([item, count]) => {
      for (let i = 0; i < count; i++) {
        event.block.popItem(item)
      }
    })

  event.block.set(event.block.id, Object.assign({}, event.block.properties, { age: 0 }))
})
