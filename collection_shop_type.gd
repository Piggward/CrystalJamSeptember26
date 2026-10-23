extends ShopType
class_name CollectorShopType

@export var increase_ratio: float

func apply():
	GameManager.collector_area_bonus += increase_ratio
