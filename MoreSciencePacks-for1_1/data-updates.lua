if not morescience then morescience = {} end
if not morescience.tech then morescience.tech = {} end


--require("prototypes.recipe.recipe-updates") --removed in 0.0.26 in favor of "recipe-corrections, which will run in data.lua to enable correction of recipes prior to dynamic recipe formation but after initial recipes are set"
--require("prototypes.recipe.recipe-integrations") --currently only used for AllAboutMoney integration. --moved to data.lua
require("prototypes.technology.technology-updates")
require("prototypes.technology.technology-modded")

	--Set up science pack crafting-results based on config setting. Defaults will be used if the pack is disabled from technology. (prevents a recipe result = 0) While maintaining ability to disable a pack from being required for research.
	--set result count for recipe to configured value if input > 0. 0 will take the default/initial value. 
	for i=1,30 do
		if settings.startup["MSP-pack".. i .. "-result"].value > 0 then --if pack is "disabled" we use the standard recipe. no changes needed.
			if mods["omnilib"] then 			
				data.raw["recipe"]["more-science-pack-"..i].result_count = settings.startup["MSP-pack"..i.."-result"].value --with omniLib active, we disregard multiplier as technologies will be made to increase yield.
			else
				data.raw["recipe"]["more-science-pack-"..i].result_count = settings.startup["MSP-pack"..i.."-result"].value * settings.startup["moresciencepack-multiplier"].value	
			end
		end
	end 


	--MSP 1 recipe quantity fix for base vs. efficiency 1. 
	local index={}
	for k,v in pairs(difficulty) do
	   index[v]=k
	end
	difficulty_index = index[settings.startup["moresciencepack-difficulty"].value]	
	if difficulty_index > 7 then difficulty_index = 7 end --hardest difficulies give 2.
	if difficulty_index < 3 then difficulty_index = 2 end --easist difficulties give 7. 
	data.raw.recipe["more-science-pack-1"].result_count =  9 - difficulty_index




	--ADD MSP science packs 1-30 to ALL LABS declared within data.raw.lab
	--[[	We can go ahead and blacklist specific labs we don't want to add our science packs to such as creative-mode mod, which has it's own search&Add function or bob's module-lab for right now. 	
			This method will add all 30 science packs to EVERY lab that is not inthe blacklistLabs. This means, if a mod adds a lab type and a science pack type to that lab, and our integration function 
			edits technology that that mod adds: this method will ensure that the modded-lab receives our science packs as allowed-packs. 
	]]
	local blacklistLabs ={"creative-mode-fix_creative-lab", "lab-module"}

	

	if (mods["MomoTweak"] or mods["MomosTweak"]) and mods["angelspetrochem"] and settings.startup["moresciencepack-no-lab-slots"].value == true and settings.startup["moresciencepack-GameProgressionFix"].value == true then
	--if all above = true, skip addition of packs to science labs.
			--[[ IF all the above ascertions are true, prevent addition of msp packs as lab tools. packs will act as intermediates only in this configuration. 
			This feature added for players who don't want the logistic hassle of inserting 37 science packs into labs, but are okay with very complex science crafting recipes. 
			toggling game progression fix 
			--]]
	else 
		for labX, labs in pairs(data.raw.lab) do
			if not morescience.tech.is_in_table(tostring(data.raw.lab[labX].name), blacklistLabs) then --enable blacklisting
				if settings.startup["moresciencepack-debugLogging"].value == true then log("debug Lab: " .. tostring(data.raw.lab[labX].name) .. " is not blacklisted. Adding MSP packs now...") end 
				--if a pack we add hasn't already been added to a lab by some other means or by another mod, such as creative-mode-mod, we'll go ahead and add the pack now.
				for i=1,30 do
					if data.raw.lab[labX].inputs ~= nil then -- Check if lab has inputs
						if not morescience.tech.is_in_table("more-science-pack-" .. i, data.raw.lab[labX].inputs) then 
							table.insert(data.raw.lab[labX].inputs, "more-science-pack-" .. i)				
							--ADD valid inputs rather then explicitly redefine inputs. this should prevent issues with labs having other custom-science packs removed due to explicit declaration.
						end 			
					end
				end
			else 
				if settings.startup["moresciencepack-debugLogging"].value == true then log("debug Lab: " .. tostring(data.raw.lab[labX].name) .. " exists in blacklist table. Skipping MSP-packs.") end 		
			end
		end
	end

	--morescience.printFuels() --test
--end

