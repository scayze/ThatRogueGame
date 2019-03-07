extends Sprite

enum Type {
	OBJECT
	PLAYER
	ENEMY
	GOAL
	GOAL_FADED
}

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = -1

func set_type(t):
	if t == Type.PLAYER: region_rect = Rect2(0,0,16,16)
	elif t == Type.ENEMY: region_rect = Rect2(16,0,16,16)
	elif t == Type.GOAL: region_rect = Rect2(32,0,16,16)
	elif t == Type.GOAL_FADED: region_rect = Rect2(48,0,16,16)
	else: visible = false