extends Control

onready var inv1 = get_node("HSplitContainer/InvSpot")
onready var inv2 = get_node("HSplitContainer/InvSpot2")
onready var inv3 = get_node("HSplitContainer/InvSpot3")
onready var inv4 = get_node("HSplitContainer/InvSpot4")
var spots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	inv1.set_selected(true)
	spots.append(inv1)
	spots.append(inv2)
	spots.append(inv3)
	spots.append(inv4)

func set_weapon(w):
	inv1.set_item(w)