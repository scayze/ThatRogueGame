extends Entity

onready var anim = get_node("AnimationPlayer")
var is_open = false

var scene_cherry = preload("res://Scenes/Cherry.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func on_damage(d):
	if !is_open:
		is_open = true
		anim.play("Attack")
		is_attackable=false
		open()

func open():
	var c = scene_cherry.instance()
	add_child(c)
	main.spawn_drop(c,pos + Vector2(0,1))

func _on_animation_finished(anim_name):
	anim.play("Idle")
