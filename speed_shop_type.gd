extends ShopType
class_name SpeedShopType

@export var speed_bonus: float

func apply():
	GameManager.travel_speed_bonus += speed_bonus
