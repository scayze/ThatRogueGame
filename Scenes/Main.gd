extends Node

var scene_player = preload("res://Scenes/Entities/Player.tscn")
var audio_player = preload("res://Scenes/AudioStreamPlayer.tscn")
onready var player= null
onready var tilemap = get_node("TileMap")
onready var flora = get_node("Flora")
onready var worldgen = get_node("WorldGen")

var map_width = 48#96
var map_height = 26#128

var score = 0

onready var astar : AStar
var map = []
var terrain = []
var entities = []
var drops = []
var goal = null

var current_level = 0

var game_paused = false

onready var ui = get_node("Viewport/UI")

func _ready():
	ui.main = self
	ui.set_state(ui.state.MENU)
	astar = AStar.new()
	for x in range(0,map_width):
		drops.append([])
		drops[x].resize(map_height)
	pass

func play_sound(a,v = 0):
	var audio = audio_player.instance()
	add_child(audio)
	audio.stream = a
	audio.volume_db += v
	audio.play()

func start_game():
	if player: player.queue_free()
	player = scene_player.instance()
	add_child(player)
	#spawn_entity(player)
	player.init(astar,player,self)
	ui.init(player)
	score = 0
	current_level = 0
	ui.update_score(score)
	ui.label_expl.visible = true
	next_stage()

func add_score(p):
	score += p
	if score < 0: score = 0
	ui.update_score(score)

func game_finished():
	game_paused = true
	ui.set_state(ui.state.GAME_DEATH)
	HighScores.save_score(score)

func finished_stage():
	current_level += 1
	ui.label_expl.visible = false
	next_stage()

func next_stage():
	player.recover_energy(1337)
	init_map()

func clear_everything():
	astar.clear()
	#Clear all entity references from last stage
	entities.clear()
	#Unpause game in case it was
	game_paused = false
	#Clear map, terrain, drops etc
	map.clear()
	tilemap.clear()
	flora.clear()
	#Recreate the map array
	for x in range(0,map_width):
		map.append([])
		map[x].resize(map_height)
	#Recreate the drop array
	for x in range(0,map_width):
		for y in range(0,map_height):
			if drops[x][y]:
				drops[x][y].queue_free()
				drops[x][y] = null

func init_map():
	#Clear the astar navigation
	clear_everything()
	
	worldgen.generate_level(current_level)
	
	var random_position = Vector3(rand_range(10,map_width-10),rand_range(10,map_height-10),0)
	print(random_position)
	player.id = astar.get_closest_point(random_position)
	player.update()
	map[player.pos.x][player.pos.y] = player

func spawn_drop(drop,pos):
	if drops[pos.x][pos.y]:
		print("Trying to spawn an drop on an existing one")
		drop.queue_free()
		return
	drop.pos = pos
	drops[pos.x][pos.y] = drop
	drop.init(self,player)

func spawn_entity(entity, pos):
	if map[pos.x][pos.y]:
		print("Trying to spawn an entity on an existing one")
		entity.queue_free()
		return
	entity.id = pos_to_id(pos.x,pos.y)
	map[pos.x][pos.y] = entity
	entities.append(entity)
	if entity.is_blocking:
		astar.set_point_weight_scale(entity.id,100)
	entity.init(astar,player,self)
	entity.update()

func move_entity(entity, dir):
	if entity.is_blocking: 
		print("Trying to move a nav-blocking entity, please dont do dis")
		return
	var new_id = entity.id+dir.x + dir.y*map_width
	var new_pos = id_to_pos(new_id)
	if astar.are_points_connected(entity.id,new_id):
		if map[new_pos.x][new_pos.y] == null:
			if entity == player: play_sound(player.sound_step)
			var pos = id_to_pos(entity.id)
			map[pos.x][pos.y] = null
			map[pos.x + dir.x][pos.y + dir.y] = entity
			entity.id = new_id
		else:
			entity.attack(map[new_pos.x][new_pos.y])
	elif entity == player: player.recover_energy(7)
	entity.update()

func remove_entity(entity):
	var idx = entities.find(entity)
	if idx == -1: 
		print("Trying to remove non existing entity")
		return
	if entity.is_blocking:
		astar.set_point_weight_scale(entity.id,1)
	entities.remove(idx)
	
	var enemies_dead = true
	for e in entities:
		if e.type == Entity.Type.ENEMY:
			enemies_dead = false
			break
	if enemies_dead:
		goal.set_active(true)
		player.recover_energy(1337)
	
	map[entity.pos.x][entity.pos.y] = null


func enemy_turn():
	for e in entities:
		e.take_turn()
	player.take_turn()

func id_to_pos(i):
	return Vector2(fmod(i,map_width), floor(i / map_width))
	
func pos_to_id(x,y):
	return x+y*map_width

func get_closest_point(pos):
	var p = [pos]