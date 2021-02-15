if not morescience then morescience = {} end
if not morescience.lib then morescience.lib = {} end
if not morescience.lib.item then morescience.lib.item = {} end
if not morescience.tech then morescience.tech = {} end
if not morescience.recipe then morescience.recipe = {} end

--define local array and science-tier matrix

local refPacks = {["1"] = "more-science-pack-1", ["2"] = "more-science-pack-2", ["3"] = "more-science-pack-3", ["4"] = "more-science-pack-4", ["5"] = "more-science-pack-5", ["6"] = "more-science-pack-6",
		["7"] = "more-science-pack-7", ["8"] = "more-science-pack-8", ["9"] = "more-science-pack-9", ["10"] = "more-science-pack-10", ["11"] = "more-science-pack-11", ["12"] = "more-science-pack-12",
		["13"] = "more-science-pack-13", ["14"] = "more-science-pack-14", ["15"] = "more-science-pack-15", ["16"] = "more-science-pack-16", ["17"] = "more-science-pack-17", ["18"] = "more-science-pack-18",
		["19"] = "more-science-pack-19", ["20"] = "more-science-pack-20", ["21"] = "more-science-pack-21", ["22"] = "more-science-pack-22", ["23"] = "more-science-pack-23", ["24"] = "more-science-pack-24",
		["25"] = "more-science-pack-25", ["26"] = "more-science-pack-26", ["27"] = "more-science-pack-27", ["28"] = "more-science-pack-28", ["29"] = "more-science-pack-29", ["30"] = "more-science-pack-30"}

local refSettings = {["1"] = "MSP-pack1-result", ["2"] = "MSP-pack2-result", ["3"] = "MSP-pack3-result", ["4"] = "MSP-pack4-result", ["5"] = "MSP-pack5-result", ["6"] = "MSP-pack6-result",
		["7"] = "MSP-pack7-result", ["8"] = "MSP-pack8-result", ["9"] = "MSP-pack9-result", ["10"] = "MSP-pack10-result", ["11"] = "MSP-pack11-result", ["12"] = "MSP-pack12-result",
		["13"] = "MSP-pack13-result", ["14"] = "MSP-pack14-result", ["15"] = "MSP-pack15-result", ["16"] = "MSP-pack16-result", ["17"] = "MSP-pack17-result", ["18"] = "MSP-pack18-result",
		["19"] = "MSP-pack19-result", ["20"] = "MSP-pack20-result", ["21"] = "MSP-pack21-result", ["22"] = "MSP-pack22-result", ["23"] = "MSP-pack23-result", ["24"] = "MSP-pack24-result",
		["25"] = "MSP-pack25-result", ["26"] = "MSP-pack26-result", ["27"] = "MSP-pack27-result", ["28"] = "MSP-pack28-result", ["29"] = "MSP-pack29-result", ["30"] = "MSP-pack30-result"}		


function morescience.tech.add_science_pack_range(techList, first, last, amount)
	for technology in pairs(techList) do --for each technology called in the array sent with this function, we'll add all the science packs within the range given.
		if data.raw.technology[techList[technology]] then
			for i=last,first,-1 do	
				if settings.startup[refSettings[tostring(i)]].value > 0 then --enable individual disabling of MSP science packs from all technologies. if the result-count is set to 0, do not add pack. 
					table.insert(data.raw.technology[techList[technology]].unit.ingredients,{refPacks[tostring(i)], 1})
				else 
					log("will prevent addition of MSP-" .. i .. " to technology: " .. techList[technology] .. "setting name is: " .. refSettings[tostring(i)] .. ". value set =" .. settings.startup["MSP-pack" .. i .. "-result"].value)
				end 
			end
			
			--logging below is provided for troubleshooting any additional mod-integration testing. If enabled, it'll print lists of packs being added for_each technology touched. 
			if settings.startup["moresciencepack-debugLogging"].value == true then
				if first == last then
					log("attempted add MSP-" .. first .. " to technology: " .. techList[technology])
				else
					log("attempted add MSP-" .. first .. "-" .. last .. " to technology: " .. techList[technology])				
				end
			end
		else --technology does not exist. print to log, and if setting is enabled, immediately terminate game.
			log("Technology " .. techList[technology] .. " does not exist. Failed to insert MoreSciencePacks-for1_1.") --prints regardless of setting chosen for debugLogging. As this is a true error. Debate whether to use:
			if settings.startup["moresciencepack-ErrorOnFail"].value == true then
				error("Technology " .. techList[technology] .. " does not exist. Failed to insert MoreSciencePacks-for1_1. Game will now close because startup.setting:ErrorOnFail is enabled.")
			end 
		end	
	end
