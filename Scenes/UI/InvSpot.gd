extends TextureButton

var normal_texture = preload("res://HUD/InventorySpot.png")
var selected_texture = preload("res://HUD/SelectedInventorySpot.png")
onready var picture = get_node("TextureRect")
onready var label_count = get_node("TextureRect/Count")
var item = null

var main
var player
var id

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(m,p,idx):
	main = m
	player = p
	id=idx

func set_selected(b):
	if b: texture_normal = selected_texture
	else: texture_normal = normal_texture

func update():
	if item == null:
		picture.texture = null
		label_count.visible = false
		return
	else: picture.texture = item.texture
	if item.is_stackable:
		label_count.visible = true
		label_count.text = str(item.count)
	else: label_count.visible = false

func set_item(i):
	item = i
	update()

func _on_pressed():
	player.consume(id)
