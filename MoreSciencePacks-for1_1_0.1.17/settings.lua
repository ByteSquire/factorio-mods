  
-- wormmus settings-function example. 
require("settings-values")

local ord={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}

local function msp_newModSetting_startup_string(name, order, default, allowedvalues)
    data:extend({
        {
            name = name,
            order = order,
            type = "string-setting",
            setting_type = "startup",
			per_user = false,  
            default_value = default,
            allowed_values = allowedvalues
        }
    })
end

local function msp_newModSetting_startup_boolean(name, order, default)
    data:extend({
        {
            name = name,
            order = order,
            type = "bool-setting",			
            setting_type = "startup",
			per_user = false,  
            default_value = default
        }
    })
end

local function msp_newModSetting_startup_int(name, order, default, minimum, maximum)
    data:extend({
        {
            name = name,
            order = order,
            type = "int-setting",
            setting_type = "startup",
			per_user = false,  
            default_value = default,
            minimum_value = minimum,
			maximum_value = maximum
        }
    })
end

msp_newModSetting_startup_boolean("moresciencepack-Omni-Ignored", "a1", false)
msp_newModSetting_startup_boolean("moresciencepack-Dynamic-stacksize", "a2", true)

msp_newModSetting_startup_string("moresciencepack-difficulty", "a-d", "Standard", difficulty)

msp_newModSetting_startup_boolean("moresciencepack-IntegrationEngine", "a-a", true)
msp_newModSetting_startup_int("moresciencepack-TechTreeScanningPermutations", "a-a2", 2, 1, 5)

msp_newModSetting_startup_int("moresciencepack-levels-MSP", "a-b", 10, 1, 20)
msp_newModSetting_startup_int("moresciencepack-omni-maximum", "a-c", 400, 200, 1000)

--msp_newModSetting_startup_boolean("moresciencepack-legacyMode", "a-a-a", false) --option removed 1.12
msp_newModSetting_startup_boolean("moresciencepack-EconomicsIntegration", "a-a-b", false)
msp_newModSetting_startup_boolean("moresciencepack-reset-ingredient-recipe-unlocks", "a-a-c", false)
msp_newModSetting_startup_boolean("moresciencepack-unlock-all-packs", "a-a-d", false)
msp_newModSetting_startup_boolean("moresciencepack-GameProgressionFix", "a-a-e", false)
msp_newModSetting_startup_boolean("moresciencepack-no-lab-slots", "a-a-f", false)
msp_newModSetting_startup_boolean("moresciencepack-removeVanillaPacks", "a-a-g", false)

msp_newModSetting_startup_boolean("moresciencepack-debugLogging", "a-b-d", false)
msp_newModSetting_startup_boolean("moresciencepack-ErrorOnFail", "a-b-e", false)

msp_newModSetting_startup_int("moresciencepack-multiplier", "a-b-m", 1, 1, 100)

msp_newModSetting_startup_boolean("moresciencepack-IncreasedModuleScienceCost", "z-a-a", false)

msp_newModSetting_startup_int("moresciencepack-ModuleScienceDifficulty", "z-a-b", 2, 1, 16)



--int setting: default, minimum, maximum 


-----------------1,2,3, 4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
refPackDefaults={5,8,12,7,6,8,5,4,10,10,8,32,28,20,20,20,15,60,19,50,25,32,27,12,14,13,30,16,80,35}
--Order of packs showing up in mod-settings window should now be in correct order. 
for i=1, 15 do

msp_newModSetting_startup_int("MSP-pack".. i .. "-result", "d-a-"..ord[i], refPackDefaults[i], 0, 500)

end
for i=16, 30 do

msp_newModSetting_startup_int("MSP-pack".. i .. "-result", "d-b-"..ord[i-15], refPackDefaults[i], 0, 500)

end


