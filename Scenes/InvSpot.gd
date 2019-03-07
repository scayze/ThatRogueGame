extends TextureButton

var normal_texture = preload("res://HUD/InventorySpot.png")
var selected_texture = preload("res://HUD/SelectedInventorySpot.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_selected(b):
	if b: texture_normal = selected_texture
	else: texture_normal = normal_texture
