extends Entity

var weapon
var inv1
var inv2
var inv3

onready var anim = get_node("AnimationPlayer")

func _enter_tree():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")

func on_init():
	healthbar.visible = true

func on_attack(e):
	e.deal_damage(1)

func on_damage(d):
	pass

func move(vec):
	main.move_entity(self,vec)
	main.enemy_turn()
	pass

func _input(event):
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
	elif event is InputEventKey:
		if event.scancode == KEY_Q:
			$Camera2D.zoom = Vector2(1,1)
		elif event.scancode == KEY_E:
			$Camera2D.zoom = Vector2(0.35,0.35)
		elif event.scancode == KEY_R:
			main.start_game()

