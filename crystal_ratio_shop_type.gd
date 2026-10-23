extends ShopType
class_name CrystalRatioShopType

@export var ratio: float

func apply():
	GameManager.crystal_spawn_bonus += ratio
