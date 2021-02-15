
local ord={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}

local refOrder = {["1"] = "more-science-pack-01", ["2"] = "more-science-pack-02", ["3"] = "more-science-pack-03", ["4"] = "more-science-pack-04", ["5"] = "more-science-pack-05", ["6"] = "more-science-pack-06",
		["7"] = "more-science-pack-07", ["8"] = "more-science-pack-08", ["09"] = "more-science-pack-09", ["10"] = "more-science-pack-10", ["11"] = "more-science-pack-11", ["12"] = "more-science-pack-12",
		["13"] = "more-science-pack-13", ["14"] = "more-science-pack-14", ["15"] = "more-science-pack-15", ["16"] = "more-science-pack-16", ["17"] = "more-science-pack-17", ["18"] = "more-science-pack-18",
		["19"] = "more-science-pack-19", ["20"] = "more-science-pack-20", ["21"] = "more-science-pack-21", ["22"] = "more-science-pack-22", ["23"] = "more-science-pack-23", ["24"] = "more-science-pack-24",
		["25"] = "more-science-pack-25", ["26"] = "more-science-pack-26", ["27"] = "more-science-pack-27", ["28"] = "more-science-pack-28", ["29"] = "more-science-pack-29", ["30"] = "more-science-pack-30"}

local refPacks = {["1"] = "more-science-pack-1", ["2"] = "more-science-pack-2", ["3"] = "more-science-pack-3", ["4"] = "more-science-pack-4", ["5"] = "more-science-pack-5", ["6"] = "more-science-pack-6",
		["7"] = "more-science-pack-7", ["8"] = "more-science-pack-8", ["9"] = "more-science-pack-9", ["10"] = "more-science-pack-10", ["11"] = "more-science-pack-11", ["12"] = "more-science-pack-12",
		["13"] = "more-science-pack-13", ["14"] = "more-science-pack-14", ["15"] = "more-science-pack-15", ["16"] = "more-science-pack-16", ["17"] = "more-science-pack-17", ["18"] = "more-science-pack-18",
		["19"] = "more-science-pack-19", ["20"] = "more-science-pack-20", ["21"] = "more-science-pack-21", ["22"] = "more-science-pack-22", ["23"] = "more-science-pack-23", ["24"] = "more-science-pack-24",
		["25"] = "more-science-pack-25", ["26"] = "more-science-pack-26", ["27"] = "more-science-pack-27", ["28"] = "more-science-pack-28", ["29"] = "more-science-pack-29", ["30"] = "more-science-pack-30"}

local refBaseResult = {["1"] = data.raw["recipe"]["more-science-pack-1"].result_count, ["2"] = data.raw["recipe"]["more-science-pack-2"].result_count, ["3"] = data.raw["recipe"]["more-science-pack-3"].result_count, 
		["4"] = data.raw["recipe"]["more-science-pack-4"].result_count, ["5"] = data.raw["recipe"]["more-science-pack-5"].result_count, ["6"] = data.raw["recipe"]["more-science-pack-6"].result_count,
		["7"] = data.raw["recipe"]["more-science-pack-7"].result_count, ["8"] = data.raw["recipe"]["more-science-pack-8"].result_count, ["9"] = data.raw["recipe"]["more-science-pack-9"].result_count, 
		["10"] = data.raw["recipe"]["more-science-pack-10"].result_count, ["11"] = data.raw["recipe"]["more-science-pack-11"].result_count, ["12"] = data.raw["recipe"]["more-science-pack-12"].result_count,
		["13"] = data.raw["recipe"]["more-science-pack-13"].result_count, ["14"] = data.raw["recipe"]["more-science-pack-14"].result_count, ["15"] = data.raw["recipe"]["more-science-pack-15"].result_count, 
		["16"] = data.raw["recipe"]["more-science-pack-16"].result_count, ["17"] = data.raw["recipe"]["more-science-pack-17"].result_count, ["18"] = data.raw["recipe"]["more-science-pack-18"].result_count,
		["19"] = data.raw["recipe"]["more-science-pack-19"].result_count, ["20"] = data.raw["recipe"]["more-science-pack-20"].result_count, ["21"] = data.raw["recipe"]["more-science-pack-21"].result_count, 
		["22"] = data.raw["recipe"]["more-science-pack-22"].result_count, ["23"] = data.raw["recipe"]["more-science-pack-23"].result_count, ["24"] = data.raw["recipe"]["more-science-pack-24"].result_count,
		["25"] = data.raw["recipe"]["more-science-pack-25"].result_count, ["26"] = data.raw["recipe"]["more-science-pack-26"].result_count, ["27"] = data.raw["recipe"]["more-science-pack-27"].result_count, 
		["28"] = data.raw["recipe"]["more-science-pack-28"].result_count, ["29"] = data.raw["recipe"]["more-science-pack-29"].result_count, ["30"] = data.raw["recipe"]["more-science-pack-30"].result_count}

local baseCost = "200"
		
local resultCostMultiplier = "37"

if mods["AllAboutMoney"]	then
	
	if settings.startup["moresciencepack-EconomicsIntegration"].value == true then

		--new subgroup for spending coins for science packs. PACKS CANNOT BE SOLD!!!!!, i'll maybe change this later to a config option to sell something like space science packs. who knows.... this is the first edition of the economics-route method. 
		data:extend(
		{
			{
			type = "item-subgroup",
			name = "spent8",
			group = "money-buy",
			order = "h"
			}
		})	
	
		for i=1,30 do		
			if settings.startup["MSP-pack".. i .. "-result"].value > 0 then --pack has not been disabled by user, allow purchase using coins.
				data:extend(
				{
					{
					type = "recipe",
					name = "buy-MSPpack"..i,
					icon = "__MoreSciencePacks__/graphics/icons/more-science-pack-"..i..".png",
					icon_size = 32,
					order = refOrder[tostring(i)], 
					enabled = true,
					subgroup = "spent8",
					energy_required = 1,
					ingredients ={{"coin", resultCostMultiplier * refBaseResult[tostring(i)] + baseCost},
					},result = "more-science-pack-"..i,result_count = math.floor(refBaseResult[tostring(i)])},
				})
			end
		end
	end
	
end


--omni.lib.replace_recipe_ingredient(recipe, ingredient,replacement)
--omni.lib.add_recipe_ingredient(recipe, ingredient)
--morescience.recipe.add_ingredient(recipe, ingredient)


if mods["omnilib"] then --and mods["angelspetrochem"] then 

	--pack26. Advanced Chemistry
	if data.raw.fluid["gas-epichlorhydrin"] then
		omni.lib.replace_recipe_ingredient("more-science-pack-26", "heavy-oil", "gas-epichlorhydrin")
	end
	if mods["omnimatter_crystal"] and data.raw.fluid["hydromnic-acid"] then 
		omni.lib.replace_recipe_ingredient("more-science-pack-26", "sulfuric-acid", "hydromnic-acid")	
	end

	--pack27. Advanced Weapony 
	if data.raw.ammo["ap-bullet-magazine"] then omni.lib.add_recipe_ingredient("more-science-pack-27", "ap-bullet-magazine")  end
	if data.raw.item["rocket-turret-mk2"] then omni.lib.add_recipe_ingredient("more-science-pack-27", "rocket-turret-mk2")	end

end

if mods["bobwarfare"] then
	--bobmods.lib.recipe.replace_ingredient(recipe, old, new)
	--if data.raw.ammo["bob-rocket"] then bobmods.lib.recipe.replace_ingredient("science-pack-27", "explosive-rocket", "bob-rocket") end

end

