extends Entity

onready var anim = get_node("AnimationPlayer")
var can_move = false
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")

func on_death():
	main.remove_entity(self)

func on_health_empty():
	queue_free()

func on_attack(e):
	if e.type == Type.PLAYER:
		e.deal_damage(4)

func on_turn():
	if can_move == false:
		can_move = true
		return
	
	var path = astar.get_point_path(id,player.id)
	if path.size() > 1:
		main.move_entity(self,Vector2(path[1].x,path[1].y)-pos)
	can_move = false
