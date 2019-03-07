extends Node

onready var player = get_node("Player")
onready var tilemap = get_node("TileMap")
onready var flora = get_node("Flora")
onready var worldgen = get_node("WorldGen")

const map_width = 48
const map_height = 26

onready var astar
var map = []
var entities = []
var drops = []

var game_paused = false

onready var ui = get_node("Viewport/UI")


func _ready():
	start_game()
	pass


func id_to_pos(i):
	return Vector2(fmod(i,map_width), floor(i / map_width))
	
func pos_to_id(x,y):
	return x+y*map_width

#WHAT THE FUCK DID I DO AND WHY DOES IT WORK
func init_map():
	astar = AStar.new()
	entities.clear()
	map.clear()
	ui.init(self,player)
	game_paused = false
	for x in range(0,map_width):
		map.append([])
		map[x].resize(map_height)
	
	tilemap.clear()
	flora.clear()
	drops.clear()
	for x in range(0,map_width):
		drops.append([])
		drops[x].resize(map_height)
	worldgen.reset()
	ui.reset()
	
#	worldgen.add_island(Vector2(6,3),15,0.1)
#	worldgen.add_island(Vector2(3,5),15,0.1)
#	worldgen.add_island(Vector2(4,5),15,0.1)
#	worldgen.add_island(Vector2(4,3),15,0.1)
#	worldgen.add_island(Vector2(4,4),15,0.1)
	worldgen.add_island(Vector2(3,3),15,0.1)
	worldgen.add_island(Vector2(3,3),15,0.1)
	worldgen.add_island(Vector2(3,3),15,0.1)
	worldgen.add_island(Vector2(3,3),15,0.1)
	worldgen.add_island(Vector2(3,3),15,0.1)
	worldgen.gen_navigation(astar)
	worldgen.debug_print()
	
	worldgen.gather_available()
	worldgen.place_chests()
	worldgen.plant_trees()
	worldgen.beautify()
	worldgen.spawn_fucks()
	
	worldgen.clean()
	
	
	
	var random_position = Vector3(rand_range(10,map_width-10),rand_range(10,map_height-10),0)
	print(random_position)
	player.id = astar.get_closest_point(random_position)
	player.init(astar,player,self)
	player.update()

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
		astar.set_point_weight_scale(entity.id,100)#disconnect_nav(entity.id)
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
			var pos = id_to_pos(entity.id)
			map[pos.x][pos.y] = null
			map[pos.x + dir.x][pos.y + dir.y] = entity
			entity.id = new_id
		else:
			entity.attack(map[new_pos.x][new_pos.y])
	entity.update()

func remove_entity(entity):
	var idx = entities.find(entity)
	if idx == -1: 
		print("Trying to remove non existing entity")
		return
	if entity.is_blocking:
		astar.set_point_weight_scale(entity.id,1)#reconnect_nav(entity.id)
	entities.remove(idx)
	map[entity.pos.x][entity.pos.y] = null

func start_game():
	init_map()

func enemy_turn():
	for e in entities:
		e.take_turn()

func disconnect_nav(id):
	var cons = astar.get_point_connections(id)
	print(cons.size())
	for c in cons:
		astar.disconnect_points(id,c)

func reconnect_nav(id):
	if astar.has_point(id-1): astar.connect_points(id,id-1)
	if astar.has_point(id+1): astar.connect_points(id,id+1)
	if astar.has_point(id-map_width): astar.connect_points(id,id-map_width)
	if astar.has_point(id+map_width): astar.connect_points(id,id+map_width)

func get_closest_point(id):
	pass # todo Implement