end


----NEW v0.0.7			--Initialize local variable "scienceArray". 0 means skip the science pack = i, and 1 means add the science pack = i.
local scienceArray = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"} --does not need explicit definition. should be passed to function as an argument/



--[[
The function below can be passed a table containing a list of technologies, or a single technology reference, a table containing 30 binary integers (0,1) that indicate whether all the technologies should have the science packs added or not. 
]]
function morescience.tech.add_science_pack_array(techList, scienceArray, amount)
	if type(techList) == "table" then
		for technology in pairs(techList) do --for each technology in techList, we'll add all the science packs listed as true (value = 1) in the array "science array".
			if data.raw.technology[techList[technology]] then

				for i, pack in pairs(scienceArray) do
					if scienceArray[i] == "1" and settings.startup[refSettings[tostring(i)]].value > 0 then --ScienceArray[i] is either 0 or 1. startup config value for pack set to 0 results in skipping section, enables user-disabling of individual packs in config options. 
						if settings.startup["moresciencepack-debugLogging"].value == true then log("MSP-" .. i .. " science added via ARRAY function to technology: " .. techList[technology]) end
						local addit = true
						--insert blacklist-check here. (not ready to add that feature quite yet.)
						--if not refBlacklist[Technology].disabledPackList[tostring(i)] then 
						
						--Ensure science pack type isn't already in list of ingredients and if it isn't, then we can add it.
						
						for k, ingredient in pairs(data.raw.technology[technology].unit.ingredients) do
						  if ingredient[1] == refPacks[tostring(i)] or ingredient.name == refPacks[tostring(i)] then addit = false end
						end
						if addit then table.insert(data.raw.technology[techList[technology]].unit.ingredients,{refPacks[tostring(i)], 1}) end
						
					end 
				end
				
			else --technology does not exist. print to log, and if ErrorOnFail setting is enabled, terminate game.
				log("Technology " .. techList[technology] .. " does not exist. Failed to insert MoreSciencePacks-for1_1.") --prints regardless of setting chosen for debugLogging. As this is a true error. Debate whether to use:
				if settings.startup["moresciencepack-ErrorOnFail"].value == true then
					error("Technology " .. techList[technology] .. " does not exist. Failed to insert MoreSciencePacks-for1_1. Game will now close because startup.setting:ErrorOnFail is enabled.")
				end 
			
			end
		end	
	else --technology wasn't sent as table. the variable used above "TechList" is now a single technology reference instead of a table containing multiple technology names. small code adjustments follow:
	
		if data.raw.technology[techList] then
			for i, pack in pairs(scienceArray) do
				if scienceArray[i] == "1" and settings.startup[refSettings[tostring(i)]].value > 0 then --ScienceArray[i] is either 0 or 1. startup config value for pack set to 0 results in skipping section, enables user-disabling of individual packs in config options. 
					--if settings.startup["moresciencepack-debugLogging"].value == true then log("MSP-" .. i .. " science added via ARRAY function to technology: " .. tostring(data.raw.technology[techList])) end
					local addit = true	
					--insert blacklist-check here. (not ready to add that feature quite yet.)
					--if not refBlacklist[Technology].disabledPackList[tostring(i)] then 
						
					--Ensure science pack type isn't already in list of ingredients and if it isn't, then we can add it.
					
					for k, ingredient in pairs(data.raw.technology[techList].unit.ingredients) do
					  if ingredient[1] == refPacks[tostring(i)] or ingredient.name == refPacks[tostring(i)] then addit = false end
					end
					if addit then table.insert(data.raw.technology[techList].unit.ingredients,{refPacks[tostring(i)], 1}) end			
						
				end 
			end
				
		else --technology does not exist. print to log, and if ErrorOnFail setting is enabled, terminate game.
				log("Technology " .. tostring(data.raw.technology[techList]) .. " does not exist. Failed to insert MoreSciencePacks-for1_1.") --prints regardless of setting chosen for debugLogging. As this is a true error. Debate whether to use:
				if settings.startup["moresciencepack-ErrorOnFail"].value == true then
					--error("Technology " .. tostring(data.raw.technology[techList]) .. " does not exist. Failed to insert MoreSciencePacks-for1_1. Game will now close because startup.setting:ErrorOnFail is enabled.")
				end 			
		end		
	end 
