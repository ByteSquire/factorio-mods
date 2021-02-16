require("functions")
require("settings-values")--difficulty = {"Easiest", "Very Easy", "Easy", "Standard", "Hard", "Harder", "Very Hard", "Hardest"}


if mods["omnilib"] and settings.startup["moresciencepack-Omni-Ignored"].value == false then 

	--pack name dictionary
	local refPacks = {["1"] = "more-science-pack-1", ["2"] = "more-science-pack-2", ["3"] = "more-science-pack-3", ["4"] = "more-science-pack-4", ["5"] = "more-science-pack-5", ["6"] = "more-science-pack-6",
			["7"] = "more-science-pack-7", ["8"] = "more-science-pack-8", ["9"] = "more-science-pack-9", ["10"] = "more-science-pack-10", ["11"] = "more-science-pack-11", ["12"] = "more-science-pack-12",
			["13"] = "more-science-pack-13", ["14"] = "more-science-pack-14", ["15"] = "more-science-pack-15", ["16"] = "more-science-pack-16", ["17"] = "more-science-pack-17", ["18"] = "more-science-pack-18",
			["19"] = "more-science-pack-19", ["20"] = "more-science-pack-20", ["21"] = "more-science-pack-21", ["22"] = "more-science-pack-22", ["23"] = "more-science-pack-23", ["24"] = "more-science-pack-24",
			["25"] = "more-science-pack-25", ["26"] = "more-science-pack-26", ["27"] = "more-science-pack-27", ["28"] = "more-science-pack-28", ["29"] = "more-science-pack-29", ["30"] = "more-science-pack-30"}

			
	--technology prerequisite dictionary
	local refTechPreq = {["1"] = nil, ["2"] = nil, ["3"] = nil, ["4"] = nil, ["5"] = nil, ["6"] = nil,
			["7"] = nil, ["8"] = nil, ["9"] = nil, ["10"] = nil, ["11"] = nil, ["12"] = nil,
			["13"] = nil, ["14"] = nil, ["15"] = nil, ["16"] = nil, ["17"] = nil, ["18"] = nil,
			["19"] = nil, ["20"] = nil, ["21"] = nil, ["22"] = nil, ["23"] = nil, ["24"] = nil,
			["25"] = nil, ["26"] = nil, ["27"] = nil, ["28"] = nil, ["29"] = nil, ["30"] = nil}
			

			
	--Correct prerequsite listings (Angel's petrochem, etc....)
	if mods["angelspetrochem"] then --["angelsrefining"]
		refTechPreq[tostring(10)] = "angels-sulfur-processing-1"
		refTechPreq[tostring(8)] = "angels-oil-processing"
	end
	
	

	local index={}
	for k,v in pairs(difficulty) do
	   index[v]=k
	end
	difficulty_index = index[settings.startup["moresciencepack-difficulty"].value]
	log("difficulty "..difficulty_index.." is "..settings.startup["moresciencepack-difficulty"].value)

	local diffCostMultiplier = 1 -- 4=standard / because fourth index
	local hardval = 1 --only matters if setting to one of the hard values.


	for i=1,30 do 
		if settings.startup["MSP-pack".. i .. "-result"].value > 0 then --if pack is enabled, generate recipe		
			local item = refPacks[tostring(i)]			
			local recipeName = nil
			local generateItem = true 
			
			if data.raw.recipe[item] then 
				recipeName = item 
			else 
				--probably omnipermute. use the first recipe: (item.."-omniperm-1-1")
				if data.raw.recipe[item.."-omniperm-1-1"] then 
					recipeName = item.."-omniperm-1-1" 
					log("MSP:OmniPermute Recipe edit detected...")
				else
					log("MSP:OmniPermute Not detected...Scanning data.raw for recipes")
					recipeName = locateItemRecipe(item) 					
				end
			
				--if STILL broken, print recipes to log skip (item may be a modded item. so we'll skip it if we can't locate it.)
				if recipeName == nil then 
					printRecipes()
					log("MSP:Error: recipe with result: "..item.." could not be found. List of recipe names have been printed to log. Skipping recipe generation for item.") 
					generateItem = false
				end
			end 
		
			--handle improper technology prerequisite / or missing tech
			local reqTechnology = refTechPreq[tostring(i)]	
			if data.raw.technology[reqTechnology] then 		
				--technology exists, continue....
			else
				--if it isn't nil (has had a tech declared) but the tech doesn't exist, then skip
				log("MSP: prerequisite tech is: "..tostring(reqTechnology).." for item: "..item..". / set to nil")
				reqTechnology = nil 
			end
		
			if generateItem==true then 
				ingredients = omni.lib.standardise(data.raw.recipe[recipeName]).normal.ingredients
			
				local maxval = math.floor( settings.startup["MSP-pack"..i.."-result"].value * (morescience.levels+1))
				if maxval > morescience.omni_maximum then maxval = morescience.omni_maximum end --use constant.lua	default is 400. configurable range: 200-1000. 
				--since it is possible to set a pack_Result to a number greater than a potential maximum, let's resolve:
				if maxval < math.floor( settings.startup["MSP-pack"..i.."-result"].value * 2) then maxval = settings.startup["MSP-pack"..i.."-result"].value *  math.floor(morescience.levels/2) end
				--line above checks if maxval is less than 2x amount of standard-yield for the pack being processed...if it is, then it sets the maxval to that result*math.floor(levels/2)
				--this *should* give enough room for various configurations of yields and settings without getting crazy results. 
				
				local startval = settings.startup["MSP-pack"..i.."-result"].value * 2
				
				--change maxval, startval, offset, etc here to compensate for different difficulty levels.
				--if not difficulty == "Standard" then 
					
					--change the cost for researching efficiency based on difficulty level
					diffCostMultiplier = difficulty_index
					if difficulty_index > 4 then --harder
						--diffCostMultiplier = diffCostMultiplier * 1.1
						hardval = math.floor( math.pow(1.0121,1-(1/diffCostMultiplier+1)) )
					else
						if difficulty_index < 4 then --easier
							diffCostMultiplier = 1 - (1 / (diffCostMultiplier+1))
						end
					end
					if difficulty_index == 4 then 
						diffCostMultiplier = 2			
					end
				
					--set cost based on difficulty. changes pack yield/efficiency result and maximum yield based on difficulty chosen. greatly reduces yield for hardest level. 
					if difficulty_index > 4 then --harder 
						maxval = settings.startup["MSP-pack"..i.."-result"].value * (10-(difficulty_index-1))				--assume value is 27. 27 * (12-[range4-7]) = 216,189,162,135
						startval = (10-difficulty_index)
						if i == 1 then startval = 5 end -- compensate for recipe.lua unlocking ore science at start of game. if difficulty is 8, then startval for most packs is 2. but if a recipe exists already to craft MSP1 with a yield of 5 per, we don't want to generate "efficiency" techs for those that start below 5.
						
						local YieldIncrease = math.floor(maxval/morescience.levels)
						if YieldIncrease < 2 then  YieldIncrease = 10 - difficulty_index end --new 3/16/2019
						
						maxval = (YieldIncrease * (morescience.levels-1))+startval 
						
						cost = OmniGen:create():
								setYield(item):
								setIngredients(ingredients): 
								setWaste():	
								wasteQuant():
								linearOutput(maxval, startval)				
					else 
						cost = OmniGen:create():
								setYield(item):
								setIngredients(ingredients): 
								setWaste():	
								wasteQuant():
								linearOutput(maxval, startval)
					end
						
						RecChain:create("MoreSciencePacks-for1_1",item):
						setLocName("recipe-name.more-science-pack",{"item-name."..item}, function(levels,grade) return grade end):
						setTechLocName("more-science-pack",{"item-name."..item}):	
						--setTechLocDesc("more-science-pack",{"item-name."..item}, function(levels,grade) return grade end):	
						--setTechLocDesc("more-science-pack",{"item-name."..item}):	
						setTechLocDesc("more-science-pack"):
						setBothColour(1,0,0.5):
						setTechName(item):
						setTechCost(function(levels,grade) return (9+(i+hardval))*grade*diffCostMultiplier end): --ifSetTechCost does not exist. 
						setTechPacks(function(levels,grade) return math.floor(grade*4/morescience.levels)+1 end):
						--setTechPacks(function(levels,grade) return math.floor(grade/morescience.levels*2)+1 end):									
						setTechIcons(item):	--setTechIcon("__MoreSciencePacks-for1_1__/graphics/technology/"..item..".png"):
						setTechPrereq(function(levels,grade)
							local req = {}
							if grade == 1 then
							   req = refTechPreq[tostring(i)] --example:{"angels-nitrogen-processing-1","omnitech-basic-omni-processing-1","omnismelter-1"} --note: pack 8 and 10 may require further servicing if angels mods are installed. more info in data.lua
							end
							return req
						end):
						setCategory(data.raw.recipe[recipeName].category): --should copy the category of the template recipe. 
						setIngredients(cost:ingredients()):				
						setResults(cost:results()):
						setSubgroup("science-pack"):
						setLevel(morescience.levels):
						setEnergy(5):extend()
			else --generateItem==false
				log("MSP_Recipe Name mismatch. Either incorrect omnipermute handling which may require optional dependecny pointed at MSP as well as refactoring code or the universe is dying.")
				
			end
		end 
		
	end

end --end require omniLib.
