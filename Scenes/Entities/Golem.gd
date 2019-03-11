extends Entity

onready var anim = get_node("AnimationPlayer")
var can_move = false

var stage_1 = preload("res://Characters/Enemies/golem_1.png")
var stage_2 = preload("res://Characters/Enemies/golem_2.png")
var stage_3 = preload("res://Characters/Enemies/golem_3.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")

func on_init():
	if main.current_level > 4: texture = stage_2
	if main.current_level > 6: texture = stage_3
	pass

func on_death():
	main.remove_entity(self)
	main.add_score(100)

func on_health_empty():
	queue_free()

func on_attack(e):
	if e.type == Type.PLAYER:
		e.deal_damage(4)
		e.stun(1)

func on_turn():
	var path = astar.get_point_path(id,player.id)
	if path.size() < 7:
		if can_move == false:
			can_move = true
			return
		
		if path.size() > 1:
			main.move_entity(self,Vector2(path[1].x,path[1].y)-pos)
	can_move = false

