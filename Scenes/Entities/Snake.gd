extends Entity

onready var anim = get_node("AnimationPlayer")
var can_move = false

var stage_1 = preload("res://Characters/Enemies/snake_1.png")
var stage_2 = preload("res://Characters/Enemies/snake_2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")

func on_death():
	main.remove_entity(self)
	main.add_score(50)

func on_init():
	if main.current_level > 3: texture = stage_2
	pass

func on_health_empty():
	queue_free()

func on_attack(e):
	if e.type == Type.PLAYER:
		e.deal_damage(4)

func on_turn():
	if can_move == false:
		can_move = true
		return
	
	var dir 
	var path = astar.get_point_path(id,player.id)
	
	if path.size() > 9: return
	if path.size() > 1:
		var path1 = Vector2(path[1].x,path[1].y)
		dir =  path1 - pos
		main.move_entity(self,Vector2(path[1].x,path[1].y)-pos)
	if path.size() > 3 && dir == Vector2(path[2].x,path[2].y) - pos:
		var path2 = Vector2(path[2].x,path[2].y)
		main.move_entity(self,path2 - pos)
	
	can_move = false
