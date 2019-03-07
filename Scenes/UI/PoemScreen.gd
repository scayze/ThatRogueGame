extends ColorRect

var active = false
var poems = []
var current_poem = -1
var max_poems = -1

onready var site_number = get_node("Site")
onready var page = get_node("Text")

# Called when the node enters the scene tree for the first time.
func _ready():
	poems.append("lorem \n ipsum \n this is a longer sentende \n \n and here was a newline")
	poems.append("second\n poem")
	poems.append("another one")
	pass # Replace with function body.

func init(count):
	current_poem = count
	max_poems = count
	visible = true
	active = true
	change_site()

func dismiss():
	active = false
	visible = false

func change_site():
	site_number.text = str(current_poem) + "/" + str(max_poems)
	page.text = poems[current_poem-1]

func _input(event):
	if active == false: return
	if event.is_action_pressed("bar_left"):
		current_poem -= 1
		current_poem = clamp(current_poem, 1, max_poems)
		change_site()
	if event.is_action_pressed("bar_right"):
		current_poem += 1
		current_poem = clamp(current_poem, 1, max_poems)
		change_site()
