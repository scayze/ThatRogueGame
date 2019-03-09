extends Sprite

var player
var main
var pos

var active = false
var reached = false

# Called when the node enters the scene tree for the first time.
func set_active(b):
	active = b
	if b: region_rect.position = Vector2(32,0)
	else: region_rect.position = Vector2(48,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active && pos == player.pos && reached == false:
		reached = true
		main.finished_stage()
