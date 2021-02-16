
local discoScienceInit = function()

	if remote.interfaces["DiscoScience"] and remote.interfaces["DiscoScience"]["setIngredientColor"] then
			
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-1", {r = 214, g = 87, b = 39})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-2", {r = 217, g = 149, b = 8})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-3", {r = 205, g = 174, b = 20})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-4", {r = 193, g = 190, b = 9})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-5", {r = 136, g = 194, b = 44})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-6", {r = 154, g = 116, b = 137})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-7", {r = 131, g = 91, b = 160})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-8", {r = 255, g = 89, b = 160})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-9", {r = 255, g = 209, b = 2})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-10", {r = 68, g = 26, b = 255})
		
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-11", {r = 121, g = 167, b = 255})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-12", {r = 113, g = 82, b = 240})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-13", {r = 134, g = 133, b = 255})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-14", {r = 142, g = 140, b = 139})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-15", {r = 59, g = 59, b = 59})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-16", {r = 169, g = 13, b = 184})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-17", {r = 245, g = 47, b = 182})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-18", {r = 109, g = 129, b = 166})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-19", {r = 72, g = 171, b = 147})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-20", {r = 72, g = 116, b = 193})

		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-21", {r = 0, g = 8, b = 81})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-22", {r = 168, g = 144, b = 111})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-23", {r = 41, g = 211, b = 255})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-24", {r = 77, g = 47, b = 5})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-25", {r = 178, g = 178, b = 178})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-26", {r = 243, g = 8, b = 8})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-27", {r = 248, g = 215, b = 61})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-28", {r = 158, g = 248, b = 34})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-29", {r = 30, g = 195, b = 248})
		remote.call("DiscoScience", "setIngredientColor", "more-science-pack-30", {r = 0, g = 0, b = 0})			
		
	end

end


script.on_init(
    function ()
        discoScienceInit()
    end
)

script.on_configuration_changed(    
    function ()
        discoScienceInit()
    end
)