end



function morescience.recipe.add_ingredient(recipe, item) --requires too many other bob's lib function. just set bob lib as dependency...
  if data.raw.recipe[recipe] and morescience.lib.item.get_type(morescience.lib.item.basic_item(item).name) then

    if data.raw.recipe[recipe].expensive then
      morescience.lib.item.add(data.raw.recipe[recipe].expensive.ingredients, morescience.lib.item.basic_item(item))
    end
    if data.raw.recipe[recipe].normal then
      morescience.lib.item.add(data.raw.recipe[recipe].normal.ingredients, morescience.lib.item.basic_item(item))
    end
    if data.raw.recipe[recipe].ingredients then
      morescience.lib.item.add(data.raw.recipe[recipe].ingredients, morescience.lib.item.basic_item(item))
    end

  else
    if not data.raw.recipe[recipe] then
      log("Recipe " .. recipe .. " does not exist.")
    end
    if not morescience.lib.item.get_basic_type(morescience.lib.item.basic_item(item).name) then
      log("Ingredient " .. morescience.lib.item.basic_item(item).name .. " does not exist.")
    end
  end
end

function morescience.round(number)
	local decimal = number - math.floor(number)
	if decimal >= 0.5 then
		return math.floor(number)+1
	else
		return math.floor(number)
	end	
end


function morescience.tech.add_recipe_unlock(technology, recipe)
  if data.raw.technology[technology] and data.raw.recipe[recipe] then
    local addit = true
    if not data.raw.technology[technology].effects then
      data.raw.technology[technology].effects = {}
    end
    for i, effect in pairs(data.raw.technology[technology].effects) do
      if effect.type == "unlock-recipe" and effect.recipe == recipe then addit = false end
    end
    if addit then table.insert(data.raw.technology[technology].effects,{type = "unlock-recipe", recipe = recipe}) end
  else
    if not data.raw.technology[technology] then
      log("Technology " .. technology .. " does not exist.")
    end
    if not data.raw.recipe[recipe] then
      log("Recipe " .. recipe .. " does not exist.")
    end
  end
end

function morescience.tech.remove_recipe_unlock(technology, recipe)
  if data.raw.technology[technology] and data.raw.technology[technology].effects then
    for i, effect in pairs(data.raw.technology[technology].effects) do
      if effect.type == "unlock-recipe" and effect.recipe == recipe then
        table.remove(data.raw.technology[technology].effects,i)
      end
    end
  else
    if not data.raw.technology[technology] then
      log("Technology " .. technology .. " does not exist.")
    end
  end
end

--[[
--test function for https://mods.factorio.com/mod/fast_trans/discussion/5b93dcee8a7387000b34ed17
function morescience.printFuels()
	for item in pairs(data.raw.item) do
		if data.raw.item[item].fuel_value then --and item.fuel_value > 100 then 
			log("fuel detected: ".. item .. ". fuel value is: " ..data.raw.item[item].fuel_value..".")
			
			--seems lua/factorio treats fuel values as strings internally [ie:100MJ or 1GJ] as examples, although the api states it treats fuel values as a float value. we can deal with this by converting the string back into a float value within a local variable
			
			local value = data.raw.item[item].fuel_value
			local convertedValue = 0
			
			if string.match(value, "GJ") then --1000mj or more
				convertedValue = string.gsub(value, "GJ", "")
				convertedValue = tonumber(convertedValue)*1000
			else
				if string.match(value, "MJ") then
					convertedValue = string.gsub(value, "MJ", "")
					convertedValue = tonumber(convertedValue)
				end			
			end 
			
			log("converted fuel value: ".. item .. " = " ..convertedValue)
		end 
	end 
end
--]]

