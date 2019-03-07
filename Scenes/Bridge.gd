extends Node2D

onready var horizontal = get_node("Horizontal")
onready var left = get_node("Horizontal/Left")
onready var hmid = get_node("Horizontal/Mid")
onready var right = get_node("Horizontal/Right")

onready var vertical = get_node("Vertical")
onready var up = get_node("Vertical/Up")
onready var vmid = get_node("Vertical/Mid")
onready var bot = get_node("Vertical/Bot")

func place_bridge(hor,length):
	#Horizontal
	if hor: # horizontal
		horizontal.z_index = position.y / 16
		horizontal.visible = true
		for i in range(length):
			if i == 0: pass
			elif i == length-1: right.position.x = i*16
			else:
				var mid = hmid.duplicate()
				mid.visible = true
				horizontal.add_child(mid)
				mid.position.x = i*16
	else: #Vertical
		vertical.visible = true
		for i in range(length):
			if i == 0: pass
			elif i == length-1: bot.position.y = i*16
			else:
				var mid = vmid.duplicate()
				mid.visible = true
				vertical.add_child(mid)
				mid.position.y = i*16
		for c in vertical.get_children():
			c.z_index = c.global_position.y / 16 
