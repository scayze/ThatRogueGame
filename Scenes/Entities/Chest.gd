extends Entity

onready var anim = get_node("AnimationPlayer")
var is_open = false

var scene_poem = preload("res://Scenes/Drops/Poem.tscn")
var scene_copper_sword = preload("res://Scenes/Drops/CopperSword.tscn")
var scene_iron_sword = preload("res://Scenes/Drops/IronSword.tscn")
var scene_master_sword = preload("res://Scenes/Drops/MasterSword.tscn")

var drop_pool = []
var spawn_poem = false

func on_damage(d):
	if !is_open:
		is_open = true
		anim.play("Attack")
		is_attackable=false
		open()

func open():
	drop_pool.append(scene_cherry)
	drop_pool.append(scene_apple)
	drop_pool.append(scene_red_potion)
	drop_pool.append(scene_blue_potion)
	if (player.weapon.type == "copper_sword" && main.current_level >= 3):
		drop_pool.append(scene_iron_sword)
	if (player.weapon.type == "iron_sword" && main.current_level >= 3):
		drop_pool.append(scene_master_sword)
	
	var r = rand_range(0,drop_pool.size())
	var drop
	if spawn_poem: drop = scene_poem.instance()
	else: drop = drop_pool[r].instance()
	add_child(drop)
	main.spawn_drop(drop,pos + Vector2(0,1))

func _on_animation_finished(anim_name):
	anim.play("Idle")
