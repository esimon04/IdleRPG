extends Resource
class_name EnemyDrop


var item: Item
var dropRate : float
var count : int

func _init(i: Item, rate : float, _count:int):
	item = i
	dropRate = rate
	count = _count
