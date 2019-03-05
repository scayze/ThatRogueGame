extends Node

onready var player = get_node("Player")
onready var tilemap = get_node("TileMap")
onready var water_border = get_node("WaterBorder")
var scene_test = preload("res://Scenes/Test.tscn")

const map_width = 64
const map_height = 32

var noise_texture

var astar
var map = []

func _ready():
	for x in range(0,map_width):
		map.append([])
		map[x].resize(map_height)
	
	start_game()
	pass

func id_to_pos(i):
	return Vector2(fmod(i,map_width), floor(i / map_width))
	
func pos_to_id(x,y):
	return x+y*map_width
#WHAT THE FUCK DID I DO AND WHY DOES IT WORK
func init_map():
	tilemap.clear()
	water_border.clear()
	
	randomize()
	noise_texture = NoiseTexture.new()
	noise_texture.width = map_width
	noise_texture.height = map_height
	noise_texture.flags = 0
	noise_texture.noise = OpenSimplexNoise.new()
	noise_texture.noise.seed = rand_range(0,1337)
	noise_texture.noise.octaves = 6
	noise_texture.noise.period = 10
	noise_texture.noise.persistence = 0
	noise_texture.noise.lacunarity = 0.1

	var noise_texture2 = NoiseTexture.new()
	noise_texture2.width = map_width / 4
	noise_texture2.height = map_height / 4
	noise_texture2.flags = 0
	noise_texture2.noise = OpenSimplexNoise.new()
	noise_texture2.noise.seed = rand_range(0,1337)
	noise_texture2.noise.octaves = 3
	noise_texture2.noise.period = 3
	noise_texture2.noise.persistence = 0
	noise_texture2.noise.lacunarity = 0.1
	
	
	get_node("Test").texture = noise_texture
	get_node("Test2").texture = noise_texture2
	yield(get_tree(), "idle_frame")
	var data = noise_texture.get_data()
	var data2 = noise_texture2.get_data()
	data.lock()
	data2.lock()
	
	astar = AStar.new()
	for y in range(0,map_height):
		for x in range(0,map_width):
			var accum = data.get_pixel(x,y).r + data2.get_pixel(x/4,y/4).r / 1.5
			#print(data2.get_pixel(x/4,y/4).r)
			if accum < 0.8:
				#print(data.get_pixel(x,y).r,data.get_pixel(x,y).g,data.get_pixel(x,y).b)
				var id = x+y*map_width
				astar.add_point(id,Vector3(x,y,0))
				
				
				if y > 0 and astar.has_point(id-map_width): astar.connect_points(id,id-map_width)
				if x > 0 and astar.has_point(id-1): astar.connect_points(id,id-1)
				
	for id in range(0,32*64):
		if(astar.has_point(id)):
			#var ok = false
			tilemap.set_cell(id_to_pos(id).x,id_to_pos(id).y,0)
			tilemap.set_cell(id_to_pos(id+map_width).x,id_to_pos(id+map_width).y,0)
			tilemap.set_cell(id_to_pos(id-1).x,id_to_pos(id-1).y,0)
			tilemap.set_cell(id_to_pos(id-1+map_width).x,id_to_pos(id+1+map_width).y,0)
			
			var i = scene_test.instance()
			add_child(i)
			i.position = id_to_pos(id)*16+Vector2(8,8)
			#if astar.has_point(id-1) && astar.has_point(id-1-map_width) && astar.has_point(id-map_width): ok = true
			#if astar.has_point(id-1) && astar.has_point(id-1+map_width) && astar.has_point(id+map_width): ok = true
			#if astar.has_point(id+1) && astar.has_point(id+1-map_width) && astar.has_point(id-map_width): ok = true
			#if astar.has_point(id+1) && astar.has_point(id+1+map_width) && astar.has_point(id+map_width): ok = true
			
			#if ok==false: astar.remove_point(id)
			#else: tilemap.set_cell(id % map_width,floor(id/map_width),0)
	tilemap.update_bitmask_region(Vector2(0,0),Vector2(map_width,map_height))
	
#	var deletion = []
#	for id in range(0,32*64):
#		if(astar.has_point(id)):
#			if !astar.has_point(id-1) || !astar.has_point(id-map_width) || !astar.has_point(id-map_width-1): deletion.append(id)
#			else:
#				var i = scene_test.instance()
#				add_child(i)
#				i.position = Vector2(id % map_width,floor(id/map_width))*16+Vector2(8,8)
#
#	for id in deletion:
#		astar.remove_point(id)
	
	for y in range(0,map_height):
		for x in range(0,map_width):
			#print(tilemap.get_cell(x,y))
			if tilemap.get_cell(x,y) == 0 && tilemap.get_cell(x,y+1) == -1:
				water_border.set_cell(x,y,0)
				water_border.set_cell(x,y+1,0)
				if tilemap.get_cell(x-1,y+1) == 0 && tilemap.get_cell(x-1,y) == 0:
					water_border.set_cell(x-1,y+1,0)
					water_border.set_cell(x-1,y,0)
				if tilemap.get_cell(x+1,y+1) == 0 && tilemap.get_cell(x+1,y) == 0:
					water_border.set_cell(x+1,y+1,0)
					water_border.set_cell(x+1,y,0)
	water_border.update_bitmask_region(Vector2(0,0),Vector2(map_width,map_height))
	
	print(astar.get_points().size())
	var random_position = Vector3(rand_range(10,map_width-10),rand_range(10,map_height-10),0)
	print(random_position)
	player.id = astar.get_closest_point(random_position)
	player.update()

func move_entity(entity, dir):
	var new_id = entity.id+dir.x + dir.y*map_width
	if(astar.are_points_connected(entity.id,new_id)):
		var pos = Vector2()
		pos.x = round(fmod(entity.id,map_width))
		pos.y = floor(entity.id / map_width)
		map[pos.x][pos.y] = null
		map[pos.x + dir.x][pos.y + dir.y] = entity
		entity.id = new_id
	entity.update()

func start_game():
	init_map()
	pass
