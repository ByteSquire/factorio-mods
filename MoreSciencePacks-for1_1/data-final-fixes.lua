if not morescience then morescience = {} end
if not morescience.tech then morescience.tech = {} end

require("functions")

--START DYNAMIC RECIPE FORMATION
require("prototypes.recipe.recipe-dynamic")



--TECH
require("prototypes.technology.technology-vanilla")
require("prototypes.technology.technology-modded")




--now we scan through the technology tree and add packs. 
if not settings.startup["moresciencepack-GameProgressionFix"].value == true then 

	if data.raw.technology["omnitech-more-science-pack-18-1"] then --fix pack 18 not getting caught in integration pass. 

		morescience.tech.add_science_pack_range({"omnitech-more-science-pack-18-1"}, 1, 12, 1)
		morescience.tech.add_science_pack_range({"omnitech-more-science-pack-18-1"}, 17, 17, 1)

	end


	for i=1, settings.startup["moresciencepack-TechTreeScanningPermutations"].value do
		--RUN INTEGRATION ENGINE. Multiple passes required for deep-tech-tree scanning. 
		if settings.startup["moresciencepack-IntegrationEngine"].value == true then morescience.tech.integrate() end
	end


	--Remove vanilla packs if configured to use only MSP (also option: remove modded packs later possibly. 
	--verified using Angels' mods. ONly researches that DO NOT have MSP packs added to them will have the vanilla packs (those listed in the table) removed from research costs---ie: replaced by MSP packs. simpler, cheaper, but maximal-compatability with mods that add researches to which MSP's integration engine skips for safety reasons or cyclic-dependency protection reasons. 	
	if settings.startup["moresciencepack-removeVanillaPacks"].value == true then
	
		refVanillaPacks = {"automation-science-pack", "logistic-science-pack", "military-science-pack", "chemical-science-pack", "production-science-pack", "utility-science-pack"}	
		
		for technology in pairs(data.raw.technology) do
		
			local removePacks = false
			
			for i, ingredient in pairs(data.raw.technology[technology].unit.ingredients) do
				if ingredient[1] == "more-science-pack-1" or ingredient.name == "more-science-pack-1" then
					removePacks = true
				end
			end
		
			if removePacks == true then 
				for _, pack in ipairs(refVanillaPacks) do 
					if data.raw.technology[technology] then
						for i, ingredient in pairs(data.raw.technology[technology].unit.ingredients) do
							if ingredient[1] == pack or ingredient.name == pack then
								table.remove(data.raw.technology[technology].unit.ingredients, i)
							end
						end
					else
						log("Technology " .. technology .. " does not exist.")
					end
				end
			end			
		end	
	end
	--end of vanilla-pack removal. 

end
 


--ascertion feature doesn't work; appears to cause more problems than it fixes.
if  settings.startup["moresciencepack-reset-ingredient-recipe-unlocks"].value == true then
	morescience.tech.reset_recipe_unlock("", "burner-inserter")
	morescience.tech.reset_recipe_unlock("", "burner-mining-drill")
	morescience.tech.reset_recipe_unlock("", "light-armor")
	morescience.tech.reset_recipe_unlock("", "pistol")
	morescience.tech.reset_recipe_unlock("optics", "small-lamp")
	morescience.tech.reset_recipe_unlock("logistics", "fast-inserter")
	morescience.tech.reset_recipe_unlock("automation", "long-handed-inserter")
	morescience.tech.reset_recipe_unlock("", "stone-furnace")
	--morescience.tech.reset_recipe_unlock("", "pipe") --literally does nothing.
	morescience.tech.reset_recipe_unlock("", "boiler")
	morescience.tech.reset_recipe_unlock("", "offshore-pump")
	morescience.tech.reset_recipe_unlock("advanced-material-processing", "steel-furnace")
	morescience.tech.reset_recipe_unlock("circuit-network", "red-wire")
	morescience.tech.reset_recipe_unlock("circuit-network", "green-wire")
	morescience.tech.reset_recipe_unlock("circuit-network", "constant-combinator")
	morescience.tech.reset_recipe_unlock("", "iron-stick")
		if not mods["bobelectronics"] then morescience.tech.reset_recipe_unlock("", "electronic-circuit") end		
	morescience.tech.reset_recipe_unlock("solar-energy", "solar-panel")
	morescience.tech.reset_recipe_unlock("electric-energy-accumulators", "accumulator")
	morescience.tech.reset_recipe_unlock("battery", "battery")
	morescience.tech.reset_recipe_unlock("railway", "rail")
	morescience.tech.reset_recipe_unlock("rail-signals", "rail-signal")
	morescience.tech.reset_recipe_unlock("rail-signals", "rail-chain-signal")
	morescience.tech.reset_recipe_unlock("construction-robotics","construction-robot")
	morescience.tech.reset_recipe_unlock("battery-equipment", "battery-equipment")
	morescience.tech.reset_recipe_unlock("flamethrower", "flamethrower")
	morescience.tech.reset_recipe_unlock("flamethrower", "flamethrower-ammo")
end

--/////////////////////////////////////////////////////////////////
--adjust stack size depending on modsettings for crafting result. Only increase, don't decrease (incase user wants insane stack sizes larger than necessary to prevent loss)
--new in version 0.0.37

if settings.startup["moresciencepack-Dynamic-stacksize"].value == true then 
	legacyMode = false --settings.startup["moresciencepack-legacyMode"].value --default is false. 
	if not mods["omnilib"] then legacyMode = true end 
	if settings.startup["moresciencepack-Omni-Ignored"].value == true then legacyMode = true end 
 
	for i=1,30 do
		local pack = "more-science-pack-"..i
		
		if data.raw["tool"][pack] then --and pack.stack_size then
		
		
			local resultCount = data.raw["recipe"]["more-science-pack-"..i].result_count
			local n = "" -- resultCount	
				
			--	if data.raw.tool(pack).stack_size < n then data.raw.tool(pack).stack_size = n end
			
			if legacyMode == true then 
				--omniLib is either not present, or is ignored by startup settings. no efficiency research and "pack multiplier" is used instead of of "effienciency tiers"
				n = resultCount * settings.startup["moresciencepack-multiplier"].value 
				if data.raw["tool"][pack].stack_size < n then data.raw["tool"][pack].stack_size = n*2 end
			else
				--omniLib is used, so dynamic recipe_results are generated for efficiency techs. this is "limited" by modsetting: omni-maximum and no recipe should exceed this amount. set the stack size to 2x this value. 
				n = settings.startup["moresciencepack-omni-maximum"].value
				if data.raw["tool"][pack].stack_size < n then data.raw["tool"][pack].stack_size = n*2 end
				--for most cases, in default, this will set all packs to have a stacksize of 800. (400 is default omni_maximum. * 2 = 800. this is sufficient to provide at least 2 crafts for each recipe; most recipes will have at least 3,4 crafts inside assembler before halting.)
				--should only apply if the stacksize is LESS than omniMaximum. if another mod, such as noxys stacksize, ReStack, or wormmus is used to make the stacksize, say 4,000, this should not reduce the stacksize back to 800.
			end
		
		else error("pack not found: "..tostring(pack.name))
		
		end

	end

end


		--big labs compatability
		if mods["BigLab"] then 
			for i=1,30 do
				if not morescience.tech.is_in_table("more-science-pack-" .. i, data.raw["lab"]["big-lab"].inputs) then 
					table.insert(data.raw["lab"]["big-lab"].inputs, "more-science-pack-" .. i)	
				end 					
			end				
		end


-- SeaBlock mod compatability: reactivate missing science packs and ingredients deactivated by SeaBlock.
-- see: https://github.com/KiwiHawk/SeaBlock/blob/0abf142ff4bcf1c83c9551d384798071a8a88269/SeaBlock/data-updates/military.lua
if mods["SeaBlock"] then
    -- science pack 2 and its ingredients:
    morescience.tech.add_recipe_unlock("optics", "more-science-pack-2")
    data.raw.recipe["more-science-pack-2"].hidden = false;
    bobmods.lib.recipe.replace_ingredient("more-science-pack-2", "burner-mining-drill", "burner-ore-crusher")

    -- science pack 6:
    morescience.tech.add_recipe_unlock("advanced-material-processing", "more-science-pack-6")
    data.raw.recipe["more-science-pack-6"].hidden = false;
    bobmods.lib.recipe.replace_ingredient("more-science-pack-6", "coal", "wood-charcoal")

    -- science pack 13 and its ingredients:
    morescience.tech.add_recipe_unlock("flammables", "more-science-pack-13")
    morescience.tech.add_recipe_unlock("flammables", "flamethrower")
    data.raw.recipe["flamethrower"].hidden = false;
    morescience.tech.add_recipe_unlock("flammables", "flamethrower-ammo")
    data.raw.recipe["flamethrower-ammo"].hidden = false;

    -- science pack 16 and its ingredient:
    morescience.tech.add_recipe_unlock("logistic-robotics", "more-science-pack-16")
    morescience.tech.add_recipe_unlock("logistic-robotics", "defender-capsule")
    data.raw.recipe["defender-capsule"].hidden = false;

    -- ingredients for science pack 27:
    morescience.tech.add_recipe_unlock("military-2", "combat-shotgun")
    data.raw.recipe["combat-shotgun"].hidden = false;
    morescience.tech.add_recipe_unlock("rocketry", "explosive-rocket")
    data.raw.recipe["explosive-rocket"].hidden = false;


    -- remove science pack 1 from red science tech and its prerequisites (those techs should not require any science packs in SeaBlock):
    morescience.tech.remove_recipe_from_tech_and_its_prerequisites("sct-automation-science-pack", "more-science-pack-1")
    -- make sure that packs 2 to 4 are possible to unlock:
    morescience.tech.remove_recipe_from_tech_and_its_prerequisites(morescience.tech.get_tech_of_recipe("more-science-pack-2"), "more-science-pack-2")
    morescience.tech.remove_recipe_from_tech_and_its_prerequisites(morescience.tech.get_tech_of_recipe("more-science-pack-3"), "more-science-pack-3")
    morescience.tech.remove_recipe_from_tech_and_its_prerequisites(morescience.tech.get_tech_of_recipe("more-science-pack-4"), "more-science-pack-4")
    morescience.tech.remove_recipe_from_tech_and_its_prerequisites(morescience.tech.get_tech_of_recipe("more-science-pack-5"), "more-science-pack-5")
end


-- Angels Refining: make possible to craft "more-science-pack-1" at beginning of the game.
-- Because normal copper ore or iron ore are possible to get only when "Mechanical Refining" is researched (which requires science packs 1,2,3)
if mods["angelsrefining"]
    and data.raw.item["copper-ore"].subgroup == "angels-copper"
    and data.raw.item["iron-ore"].subgroup == "angels-iron"
    and
        (
            -- saphirite is possible to be crafted at start of game? :
            (data.raw.recipe["angelsore1-crushed"] ~= nil and data.raw.recipe["angelsore1-crushed"].enabled == true)
            or (data.raw.recipe["angelsore1-crushed-hand"] ~= nil and data.raw.recipe["angelsore1-crushed-hand"].enabled == true)
        )
    and
        (
            -- stiratite is possible to be crafted at start of game? :
            (data.raw.recipe["angelsore3-crushed"] ~= nil and data.raw.recipe["angelsore3-crushed"].enabled == true)
            or (data.raw.recipe["angelsore3-crushed-hand"] ~= nil and data.raw.recipe["angelsore3-crushed-hand"].enabled == true)
        )
then
    local sciencePack1AngelsAlternate = table.deepcopy(data.raw.recipe["more-science-pack-1"])

    sciencePack1AngelsAlternate.name = "more-science-pack-1-angels-alternate"
    sciencePack1AngelsAlternate.ingredients = {
        {"angels-ore3-crushed", 3},
        {"angels-ore1-crushed", 3}
    }
    sciencePack1AngelsAlternate.localised_name = {"item-name.more-science-pack-1-angels-alternate"}

    data:extend({sciencePack1AngelsAlternate})
end


