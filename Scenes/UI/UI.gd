extends Control

onready var fade_over = get_node("FadeOver")
onready var poem_screen = get_node("PoemScreen")

onready var inv1 = get_node("HSplitContainer/InvSpot")
onready var inv2 = get_node("HSplitContainer/InvSpot2")
onready var inv3 = get_node("HSplitContainer/InvSpot3")
onready var inv4 = get_node("HSplitContainer/InvSpot4")
var spots = []

var poems = []

var selected_inv = 0

var main
var player 

# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize poems bbcode
	poems.append("first")
	poems.append("second")
	poems.append("third")
	#
	inv1.set_selected(true)
	inv1.texture_hover = null
	spots.append(inv2)
	spots.append(inv3)
	spots.append(inv4)

func init(m,p):
	main = m
	player = p
	inv1.init(m,p,-1)
	inv2.init(m,p,0)
	inv3.init(m,p,1)
	inv4.init(m,p,2)

func set_weapon(w):
	inv1.set_item(w)

func update_item(s):
	spots[s].update()

func reset():
	for i in spots:
		i.clear()

func show_poems(c):
	fade_over.visible = true
	poem_screen.init(c)
	main.game_paused = true

func set_item(i,s):
	print(s)
	spots[s].set_item(i)

func _input(event):
	if event.is_action_pressed("ui_select") && poem_screen.active:
		poem_screen.dismiss()
		fade_over.visible = false
		main.game_paused = false
	elif event.is_action_pressed("ui_select"):
		print("SELECT BY KEYBOARD")
		for i in spots:
			if i.has_focus():
				i._on_pressed()
				break
	
	if event.is_action_pressed("bar_left"):
		selected_inv -= 1
		selected_inv = clamp(selected_inv, 0, 2)
		spots[selected_inv].grab_focus()
	if event.is_action_pressed("bar_right"):
		selected_inv += 1
		selected_inv = clamp(selected_inv, 0, 2)
		spots[selected_inv].grab_focus()