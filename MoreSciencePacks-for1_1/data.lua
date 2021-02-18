if not morescience then morescience = {} end
if not morescience.tech then morescience.tech = {} end

--omni.add_omniwaste()
--if not omni.chem then omni.chem={} end

require("prototypes.constants")
require("functions")
require("prototypes.item.item")
require("prototypes.recipe.recipe") --LOAD BEFORE recipe-dynamic!!!!


--CORRECT RECIPES BEFORE DYNAMIC RECIPE CREATION (copies from the recipes that already exist)
require("prototypes.recipe.recipe-integrations") --currently only used for AllAboutMoney integration. consider renaming and using different file per mod if integrations file grows.
require("prototypes.recipe.recipe-corrections")  --any updates required before loading dynamic-recipes should occur here.



--START DYNAMIC RECIPE FORMATION
--require("prototypes.recipe.recipe-dynamic")--Moved to data-final-fixes as the dynamic recipes are COPIES of the template recipe, and any mod that wishes to change the recipes must do so before the template is chosen. 



--if omnilib isn't active, then force legacyMode to true. setting is default=false. (if the config is on, omniLib presence is irrelevant.)
legacyMode = false --settings.startup["moresciencepack-legacyMode"].value --default is false. 
if not mods["omnilib"] then legacyMode = true end 
if settings.startup["moresciencepack-Omni-Ignored"].value == true then legacyMode = true end 

if legacyMode then --if either the legacyMode config is set to true or if omnilib is not detected, we must add unlocks for recipes in recipe.lua to their proper techs. 

	--Add recipe unlocks for sciece packs. Use: morescience.tech.add_recipe_unlock(technology, recipe)
	morescience.tech.add_recipe_unlock("optics", "more-science-pack-2") 
	morescience.tech.add_recipe_unlock("gun-turret", "more-science-pack-3") 
	morescience.tech.add_recipe_unlock("electronics", "more-science-pack-4") 
	morescience.tech.add_recipe_unlock("automation-2", "more-science-pack-5") 
	morescience.tech.add_recipe_unlock("advanced-material-processing", "more-science-pack-6") 
	morescience.tech.add_recipe_unlock("circuit-network", "more-science-pack-7") 
	morescience.tech.add_recipe_unlock("electric-energy-accumulators", "more-science-pack-9") 

		--fix angel's improper oil-processing override
		if data.raw.technology["angels-oil-processing"] then 
			morescience.tech.add_recipe_unlock("angels-oil-processing", "more-science-pack-8") --ANGELS
		else
			morescience.tech.add_recipe_unlock("oil-processing", "more-science-pack-8") --VANILLA
		end
		--fix angel's improper sulfur-processing override
		if data.raw.technology["angels-sulfur-processing-1"] then 
			morescience.tech.add_recipe_unlock("angels-sulfur-processing-1", "more-science-pack-10")  --ANGELS
		else
			morescience.tech.add_recipe_unlock("sulfur-processing", "more-science-pack-10") --VANILLA
		end

	morescience.tech.add_recipe_unlock("rail-signals", "more-science-pack-11") 
	morescience.tech.add_recipe_unlock("construction-robotics", "more-science-pack-12") 
	morescience.tech.add_recipe_unlock("flamethrower", "more-science-pack-13") 
	morescience.tech.add_recipe_unlock("tanks", "more-science-pack-14") 
	morescience.tech.add_recipe_unlock("laser-turrets", "more-science-pack-15") 
	morescience.tech.add_recipe_unlock("combat-robotics", "more-science-pack-16") 
	morescience.tech.add_recipe_unlock("electric-energy-distribution-2", "more-science-pack-17") 
	morescience.tech.add_recipe_unlock("productivity-module-2", "more-science-pack-18") 
	morescience.tech.add_recipe_unlock("nuclear-power", "more-science-pack-19") 

	morescience.tech.add_recipe_unlock("automation-3", "more-science-pack-20") 
	morescience.tech.add_recipe_unlock("energy-shield-mk2-equipment", "more-science-pack-21") 
	morescience.tech.add_recipe_unlock("logistics-3", "more-science-pack-22") 
	morescience.tech.add_recipe_unlock("effect-transmission", "more-science-pack-23") 
	morescience.tech.add_recipe_unlock("logistic-system", "more-science-pack-24") 
	morescience.tech.add_recipe_unlock("logistic-system", "more-science-pack-25") 
	morescience.tech.add_recipe_unlock("logistic-system", "more-science-pack-26") 
	morescience.tech.add_recipe_unlock("logistic-system", "more-science-pack-27") 
	morescience.tech.add_recipe_unlock("artillery", "more-science-pack-28") 
	morescience.tech.add_recipe_unlock("atomic-bomb", "more-science-pack-29") 
	morescience.tech.add_recipe_unlock("rocket-silo", "more-science-pack-30")

end

if settings.startup["moresciencepack-unlock-all-packs"].value == true then
	for i=1,30 do
		if data.raw.recipe["more-science-pack-"..i] then data.raw.recipe["more-science-pack-"..i].enabled = true end
	end
end

for i=1,30 do
	morescience.tech.module_limitation("more-science-pack-"..i) --allow productivity
end 
