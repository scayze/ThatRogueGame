extends Entity

onready var anim = get_node("AnimationPlayer")
var relax = true

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")

func on_death():
	main.remove_entity(self)
	main.add_score(500)

func on_health_empty():
	queue_free()

func on_attack(e):
	if e.type == Type.PLAYER:
		e.deal_damage(4 + 0.5 * main.current_level)

func on_turn():
	var all_possible = astar.get_point_connections(id)
	
	var r = rand_range(0,all_possible.size())
	var found = false
	for p in all_possible:
		if player.id == p:
			found = true
			if relax:
				relax = false
				return
			on_attack(player)
	if found == false: relax = false