--Scans entire tech tree, relocates a recipe unlock that has been moved by a another mod (causing an incompatability with MSP) and then reinserts recipe unlock into the original tech. May require optional dependency updates to info.json
function morescience.tech.reset_recipe_unlock(target, recipe)
	--new corrections should fix resetrecipeunlock. continuing errors may still require additions to optional-dependency-flags in info.json v0.29
	if target == "" or target == nil then
		if data.raw.recipe[recipe] then 
			if data.raw.recipe[recipe].enabled == false then --only scan tech tree if item is not already enabled from start. 
				for tech in pairs(data.raw.technology) do
					morescience.tech.remove_recipe_unlock(tech, recipe)	 --remove redundant unlocks
				end
				local failcheck = false 
					if data.raw.recipe[recipe].normal then 
						data.raw.recipe[recipe].normal.enabled = true 
						failcheck = true 
					end
					if data.raw.recipe[recipe].expensive then
						data.raw.recipe[recipe].expensive.enabled = true 
						failcheck = true 
					end
					if data.raw.recipe[recipe] then data.raw.recipe[recipe].enabled = true 
						failcheck = true 
					end
					if failcheck == false then --something's gone terribly, terribly wrong. (not really, it just means the recipe name doesn't match the item name....or there is no recipe for it.)
						for i, rec in pairs(data.raw.recipe) do
							if data.raw.recipe[rec].result == recipe then --or recipe.itemname (pseudo) 
								failcheck = true 
								if settings.startup["moresciencepack-ErrorOnFail"].value == true then 
									error("reset-recipe-unlock. ascertion failcheck1. name-mismatch: "..recipe.." recipe name is: "..rec) 
								else
									log("reset-recipe-unlock. ascertion failcheck1. name-mismatch: "..recipe.." recipe name is: "..rec)
								end
							end
						end 
						if failcheck == false then error("ascertion failed. item: "..recipe.." does not have a matching recipe.") end
					end
			end
		else 
			local failcheck = false
			for i, rec in pairs(data.raw.recipe) do
				if data.raw.recipe[rec].result == recipe then --or recipe.itemname (pseudo) 
					failcheck = true 
					if settings.startup["moresciencepack-ErrorOnFail"].value == true then 
						error("reset-recipe-unlock. ascertion failcheck2. name-mismatch: "..recipe.." recipe name is: "..rec) 
					else
						log("reset-recipe-unlock. ascertion failcheck2. name-mismatch: "..recipe.." recipe name is: "..rec)
					end					
				end
			end 
			if failcheck == false then 
				if settings.startup["moresciencepack-ErrorOnFail"].value == true then 
					error("ascertion failed2. item: "..recipe.." does not have a matching recipe.") 
				else
					log("ascertion failed2. item: "..recipe.." does not have a matching recipe.")
				end
			end
		end		
	else	
		if data.raw.technology[target] and data.raw.recipe[recipe] then
			--determine if correction is needed (see if the target technology already has the appropriate unlocks associated with it)
			local correctionNeeded = true
			if not data.raw.technology[target].effects then
			  data.raw.technology[target].effects = {}
			end
			for i, effect in pairs(data.raw.technology[target].effects) do
			  if effect.type == "unlock-recipe" and effect.recipe == recipe then correctionNeeded = false end
			end
		
			if correctionNeeded then 
				--remove stage (not strictly necessary. there'd just be potentially multiple technologies that unlocked a single recipe. no big deal really, but we'll go ahead and set things back)
				for tech in pairs(data.raw.technology) do
					morescience.tech.remove_recipe_unlock(tech, recipe)		
				end
				--re-add recipe unlock to target technology
				morescience.tech.add_recipe_unlock(target, recipe)
			end
		end
	end
end



function morescience.tech.cyclic_dependency_check(targetList, recipeList, effectTable, ingredientTable)

	--for each science pack 1-30
	--for each ingredient in each pack (and further down, for each ingredient to craft the ingredient)
		--at any point, can this ingredient NOT be crafted with the targetList research completed? or---does crafting any ingredient require an item unlocked AFTER this research has been completed 
		
	for technology in pairs(data.raw.technology) do --for each piece of research 
	
		for k, ingredient in pairs(data.raw.technology[targetList].unit.ingredients) do
			--for each ingredient of each pack used to complete the required science, run validate-recipe-chain .
		end
		--if any instance of validate-recipe-chain fails resolution stage, print an error to the log file recording the modification string 
	end

