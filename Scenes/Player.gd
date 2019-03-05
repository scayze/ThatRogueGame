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
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move(vec):
	get_parent().move_entity(self,vec)
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
