extends ShopType
class_name SlowTimeShopType

@export var new_ratio: float

func apply():
	GameManager.slow_ratio = new_ratio