--[[

for each ingredient (and each ingredient necessary to gain higher-level item) in each science pack ingredient, check recipe chain/progression. validate that that can be reached before that research is completed. (cyclic dependency type A), if solution unsolved/invalidated or cannot be determined then generate&replace recipe with vanilla equivalent. 

check for science packs added by other mods to vanilla science that may require items that can't be gotten yet. (cyclic dependency type B)....if solution unsolved or invalid, remove science pack from technology cost. 

check for technology tree prerequisite alteration causing logical errors (cyclic dependency type C). Immediately resolve. remove prerequisite from offending tech. 

]]

end

--Checks if a table contains a specific element
function morescience.tech.is_in_table(element, tab)
	for i=1, #tab do
		if tab[i]==element then return true end
	end
	return false
end

function morescience.tech.replace_prerequisite(tech,old, new)
	for i,req in pairs(data.raw.technology[tech].prerequisites) do
		if req==old then
			data.raw.technology[tech].prerequisites[i]=new
		end
	end
end

function morescience.tech.remove_prerequisite(technology, prerequisite)
  if data.raw.technology[technology] and data.raw.technology[technology].prerequisites then	--nilcheck added 9/22/2018
	if type(data.raw.technology[technology].prerequisites) == 'table' then
		for i, check in ipairs(data.raw.technology[technology].prerequisites) do 
		  if check == prerequisite then
			table.remove(data.raw.technology[technology].prerequisites, i)
		  end
		end
	else 
		table.remove(data.raw.technology[technology].prerequisites, 1)
	end
  else
    log("Technology " .. technology .. " does not exist or requires no prerequisite.")
  end
end


function morescience.tech.remove_science_pack(tech,pack)
	if data.raw.technology[tech] then
		for i,ing in pairs(data.raw.technology[tech].unit.ingredients) do
			if ing[1]==pack then
				table.remove(data.raw.technology[tech].unit.ingredients,i)
			end
		end
	end
end



--Print all elements in a table
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

