extends Drop

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func consume():
	player.recover_energy(25)
