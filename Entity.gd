extends Sprite
class_name Entity

var id = 0
var pos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func id_to_pos(i):
	return Vector2(fmod(i,get_parent().map_width), floor(i / get_parent().map_width))

func update():
	pos = id_to_pos(id)
	position = pos * 16 + Vector2(8,8)
	print(id)
	print(pos)
	pass