--Items in vanillaTable are copied from technology-vanilla.lua because they are handled separate from the integration function below, and there is no need to include these technologies (as they would either trigger errors, or be skipped). If changes are made to technology-vanilla.lua, the table below should be adjusted appropriately.
local VanillaTable = {"logistics", "optics", "stone-walls", "turrets", "automation", "electronics", "military", "military-2", "automation-2", "steel-processing", "circuit-network", "heavy-armor", 
	"research-speed-1", "electric-energy-distribution-1", "advanced-material-processing", "toolbelt", "landfill", "shotgun-shell-damage-1", "shotgun-shell-speed-1", "gun-turret-damage-1", 
	"bullet-damage-1", "bullet-speed-1", "fluid-handling", "oil-processing", "gates", "concrete", "engine", "shotgun-shell-damage-2", "shotgun-shell-speed-2", "gun-turret-damage-2", "bullet-damage-2", "bullet-speed-2",
	"flammables", "railway", "automated-rail-transportation", "rail-signals", "automobilism", "solar-energy", "laser", "research-speed-2", "electric-energy-accumulators-1", "electric-engine", "battery", "shotgun-shell-speed-3", "bullet-speed-3", "sulfur-processing", "plastics", "modules", "stack-inserter", "inserter-capacity-bonus-1", "inserter-capacity-bonus-2", "advanced-electronics", "fluid-wagon",
	"logistics-2", "modular-armor", "flying", "robotics", "construction-robotics", "shotgun-shell-damage-3", "night-vision-equipment", "battery-equipment", "solar-panel-equipment", "speed-module",
	"productivity-module", "effectivity-module", "cliff-explosives", "flamethrower", "electric-energy-distribution-2", "logistic-robotics", "character-logistic-slots-1", "character-logistic-slots-2", "character-logistic-trash-slots-1", "grenade-damage-1", "grenade-damage-2", "explosives", "land-mine", "rocketry", "laser-turrets", "shotgun-shell-damage-4", "shotgun-shell-speed-4", "gun-turret-damage-3",
	"gun-turret-damage-4", "flamethrower-damage-1", "energy-shield-equipment", "bullet-damage-3", "bullet-damage-4", "bullet-speed-4", "combat-robotics", "military-3", "grenade-damage-3", "tanks", "laser-turret-damage-1", 
	"laser-turret-speed-1", "flamethrower-damage-2", "combat-robot-damage-1", "rocket-damage-1", "rocket-speed-1", "laser-turret-damage-2", "laser-turret-speed-2", "combat-robot-damage-2", "rocket-damage-2", "rocket-speed-2", "inserter-capacity-bonus-3", "advanced-electronics-2", "braking-force-1", "power-armor", "research-speed-3", "advanced-material-processing-2", "worker-robots-speed-1", "worker-robots-storage-1", 
	"character-logistic-slots-3", "character-logistic-trash-slots-2", "battery-mk2-equipment", "exoskeleton-equipment", "personal-roboport-equipment", "advanced-oil-processing", "speed-module-2", "productivity-module-2", 
	"effectivity-module-2", "automation-3", "braking-force-2", "research-speed-4", "worker-robots-speed-2", "auto-character-logistic-trash-slots", "grenade-damage-4", "explosive-rocketry", "shotgun-shell-damage-5",
	"shotgun-shell-speed-5", "laser-turret-damage-3", "laser-turret-speed-3", "gun-turret-damage-5", "flamethrower-damage-3", "energy-shield-mk2-equipment", "personal-laser-defense-equipment", "discharge-defense-equipment",
	"bullet-damage-5", "bullet-speed-5", "combat-robotics-2", "combat-robot-damage-3", "rocket-damage-3", "rocket-speed-3", "cannon-shell-damage-1", "cannon-shell-speed-1", "inserter-capacity-bonus-4", "logistics-3", 
	"research-speed-5", "effect-transmission", "worker-robots-speed-3", "worker-robots-storage-2", "character-logistic-slots-4", "coal-liquefaction", "military-4", "grenade-damage-5", "grenade-damage-6", "shotgun-shell-damage-6", "shotgun-shell-speed-6", "laser-turret-damage-4", "laser-turret-damage-5", "laser-turret-damage-6", "laser-turret-damage-7", "laser-turret-speed-4", "laser-turret-speed-5", "laser-turret-speed-6", "laser-turret-speed-7", "gun-turret-damage-6", "flamethrower-damage-4", "flamethrower-damage-5", "flamethrower-damage-6", "bullet-damage-6", "bullet-speed-6", "combat-robot-damage-4", 
	"combat-robot-damage-5", "rocket-damage-4", "rocket-damage-5", "rocket-damage-6", "rocket-speed-4", "rocket-speed-5", "rocket-speed-6", "rocket-speed-7", "cannon-shell-damage-2", "cannon-shell-damage-3", "cannon-shell-damage-4", "cannon-shell-speed-2", "cannon-shell-speed-3", "cannon-shell-speed-4", "cannon-shell-speed-5", "inserter-capacity-bonus-5", "inserter-capacity-bonus-6", "inserter-capacity-bonus-7", 
	"braking-force-3", "braking-force-4", "braking-force-5", "braking-force-6", "braking-force-7", "research-speed-6", "logistic-system", "fusion-reactor-equipment", "worker-robots-speed-4", "worker-robots-speed-5", 
	"worker-robots-storage-3", "character-logistic-slots-5", "character-logistic-slots-6", "personal-roboport-equipment-2", "speed-module-3", "productivity-module-3", "effectivity-module-3", "atomic-bomb", "cannon-shell-damage-5", "uranium-ammo", "power-armor-2", "rocket-silo", "combat-robotics-3", "worker-robots-speed-6", "grenade-damage-7", "shotgun-shell-damage-7", "laser-turret-damage-8", "gun-turret-damage-7", 
	"flamethrower-damage-7", "bullet-damage-7", "combat-robot-damage-6", "rocket-damage-7", "cannon-shell-damage-6", "artillery-shell-range-1", "artillery-shell-speed-1"}


