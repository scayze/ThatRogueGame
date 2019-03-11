extends Entity

var energy = 0
export var max_energy = 100
var poems_collected = 0
var weapon = null
var inv1 = null
var inv2 = null
var inv3 = null
var invs = []

var timer_inactivity = 0.0

onready var anim = get_node("AnimationPlayer")
onready var label_energy = get_node("Energy")

var scene_sword = preload("res://Scenes/Drops/CopperSword.tscn")

var texture_copper = preload("res://Characters/Main Character/character_cooper.png")
var texture_iron = preload("res://Characters/Main Character/character_iron.png")
var texture_master = preload("res://Characters/Main Character/character_gold.png")

export(String, FILE) var sound_step = ""

func recover_energy(a):
	if a < 0 && main.goal.active: return
	energy += a
	energy = clamp(energy,0,max_energy)

func equip_weapon(d):
	if weapon:
		weapon.queue_free()
	weapon = d
	main.ui.set_weapon(weapon)
	if weapon.type == "copper_sword": texture = texture_copper
	if weapon.type == "iron_sword": texture = texture_iron
	if weapon.type == "master_sword": texture = texture_master

func _process(delta):
	label_energy.text = str(energy)
	if main.game_paused: return
	timer_inactivity += delta
	if timer_inactivity >= 1.0:
		timer_inactivity = 0
		main.add_score(-10)
		#energy -= 1
		#energy = clamp(energy,0,max_energy)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	invs.append(inv1)
	invs.append(inv2)
	invs.append(inv3)
	
	sound_step = load(sound_step)

func on_init():
	inv1 = null
	inv2 = null
	inv3 = null
	main.ui.set_item(null,0)
	main.ui.set_item(null,1)
	main.ui.set_item(null,2)
	weapon = null
	healthbar.visible = true
	visible = true
	energy = max_energy
	var s = scene_sword.instance()
	equip_weapon(s)

func on_turn():
	stunned -= 1
	if stunned < 0: stunned = 0

func on_attack(e):
	if energy > 8:
		recover_energy(-8)
		e.deal_damage(weapon.damage)
	else: recover_energy(7)

func on_damage(d):
	#recover_energy(-8)
	#get_node("Sprite").visible = true
	#get_node("Sprite").frame = 0
	#get_node("Sprite").play("New Anim")
	#self_modulate = Color(1,1,1,0)
	$Camera2D.shake(2)
	pass

func on_death():
	main.game_finished()
	visible = false

func move(vec):
	if stunned == 0:
		if energy == 0: 
			rest()
			return
		recover_energy(-2)
		main.move_entity(self,vec)
		#main.play_sound(sound_step,10)
		timer_inactivity = 0
	main.enemy_turn()
	pass

func consume(i):
	if !invs[i]: return
	
	timer_inactivity = 0
	
	invs[i].effect()
	main.ui.update_item(i)
	if invs[i].count <= 0:
		invs[i].queue_free()
		if invs[i].consume_takes_turn: main.enemy_turn()
		invs[i] = null
		main.ui.set_item(null,i)

func collect():
	
	var d : Drop = main.drops[pos.x][pos.y]
	if !d: return
	
	timer_inactivity = 0
	
	if d.is_weapon:
		equip_weapon(d)
		d.pick_up()
		main.drops[pos.x][pos.y] = null
	else:
		if d.is_stackable:
			for i in range(invs.size()):
				if invs[i]==null: continue
				if d.type == invs[i].type:
					invs[i].count += 1
					main.ui.update_item(i)
					d.queue_free()
					main.drops[pos.x][pos.y] = null
					return
		for i in range(invs.size()):
			if invs[i]==null:
				invs[i] = d
				d.pick_up()
				main.drops[pos.x][pos.y] = null
				main.ui.set_item(d,i)
				return
	main.enemy_turn()

func rest():
	recover_energy(5)
	timer_inactivity = 0
	main.enemy_turn()

func _input(event):
	#Block player input when game is paused
	if main.game_paused: return
	
	if event.is_action_pressed("Left"):
		flip_h = true;
		get_node("Sprite").flip_h = true
		move(Vector2(-1,0))
	elif event.is_action_pressed("Rest"):
		rest()
	elif event.is_action_pressed("Right"):
		flip_h = false;
		get_node("Sprite").flip_h = false
		move(Vector2(1,0))
	elif event.is_action_pressed("Up"):
		move(Vector2(0,-1))
	elif event.is_action_pressed("Down"):
		move(Vector2(0,1))
	elif event.is_action_pressed("Collect"):
		collect()
	elif event.is_action_pressed("Consume1"):
		consume(0)
	elif event.is_action_pressed("Consume2"):
		consume(1)
	elif event.is_action_pressed("Consume3"):
		consume(2)
	elif event is InputEventKey:
		if event.scancode == KEY_Y:
			$Camera2D.zoom = Vector2(0.7,0.7)
		elif event.scancode == KEY_X:
			$Camera2D.zoom = Vector2(0.3,0.3)
		elif event.scancode == KEY_Z:
			main.start_game()



func _on_Sprite_animation_finished(): pass
	#self_modulate = Color(1,1,1,1)
	#get_node("Sprite").visible = false
