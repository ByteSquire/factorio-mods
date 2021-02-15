require("settings-values")

--space chests set space science as a requirement for some logistic chests (current exception being the passive provider, at my suggestion, thus, we'll set up conversion recipes for the science packs until a better method/recipe idea is given for this particular case.)
if mods["Space-Chests"]	then
	data:extend(
	{
	  {
		type = "recipe",
		name = "more-science-pack-24",
		energy_required = 5, enabled = false,
		ingredients =
		{
		  {"logistic-chest-passive-provider", 3},
		},
		result = "more-science-pack-24"
		,result_count = 9,
	  },
	}
	)
end


--Fix bob's inserter overhaul conflict --new notice: similar behaviour may also be required in dealing with changes AAI makes. 
if mods["boblogistics"] and settings.startup["bobmods-logistics-inserteroverhaul"].value == true then
	--if bob's logistics is installed, bob's library must be, therefore, we can use the existing function to replace the ingredient, and ensure the science pack can be crafted if the inserter-overhaul option is enabled. We may also need to check to see if some other mod has moved the fast inserter out of the basic logistics tech, and / or simply change the basic recipe to use the basic inserter regardless.. more testing needed.
	bobmods.lib.recipe.replace_ingredient("more-science-pack-4", "fast-inserter", "inserter")
	bobmods.lib.recipe.replace_ingredient("more-science-pack-20", "stack-inserter", "red-stack-inserter")
end



if mods["omnilib"] then 	
	--Fix omni renaming offshore-pump-source
	if data.raw.item["offshore-pump-source"] then
		data:extend(
		{
		  {
			type = "recipe",
			name = "more-science-pack-5",
			energy_required = 5, enabled = false,
			ingredients =
			{
			  {"offshore-pump-source", 1},
			  {"boiler", 1}
			},
			result = "more-science-pack-5"
			,result_count = 7,
		  },
		}
		)	
	end 	

end

--MSP 18, module science ingredient adjustment 
if settings.startup["moresciencepack-IncreasedModuleScienceCost"].value == true then	
	local tier = settings.startup["moresciencepack-ModuleScienceDifficulty"].value
	
	if mods["bobmodules"] then 	-- and data.raw.item[]
		--basic tier productivity and 
		if tier == 1 then 
			--tier reduction = increase quantity of modules as ingredients x3
			data:extend(
				{
					{
					type = "recipe",
					name = "more-science-pack-18",
					energy_required = 5, enabled = false,
					ingredients =
					{
					  {"speed-module", 6},
					  {"productivity-module", 6}
					},
					result = "more-science-pack-18"
					,result_count = 60,
				},
				})
		
		end
		if tier > 2 then 	
			if tier < 9 then 
				data:extend(
				{
					{
					type = "recipe",
					name = "more-science-pack-18",
					energy_required = 5, enabled = false,
					ingredients =
					{
					  {"speed-module-"..tostring(tier), 1},
					  {"productivity-module-"..tostring(tier), 1}
					},
					result = "more-science-pack-18"
					,result_count = 60,
				},
				})
			end
			
			if tier > 8 then 
				tier = tier - 8  --reallign integer/tier for bob's raw-modules
			
				if settings.startup["bobmods-modules-enablerawspeedmodules"].value == true and settings.startup["bobmods-modules-enablerawproductivitymodules"].value == true and 
				data.raw.item["raw-speed-module-"..tier] and data.raw.item["raw-productivity-module-"..tier] then 
					data:extend(
					{
					  {
						type = "recipe",
						name = "more-science-pack-18",
						energy_required = 5, enabled = false,
						ingredients =
						{
						  {"raw-speed-module-"..tier, 1},
						  {"raw-productivity-module-"..tier, 1}
						},
						result = "more-science-pack-18"
						,result_count = 60,
					  },
					})	
				else -- raw modules have not been enabled. incraese cost internally
					data:extend(
						{
						  {
							type = "recipe",
							name = "more-science-pack-18",
							energy_required = 5, enabled = false,
							ingredients =
							{
							  {"speed-module-"..tier, tier+2},
							  {"productivity-module-"..tier, tier+2}
							},
							result = "more-science-pack-18"
							,result_count = 60,
						  },
						})				
				end
			end
		end	
	else --if not mods["bobmodules"] and settings.startup["moresciencepack-IncreasedModuleScienceCost"].value == true then
		data:extend(
		{
		  {
			type = "recipe",
			name = "more-science-pack-18",
			energy_required = 5, enabled = false,
			ingredients =
			{
			  {"speed-module-2", tier+2},
			  {"productivity-module-2", tier+2}
			},
			result = "more-science-pack-18"
			,result_count = 60,
		  },
		})	
	end
end