--add technologies here to prevent integration system from adding science packs to a specific modded technology. This table is populated with strings, and thus, should not require explicit use of optional-dependency tags within info.json. if the variable "technology" matches any entry in EITHER the VanillaTable or the BlackListTable, it will be skipped by the integration function---which is solely for adding packs to modded technologies based upon the science required by that technology's list of prerequisites. The formatting for the BlackListTable should be the same as the VanillaTable shown above. 

--include modded technology that needs to be prevented from being accessed in the integration function, such as those from bob's modules or any mods as needed.
local BlackListTable = {"productivity-module-4","productivity-module-5","productivity-module-6","productivity-module-7","productivity-module-8","effectivity-module-4","effectivity-module-5",
	"effectivity-module-6","effectivity-module-7","effectivity-module-8","speed-module-4","speed-module-5","speed-module-6","speed-module-7","speed-module-8","pollution-clean-module-1","pollution-clean-module-2","pollution-clean-module-3","pollution-clean-module-4","pollution-clean-module-5","pollution-clean-module-6","pollution-clean-module-7","pollution-clean-module-8","pollution-create-module-1","pollution-create-module-2","pollution-create-module-3","pollution-create-module-4","pollution-create-module-5","pollution-create-module-6","pollution-create-module-7","pollution-create-module-8","raw-speed-module-1","raw-speed-module-2","raw-speed-module-3","raw-speed-module-4","raw-speed-module-5","raw-speed-module-6","raw-speed-module-7","raw-speed-module-8",
	"green-module-1","green-module-2","green-module-3","green-module-4","green-module-5","green-module-6","green-module-7","green-module-8","raw-productivity-module-1","raw-productivity-module-2","raw-productivity-module-3","raw-productivity-module-4","raw-productivity-module-5","raw-productivity-module-6","raw-productivity-module-7","raw-productivity-module-8","module-merging","god-module-1","god-module-2","god-module-3","god-module-4","god-module-5"
	}

--print all recipes in game to log
function printRecipes()
	for i, rec in pairs(data.raw.recipe) do 
		log(rec.name)
	end
end

function locateItemRecipe(item)

	log("MSP: scanning data.raw.recipes for:"..item)
	local recipeName=""
	local foundIt=false
	
	if data.raw.recipe[item] then 
		foundIt=true
		recipeName=item 
	else
		for i, rec in pairs(data.raw.recipe) do 
			if data.raw.recipe[rec].result and data.raw.recipe[rec].result == item then 
				recipeName=rec
				foundIt=true
			elseif data.raw.recipe[rec].results then 
				for k, result in pairs(data.raw.recipe[rec].results) do 				
					if data.raw.recipe[rec].results[k] == item then 
						recipeName=rec
						foundIt=true
						break
					end
				end			
			elseif data.raw.recipe[rec].normal.results then 
				for k, result in pairs(data.raw.recipe[rec].normal.results) do 				
					if data.raw.recipe[rec].normal.results[k] == item then 
						recipeName=rec
						foundIt=true
						break
					end
				end		
			end
			if foundIt then break end
		end
	end
	
	if foundIt then log("located: "..item.."result in recipe: "..recipeName) end
	if not foundIt then 
		error("MSP ERROR: failed to locate:"..item.." in any recipe results.") 
	end
	return recipeName
	
end

function trim(s, trimFront, trimBack)
	s = string.sub(s, (trimFront+1), (-trimBack-1))
	return s
end 

mspIntegrateRanOnce = false

