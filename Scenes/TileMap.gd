extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func autotile():
	var highest = tile_set.find_tile_by_name("wm") # small hack so it doesnt see water border tiles as filled
	for x in get_parent().map_width:
		for y in get_parent().map_height:
			if get_cell(x,y) != -1 && get_cell(x,y) < highest:
				var t = get_cell(x,y-1) != -1 && get_cell(x,y-1) < highest
				var r = get_cell(x+1,y) != -1 && get_cell(x+1,y) < highest
				var d = get_cell(x,y+1) != -1 && get_cell(x,y+1) < highest
				var l = get_cell(x-1,y) != -1 && get_cell(x-1,y) < highest
				
				if t and r and d and l: set_cell(x,y,tile_set.find_tile_by_name("m"))
				elif t and r and d and !l: set_cell(x,y,tile_set.find_tile_by_name("l"))
				elif t and r and !d and l:
					set_cell(x,y,tile_set.find_tile_by_name("d"))
					set_cell(x,y+1,tile_set.find_tile_by_name("wm"))
				elif t and !r and d and l: set_cell(x,y,tile_set.find_tile_by_name("r"))
				elif !t and r and d and l: set_cell(x,y,tile_set.find_tile_by_name("t"))
				elif t and r and !d and !l:
					set_cell(x,y,tile_set.find_tile_by_name("dl"))
					set_cell(x,y+1,tile_set.find_tile_by_name("wl"))
				elif t and !r and !d and l:
					set_cell(x,y,tile_set.find_tile_by_name("dr"))
					set_cell(x,y+1,tile_set.find_tile_by_name("wr"))
				elif !t and !r and d and l: set_cell(x,y,tile_set.find_tile_by_name("tr"))
				elif !t and r and d and !l: set_cell(x,y,tile_set.find_tile_by_name("tl"))
