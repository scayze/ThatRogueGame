extends Entity

onready var anim = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	pass # Replace with function body.

func on_damage(d):
	anim.play("Attack")


func _on_animation_finished(anim_name):
	anim.play("Idle")