--integrate science packs into technology with a vanilla pre-requisite somewhere and attempt to prevent any cyclic-dependencies which might cause game completion to be impossible. This function has been tested in various configurations, and is also config dependent.  
function morescience.tech.integrate()
	log("MSP: -- Starting Mod Integration Engine! --")
	if mspIntegrateRanOnce == true then log("Second pass of integration engine: skipping print of all tech-tree logging because spam is unnecessary.") end
	--Idea: add ability to blacklist technologies from being edited altogether, or to individually remove specific science packs after-the-fact (do a check to make sure game-completion possible, if not, resolve solution)
		
	for technology in pairs(data.raw.technology) do
		
		if morescience.tech.is_in_table(technology, VanillaTable) or morescience.tech.is_in_table(technology, BlackListTable) then 
			--if technology either A) is part of the vanilla tech that has already been set up, or B) is added to the blacklist, we don't want to bother with it. 
			--Add bob's modules to blacklistTable, and any other modded tech that causes problems, or should be untouched by this inclusive-function. Add science packs to them separately "as needed". 
		else 
			local scienceArray = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}				
			if settings.startup["moresciencepack-debugLogging"].value == true and mspIntegrateRanOnce == false then log("Technology " .. technology .. " retrieved by MSP.") end
		
			if type(data.raw.technology[technology].prerequisites) == "table" then
				for _,req in pairs(data.raw.technology[technology].prerequisites) do
					--table.insert(data.raw.technology[tech].prerequisites,req)
					--if settings.startup["moresciencepack-debugLogging"].value == true then log("Technology " .. technology .. " prerequisite: " .. req .. " listed within table.") end
					
					if data.raw.technology[req] then --nilcheck 9/13/2018
						for i, ingredient in pairs(data.raw.technology[req].unit.ingredients) do --check which science packs are required for each of the prerequisite technologies in order to add them to the later-tier one.
							for nPack, pack in pairs(scienceArray) do --for each index of science array (totals 30) check if ingredient in req matches any
								if ingredient[1] == refPacks[tostring(nPack)] or ingredient.name == refPacks[tostring(nPack)] then scienceArray[nPack]="1" end 
							end	
						end		
						--omniLib pack efficiency level 2+ requires originating pack type 11/10/2018
						if req == "rocket-silo" then --add pack 30 to research that follows rocket-silo
							scienceArray[30]="1"
							if data.raw.technology[technology].name == "omnitech-more-science-pack-30-1" then scienceArray[30]="0" end --compensate specifically for pack 30's first Efficiency research in event that legacy recipes is disabled. (cyclic-dependency prevention)							
						end
						
					end
							--if settings.startup["moresciencepack-debugLogging"].value == true then log("debug: " .. technology .. " prerequisite: " .. req .. ". Array = " .. dump(scienceArray)) end						
				end
			elseif data.raw.technology[technology].prerequisites then --this SHOULD not trigger, but just in case...
				if settings.startup["moresciencepack-debugLogging"].value == true and mspIntegrateRanOnce == false then log("Technology " .. technology .. " prerequisite: " .. req .. " NOT listed as table.") end
				--place variation of above code here for: any technology that only has a single prerequisite (such that the type for "tech.prerequisite" is a string and not a table)--NOTICE!!!
					
			else
				if settings.startup["moresciencepack-debugLogging"].value == true and mspIntegrateRanOnce == false then log("There are no prerequisites listed under "..technology.. " for MSP integration") end
			end	
						
			if mods["omnilib"] and settings.startup["moresciencepack-Omni-Ignored"].value == false then
				--if dynamic recipes, add originating pack to all efficiency researches level 2 or higher (if level != 1). 
				local s = data.raw.technology[technology].name
				if omni.lib.start_with(s,"omnitech-more-science-pack") and not omni.lib.end_with(s,"-1") then	
					local trimFront=27
					local v = trim(s,trimFront,0)					
					local trimBack= string.len(v)- string.find(trim(s,trimFront,0),"-")					
					local packN=trim(s, trimFront, trimBack+1)
					scienceArray[tonumber(packN)]="1"
				end			
			end
			
			morescience.tech.add_science_pack_array(technology, scienceArray, 1) --add science packs via array to individual technology.				
		end
		
	end	
	mspIntegrateRanOnce = true
end

--try a second version of integration function that uses Blue, Purple, Yellow, White science as TIERS: anything that requires that science pack ALSO requires all the science packs required to unlock that vanilla science type. (BLUE: msp1-10, Purple & Yellow: 1-12+17, )


function morescience.tech.module_limitation(recipe)
  if data.raw.recipe[recipe] then
    for i, module in pairs(data.raw.module) do
      if module.limitation and module.effect.productivity then
        table.insert(module.limitation, recipe)
      end
    end
  else
    log("Recipe " .. recipe .. " does not exist.")
  end
end


