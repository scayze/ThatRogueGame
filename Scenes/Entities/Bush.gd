extends Entity

onready var anim = get_node("AnimationPlayer")

export var drop_chance = 0.4
var scene_cherry = preload("res://Scenes/Drops/Cherry.tscn")

func _ready():
	anim.play("Idle")

func on_death():
	var r = rand_range(0,1)
	if r <= drop_chance:
		var drop = scene_cherry.instance()
		get_parent().add_child(drop)
		main.spawn_drop(drop,pos)
	
	main.remove_entity(self)
	queue_free()

func on_damage(d):
	anim.play("Attack")

func _on_animation_finished(anim_name):
	anim.play("Idle")
