extends Object
class_name DamageTypes
enum DamageType {PHYSICAL, FIRE, NATURE, LIGHTNING, HOLY, DARK}

static func type_to_string(damage_type: DamageType) -> String:
	var type_names = {
		DamageType.PHYSICAL: "Physical",
		DamageType.FIRE: "Fire",
		DamageType.NATURE: "Nature",
		DamageType.LIGHTNING: "Lightning",
		DamageType.HOLY: "Holy",
		DamageType.DARK: "Dark"
	}
	return type_names.get(damage_type, "Unknown")
