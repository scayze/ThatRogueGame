extends Node

onready var w = get_parent().map_width
onready var h = get_parent().map_height

var map = []
var rects = []
var available = []

var bridge_length = 5

onready var flora = get_parent().get_node("Flora")
onready var tilemap = get_parent().get_node("TileMap")

var scene_tree = preload("res://Scenes/Tree.tscn")
var scene_bush = preload("res://Scenes/Bush.tscn")
var scene_zombie = preload("res://Scenes/Zombie.tscn")
var scene_chest = preload("res://Scenes/Chest.tscn")

var scene_bridge = preload("res://Scenes/Bridge.tscn")

var island_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func reset():
	#Clear Entities
	for c in get_children():
		c.queue_free()
	#Reset Variables
	island_count = 0
	
	w = get_parent().map_width
	h = get_parent().map_height
	
	map.clear()
	available.clear()
	rects.clear()
	
	rects.append(Rect2(0,0,w,1))
	rects.append(Rect2(0,0,1,h))
	
	rects.append(Rect2(0,h-1,w,1))
	rects.append(Rect2(w-1,0,1,h))
	
	for x in range(0,w):
		map.append([])
		map[x].resize(h)

func gather_available():
	for x in range(w):
		for y in range(h):
			if typeof(map[x][y]) == TYPE_INT: 
				available.append(Vector2(x,y))

func place_chests():
	if available.size() == 0: return
	var chest_available = []
	
	for a in available:
		var ok = true
		if !map[a.x-1][a.y-1]: ok = false
		elif !map[a.x-1][a.y]: ok = false
		elif !map[a.x-1][a.y+1]: ok = false
		elif !map[a.x][a.y-1]: ok = false
		elif !map[a.x][a.y]: ok = false
		elif !map[a.x][a.y+1]: ok = false
		elif !map[a.x+1][a.y-1]: ok = false
		elif !map[a.x+1][a.y]: ok = false
		elif !map[a.x+1][a.y+1]: ok = false
		if ok: chest_available.append(a)
		
	print(chest_available.size())
	for i in range(3):
		var r = rand_range(0,chest_available.size())
		var chest = scene_chest.instance()
		add_child(chest)
		get_parent().spawn_entity(chest,chest_available[r])

func plant_trees():
	for i in range(7):
		if available.size() == 0: return
		var r = rand_range(0,available.size())
		var tree = scene_tree.instance()
		add_child(tree)
		get_parent().spawn_entity(tree,available[r])
			
	for i in range(15):
		if available.size() == 0: return
		var r = rand_range(0,available.size())
		var bush = scene_bush.instance()
		add_child(bush)
		get_parent().spawn_entity(bush,available[r])

func spawn_fucks():
	for i in range(10):
		if available.size() == 0: return
		var r = rand_range(0,available.size())
		var zomb = scene_zombie.instance()
		add_child(zomb)
		get_parent().spawn_entity(zomb,available[r])
		available.remove(r)

func choose_island_spawns():
	var island_spawns = []
	var island_bridge = []
	#debug_print()
	for x in range(1,w-1):
		for y in range(1,h-1):
			if typeof(map[x][y]) != TYPE_INT: continue
			var line
			
			#Left
			line = Rect2(x-bridge_length,y-1,bridge_length,3)
			if check_for_overlap(line):
				var rect = Rect2(x-bridge_length-3,y-1,3,3)
				if check_for_overlap(rect):
					island_spawns.append(rect)
					island_bridge.append(line)
			#Right
			line = Rect2(x+1,y-1,bridge_length,3)
			if check_for_overlap(line):
				var rect = Rect2(x+bridge_length+1,y-1,3,3)
				if check_for_overlap(rect):
					island_spawns.append(rect)
					island_bridge.append(line)
			#Up
			line = Rect2(x-1,y-bridge_length,3,bridge_length)
			if check_for_overlap(line):
				var rect = Rect2(x-1,y-bridge_length-3,3,3)
				if check_for_overlap(rect):
					island_spawns.append(rect)
					island_bridge.append(line)
			#Down
			line = Rect2(x-1,y+1,3,bridge_length)
			if check_for_overlap(line):
				var rect = Rect2(x-1,y+bridge_length+1,3,3)
				if check_for_overlap(rect):
					island_spawns.append(rect)
					island_bridge.append(line)
	
	var r = rand_range(0,island_spawns.size())
	return [island_spawns[r],island_bridge[r]]

