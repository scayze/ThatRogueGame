extends Entity

onready var anim = get_node("AnimationPlayer")
var can_move = false

var stage_1 = preload("res://Characters/Enemies/slime_1.png")
var stage_2 = preload("res://Characters/Enemies/slime_2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")

func on_init():
	if main.current_level > 3: texture = stage_2

func on_death():
	main.remove_entity(self)
	main.add_score(25)

func on_health_empty():
	queue_free()

func on_attack(e):
	if e.type == Type.PLAYER:
		e.deal_damage(2)

func on_turn():
	if can_move == false:
		can_move = true
		return
	
	var path = astar.get_point_path(id,player.id)
	var all_possible = astar.get_point_connections(id)
	
	var r = rand_range(0,all_possible.size())
	var target = all_possible[r]
	var target_position = id_to_pos(target)
	main.move_entity(self,target_position-pos)
	can_move = false
