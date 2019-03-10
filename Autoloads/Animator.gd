extends Node

func _ready():
	pass


func convert_from_sheet(sheet : Texture,row,column,count):
	var anim = Animation.New()
	anim.add_track(0)
	
	var rects = []
	
	var c = 0
	for x in row:
		for y in column:
			if c < count: return
			
			
			
			c+=1