func rect_fill_array(r : Rect2, a : Array):
	for x in range(r.size.x):
		for y in range(r.size.y):
			a.append(Vector2(x+r.position.x,y+r.position.y))

func check_for_overlap(rect):
	var ok = true
	for r in rects:
		if rect.intersects(r):
			ok = false 
			break
	return ok

func beautify():
	for x in range(w):
		for y in range(h):
			if typeof(map[x][y]) == TYPE_INT:
				var r = rand_range(0,4)
				if r < 1.5: flora.set_cell(x,y,rand_range(0,flora.tile_set.get_tiles_ids().size())) 
	flora.update_dirty_quadrants()

func clean():
	for x in range(w):
		for y in range(h):
			if typeof(map[x][y]) == TYPE_INT: map[x][y] = null

func gen_navigation(astar):
	for y in range(0,h):
		for x in range(0,w):
			if map[x][y] != null:
				var id = x+y*w
				astar.add_point(id,Vector3(x,y,0))
				
				if typeof(map[x][y]) == TYPE_INT: tilemap.set_cell(x,y,0)
				if y > 0 and astar.has_point(id-w): astar.connect_points(id,id-w)
				if x > 0 and astar.has_point(id-1): astar.connect_points(id,id-1)
	tilemap.autotile()

func build_bridge(r : Rect2):
	var b = scene_bridge.instance()
	add_child(b)
	var ar = []
	if r.size.y == 3:
		b.position = (r.position + Vector2(0,1)) * 16
		b.place_bridge(true,r.size.x)
		rect_fill_array(r.grow_individual(0,-1,0,-1),ar)
	else:
		b.position = (r.position + Vector2(1,0)) * 16
		b.place_bridge(false,r.size.y)
		rect_fill_array(r.grow_individual(-1,0,-1,0),ar)
	for p in ar:
		map[p.x][p.y] = "#"

func add_island(init_size : Vector2,depth,decrease):
	randomize()
	var island = []
	var current_rects = []
	var size = init_size
	
	if island_count > 0: 
		var spawn = choose_island_spawns()
		var start = spawn[0]
		var line = spawn[1]
		rect_fill_array(start,island)
		current_rects.append(start)
		rects.append(line)
		build_bridge(line)
		for x in start.size.x:
			for y in start.size.y:
				map[x+start.position.x][y+start.position.y] = island_count
	
	for i in range(depth):
		#if i != 0: size *= decrease
		size = size.round()
		if(size.x <= 1 || size.y <= 1): break
		if rand_range(0,1) <= 0.5: 
			size = Vector2(size.y,size.x)
		
		for tries in range(20):
			var rpos
			if island.size() == 0: rpos = Vector2(rand_range(1,w-size.x-1),rand_range(1,h-size.y-1))
			else: rpos = island[rand_range(0,island.size())] + Vector2(rand_range(-1,0)*size.x/1.75,rand_range(-1,0)*size.y/1.75)
			
			rpos = rpos.round()
			
			var rect = Rect2(rpos,size) 
			if check_for_overlap(rect):
				for x in size.x:
					for y in size.y:
						if !island.has(Vector2(x+rpos.x,y+rpos.y)): island.append(Vector2(x+rpos.x,y+rpos.y))
						map[x+rpos.x][y+rpos.y] = island_count
				current_rects.append(rect)
				#print("island depth")
				break
	for cr in current_rects:
		rects.append(cr)
	island_count += 1

func debug_print():
	for y in h:
		var s = ""
		for x in w:
			if map[x][y] == null: s+= "- "
			else: s += str(map[x][y]) + " "
		print(s)