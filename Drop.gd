extends Sprite
class_name Drop

var pos = Vector2()
var main
var player : Entity

export var is_weapon = false
export var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(m,e):
	main = m
	player = e
	global_position = pos * 16 + Vector2(8,8)

func effect():
	if has_method("consume"):
		call("consume")
		#Remove or sth
