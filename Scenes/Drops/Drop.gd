extends Sprite
class_name Drop

var pos = Vector2()
var main
var player : Entity

export var is_weapon = false
export var damage = 1
export var is_stackable = true
export var consume_takes_turn = true
var count = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(m,e):
	main = m
	player = e
	global_position = pos * 16 + Vector2(8,8)

func pick_up():
	get_parent().remove_child(self)

func effect():
	if has_method("consume"):
		call("consume")
		count -= 1
