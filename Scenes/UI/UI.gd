extends Control

enum state {
	GAME
	GAME_DEATH
	MENU
	HIGHSCORES
	CREDITS
}

onready var state_game_death = get_node("Game/DeathMenu")
onready var state_game = get_node("Game")
onready var state_menu = get_node("MainMenu")
onready var state_highscores = get_node("Highscores")
onready var state_credits = get_node("Credits")

onready var label_score = get_node("Game/Score")
onready var fade_over = get_node("Game/FadeOver")
onready var poem_screen = get_node("Game/PoemScreen")

onready var inv1 = get_node("Game/HSplitContainer/InvSpot")
onready var inv2 = get_node("Game/HSplitContainer/InvSpot2")
onready var inv3 = get_node("Game/HSplitContainer/InvSpot3")
onready var inv4 = get_node("Game/HSplitContainer/InvSpot4")
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

func init(p):
	player = p
	inv1.init(main,p,-1)
	inv2.init(main,p,0)
	inv3.init(main,p,1)
	inv4.init(main,p,2)

func set_state(s):
	if s == state.GAME_DEATH:
		state_game_death.visible = true
		state_game.visible = true
		state_menu.visible = false
		state_highscores.visible = false
		state_credits.visible = false
	elif s == state.GAME:
		state_game_death.visible = false
		state_game.visible = true
		state_menu.visible = false
		state_highscores.visible = false
		state_credits.visible = false
	elif s == state.MENU:
		state_game_death.visible = false
		state_game.visible = false
		state_menu.visible = true
		state_highscores.visible = false
		state_credits.visible = false
	elif s == state.HIGHSCORES:
		state_game_death.visible = false
		state_game.visible = false
		state_menu.visible = false
		state_highscores.visible = true
		state_credits.visible = false
	elif s == state.CREDITS:
		state_game_death.visible = false
		state_game.visible = false
		state_menu.visible = false
		state_highscores.visible = false
		state_credits.visible = true

func set_weapon(w):
	inv1.set_item(w)

func set_item(i,s):
	spots[s].set_item(i)

func update_item(s):
	spots[s].update()

func update_score(s):
	label_score.text = str(s)

func show_poems(c):
	fade_over.visible = true
	poem_screen.init(c)
	main.game_paused = true

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
	
	if main.game_paused: return
#	if event.is_action_pressed("bar_left"):
#		selected_inv -= 1
#		selected_inv = clamp(selected_inv, 0, 2)
#		spots[selected_inv].grab_focus()
#	if event.is_action_pressed("bar_right"):
#		selected_inv += 1
#		selected_inv = clamp(selected_inv, 0, 2)
#		spots[selected_inv].grab_focus()

func _on_Play_pressed():
	set_state(state.GAME)
	main.start_game()


func _on_Highscores_pressed():
	set_state(state.HIGHSCORES)


func _on_Credits_pressed():
	set_state(state.CREDITS)

func _on_Exit_pressed():
	get_tree().quit()


func _on_Back_pressed():
	set_state(state.MENU)
