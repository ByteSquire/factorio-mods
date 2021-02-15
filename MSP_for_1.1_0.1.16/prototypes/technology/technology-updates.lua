
--function morescience.tech.reset_recipe_unlock(target, recipe)
--function morescience.tech.remove_prerequisite(technology, prerequisite)

--MoreScience fixes
morescience.tech.remove_prerequisite("stone-walls", "military") --Fix moreScience mod locking walls behind military research 
morescience.tech.remove_prerequisite("turrets", "military") --Fix moreScience, AAI mod requiring military science for turret tech. --duplicate. also done in technology-modded.lua
data.raw["recipe"]["light-armor"].enabled = true --fix moreScience mod removing armor from starting recipes


if data.raw.technology["effect-transmission-2"] then 
	morescience.tech.add_science_pack_range({"effect-transmission-2"}, 22, 23, 1)
end