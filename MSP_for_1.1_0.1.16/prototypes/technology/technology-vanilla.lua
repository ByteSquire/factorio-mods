if not morescience.tech then morescience.tech = {} end

--[[ 
Code edit and replacements with usage of functions below to fix issues with previous version's "explicit effect-declaration" overriding other mod code and breaking compatability with any other mods that attempt to utilize technologies in vanilla to unlock recipes that this mod also attempts to utilize.

step one in conflict resolution: remove all explicit-effect-declaration that overriding other mod's effects that may be added without requiring numerous updates. we will, instead, add recipe unlocks for each of our science packs into data-final-updates.lua

	morescience.tech.add_recipe_unlock(technology, recipe)
	morescience.tech.add_science_pack_range(techList, first, last, amount)	
	
	table.insert(data.raw.technology[technology].unit.ingredients,{pack, amount}
	
	impact: compressed 7000 lines of code into 200, and fixed issues where other mods prevented science packs from having a recipe unlock or the reverse happening, where this mod was preventing other recipe-unlocks other mods try to add to vanilla technology.
	
--]]

if not settings.startup["moresciencepack-GameProgressionFix"].value == true then 

	--morescience.tech.add_science_pack_range(techList, first, last, amount)
	--morescience.tech.add_science_pack_range(techList, 1, last, 1)

	--EARLY PACKS
	morescience.tech.add_science_pack_range({"logistics", "optics", "stone-walls"}, 1, 1, 1)
	morescience.tech.add_science_pack_range({"turrets"}, 1, 2, 1)
	morescience.tech.add_science_pack_range({"automation","electronics","military","military-2"}, 1, 3, 1)
	morescience.tech.add_science_pack_range({"steel-processing", "automation-2"}, 1, 4, 1)

	morescience.tech.add_science_pack_range({"circuit-network", "heavy-armor", "research-speed-1", "electric-energy-distribution-1", "advanced-material-processing", "toolbelt", "landfill", "shotgun-shell-damage-1", "shotgun-shell-speed-1", "gun-turret-damage-1", "bullet-damage-1", "bullet-speed-1", "fluid-handling", "oil-processing"}, 1, 5, 1)

	morescience.tech.add_science_pack_range({"gates", "concrete", "engine", "shotgun-shell-damage-2", "shotgun-shell-speed-2", "gun-turret-damage-2", "bullet-damage-2", "bullet-speed-2"}, 1, 7, 1)

	morescience.tech.add_science_pack_range({"flammables", "railway", "automated-rail-transportation", "rail-signals", "automobilism", "solar-energy", "laser", "logistics-2", "research-speed-2", "electric-energy-accumulators", "electric-engine", "battery", "shotgun-shell-speed-3", "bullet-speed-3", "sulfur-processing", "plastics", "modules"}, 1, 8, 1)

		if not mods["omnimatter_science"] then  
		morescience.tech.add_science_pack_range({"logistics-2"}, 9, 10, 1) 
		--omniscience fix involving omnipack being added to vanilla techs and it requiring items from Logistics 2. So long as it is not enabled, MSP 9 and 10 can be added (as originally done)
		end 
		
	morescience.tech.add_science_pack_range({"stack-inserter", "inserter-capacity-bonus-1", "inserter-capacity-bonus-2", "advanced-electronics", "fluid-wagon", "modular-armor", "flying", "robotics", "construction-robotics", "shotgun-shell-damage-3", "night-vision-equipment", "battery-equipment", "solar-panel-equipment", "cliff-explosives", "advanced-oil-processing", "electric-energy-distribution-2"}, 1, 10, 1)

		--Handle specificially for the case of anytime either bob's modules or custom modules is enabled
		if not mods["bobmodules"] and not mods["CustomModules"] then 
			morescience.tech.add_science_pack_range({"speed-module", "productivity-module", "effectivity-module"}, 1, 10, 1)
			
			morescience.tech.add_science_pack_range({"speed-module-2", "productivity-module-2", "effectivity-module-2","speed-module-3", "productivity-module-3", "effectivity-module-3"}, 1, 12, 1)
			morescience.tech.add_science_pack_range({"speed-module-2", "productivity-module-2", "effectivity-module-2","speed-module-3", "productivity-module-3", "effectivity-module-3"}, 17, 17, 1)
			
			morescience.tech.add_science_pack_range({"speed-module-3", "productivity-module-3", "effectivity-module-3"}, 18, 27, 1)
		end
			
		--ADD pack 11
		--table.insert(data.raw.technology["cliff-explosives"].unit.ingredients,{refPacks[tostring(11)], 1}) --add pack 11 to cliff explosives.
		morescience.tech.add_science_pack_range({"cliff-explosives", "electric-energy-distribution-2"}, 11, 11, 1)

	--MAIN PACKS 1-12
	morescience.tech.add_science_pack_range({"flamethrower", "logistic-robotics", "character-logistic-slots-1", "character-logistic-slots-2",  "character-logistic-trash-slots-1", "inserter-capacity-bonus-3", "advanced-electronics-2", "braking-force-1", "power-armor", "research-speed-3", "advanced-material-processing-2", "worker-robots-speed-1", "worker-robots-storage-1", "character-logistic-slots-3", "character-logistic-trash-slots-2", "battery-mk2-equipment", "exoskeleton-equipment", "personal-roboport-equipment", "automation-3", "braking-force-2", "research-speed-4", "worker-robots-speed-2", "auto-character-logistic-trash-slots", "inserter-capacity-bonus-4", "logistics-3", "research-speed-5", "effect-transmission", "worker-robots-speed-3", "worker-robots-storage-2", "character-logistic-slots-4", "coal-liquefaction", "inserter-capacity-bonus-5", "inserter-capacity-bonus-6", "inserter-capacity-bonus-7", "braking-force-3", "braking-force-4", "braking-force-5", "braking-force-6", "braking-force-7","research-speed-6", "logistic-system", "fusion-reactor-equipment", "worker-robots-speed-4", "worker-robots-speed-5", "worker-robots-storage-3", "character-logistic-slots-5", "character-logistic-slots-6", "personal-roboport-equipment-2", "worker-robots-speed-6"}, 1, 12, 1)

	--MAIN PACKS 1-13
	morescience.tech.add_science_pack_range({"grenade-damage-1", "grenade-damage-2", "explosives", "land-mine", "rocketry", "laser-turrets", "shotgun-shell-damage-4", "shotgun-shell-speed-4", "gun-turret-damage-3", "gun-turret-damage-4", "flamethrower-damage-1", "energy-shield-equipment", "bullet-damage-3", "bullet-damage-4", "bullet-speed-4", "combat-robotics", "military-3", "grenade-damage-3", "tanks", "laser-turret-damage-1",  "laser-turret-speed-1", "flamethrower-damage-2", "combat-robot-damage-1", "rocket-damage-1", "rocket-speed-1"}, 1, 13, 1)

	--ADD packs 15-16
	morescience.tech.add_science_pack_range({"military-3", "grenade-damage-3", "tanks", "laser-turret-damage-1",  "laser-turret-speed-1", "flamethrower-damage-2", "combat-robot-damage-1", "rocket-damage-1", "rocket-speed-1"}, 15, 16, 1)

	--MAIN PACKS 1-16
	morescience.tech.add_science_pack_range({"laser-turret-damage-2", "laser-turret-speed-2", "combat-robot-damage-2", "rocket-damage-2", "rocket-speed-2"}, 1, 16, 1)

	--ADD pack 17
	morescience.tech.add_science_pack_range({"inserter-capacity-bonus-3", "advanced-electronics-2", "braking-force-1", "power-armor", "research-speed-3", "advanced-material-processing-2", "worker-robots-speed-1", "worker-robots-storage-1", "character-logistic-slots-3", "character-logistic-trash-slots-2", "battery-mk2-equipment", "exoskeleton-equipment", "personal-roboport-equipment", "advanced-oil-processing"}, 17, 17, 1)

	--ADD pack 17-19
	morescience.tech.add_science_pack_range({"automation-3", "braking-force-2", "research-speed-4", "worker-robots-speed-2", "auto-character-logistic-trash-slots"}, 17, 19, 1)

	--MAIN PACKS 1-19
	morescience.tech.add_science_pack_range({"grenade-damage-4", "explosive-rocketry", "shotgun-shell-damage-5", "shotgun-shell-speed-5", "laser-turret-damage-3", "laser-turret-speed-3", "gun-turret-damage-5", "flamethrower-damage-3", "energy-shield-mk2-equipment", "personal-laser-defense-equipment", "discharge-defense-equipment", "bullet-damage-5", "bullet-speed-5", "combat-robotics-2", "combat-robot-damage-3", "rocket-damage-3", "rocket-speed-3", "cannon-shell-damage-1", "cannon-shell-speed-1"}, 1, 19, 1)

	--ADD pack 17-21
	morescience.tech.add_science_pack_range({"inserter-capacity-bonus-4", "logistics-3", "research-speed-5", "effect-transmission", "worker-robots-speed-3", "worker-robots-storage-2", "character-logistic-slots-4", "coal-liquefaction",  "inserter-capacity-bonus-5", "inserter-capacity-bonus-6", "inserter-capacity-bonus-7", "braking-force-3", "braking-force-4", "braking-force-5", "braking-force-6", "braking-force-7", "research-speed-6", "logistic-system", "fusion-reactor-equipment"}, 17, 21, 1)

	--MAIN PACKS 1-21
	morescience.tech.add_science_pack_range({"military-4", "grenade-damage-5", "grenade-damage-6", "shotgun-shell-damage-6", "shotgun-shell-speed-6", "laser-turret-damage-4", "laser-turret-damage-5",  "laser-turret-damage-6", "laser-turret-damage-7", "laser-turret-speed-4", "laser-turret-speed-5", "laser-turret-speed-6", "laser-turret-speed-7", "gun-turret-damage-6", "flamethrower-damage-4",  "flamethrower-damage-5", "flamethrower-damage-6", "bullet-damage-6", "bullet-speed-6", "combat-robot-damage-4", "combat-robot-damage-5", "rocket-damage-4", "rocket-damage-5", "rocket-damage-6",  "rocket-speed-4", "rocket-speed-5", "rocket-speed-6", "rocket-speed-7", "cannon-shell-damage-2", "cannon-shell-damage-3", "cannon-shell-damage-4", "cannon-shell-speed-2", "cannon-shell-speed-3", "cannon-shell-speed-4", "cannon-shell-speed-5"}, 1, 21, 1)

	--ADD pack 22-23
	morescience.tech.add_science_pack_range({"inserter-capacity-bonus-5", "inserter-capacity-bonus-6", "inserter-capacity-bonus-7", "braking-force-3", "braking-force-4", "braking-force-5", "braking-force-6", "braking-force-7",  "research-speed-6", "logistic-system", "fusion-reactor-equipment"}, 22, 23, 1)

	--ADD pack 17-27
	morescience.tech.add_science_pack_range({"worker-robots-speed-4", "worker-robots-speed-5", "worker-robots-storage-3", "character-logistic-slots-5", "character-logistic-slots-6", "personal-roboport-equipment-2", "worker-robots-speed-6"}, 17, 27, 1)

	--MAIN PACKS 1-27
	morescience.tech.add_science_pack_range({"atomic-bomb", "cannon-shell-damage-5", "uranium-ammo", "power-armor-2", "combat-robotics-3", "grenade-damage-7", "shotgun-shell-damage-7", "laser-turret-damage-8",  "gun-turret-damage-7", "flamethrower-damage-7", "bullet-damage-7", "combat-robot-damage-6", "rocket-damage-7", "cannon-shell-damage-6", "artillery-shell-range-1", "artillery-shell-speed-1"}, 1, 27, 1)

	--ROCKET SILO: 1-29
	morescience.tech.add_science_pack_range({"rocket-silo"}, 1, 29, 1)

	--ADD pack 28-29
	morescience.tech.add_science_pack_range({"uranium-ammo", "power-armor-2", "combat-robotics-3", "worker-robots-speed-6", "grenade-damage-7", "shotgun-shell-damage-7", "laser-turret-damage-8", "gun-turret-damage-7", "flamethrower-damage-7", "bullet-damage-7", "combat-robot-damage-6", "rocket-damage-7", "cannon-shell-damage-6", "artillery-shell-range-1", "artillery-shell-speed-1"}, 28, 29, 1)

	--ADD pack 30 to infinite techs
	morescience.tech.add_science_pack_range({"worker-robots-speed-6", "grenade-damage-7", "shotgun-shell-damage-7", "laser-turret-damage-8", "gun-turret-damage-7", "flamethrower-damage-7", "bullet-damage-7", "combat-robot-damage-6", "rocket-damage-7", "cannon-shell-damage-6", "artillery-shell-range-1", "artillery-shell-speed-1"}, 30, 30, 1)

end

