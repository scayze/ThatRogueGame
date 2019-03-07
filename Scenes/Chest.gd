extends Entity

onready var anim = get_node("AnimationPlayer")
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func on_damage(d):
	if !is_open:
		is_open = true
		anim.play("Attack")
		#Todo: drop_items
		is_attackable=false

func _on_animation_finished(anim_name):
	anim.play("Idle")
