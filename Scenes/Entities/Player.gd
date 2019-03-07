extends Entity

var energy = 0
export var max_energy = 20
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

func recover_energy(a):
	energy += a
	energy = clamp(energy,0,max_energy)

func equip_weapon(d):
	if weapon:
		main.spawn_drop(weapon,pos)
		print("LOL")
		main.worldgen.add_child(weapon)
	weapon = d
	main.ui.set_weapon(weapon)

func _process(delta):
	if main.game_paused: return
	timer_inactivity += delta
	if timer_inactivity >= 1.0:
		timer_inactivity = 0
		energy -= 1
	
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	invs.append(inv1)
	invs.append(inv2)
	invs.append(inv3)

func on_init():
	healthbar.visible = true
	energy = max_energy
	var s = scene_sword.instance()
	equip_weapon(s)

func on_attack(e):
	e.deal_damage(weapon.damage)

func on_damage(d):
	pass

func on_death():
	main.remove_entity(self)

func move(vec):
	main.move_entity(self,vec)
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
		pass
	else:
		if d.is_stackable:
			var drop_type = d.get_script().get_path()
			for i in range(invs.size()):
				if invs[i]==null: continue
				if drop_type == invs[i].get_script().get_path():
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

func _input(event):
	#Block player input when game is paused
	if main.game_paused: return
	
	if event.is_action_pressed("Left"):
		flip_h = true;
		move(Vector2(-1,0))
	elif event.is_action_pressed("Right"):
		flip_h = false;
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
		elif event.scancode == KEY_R:
			main.start_game()

