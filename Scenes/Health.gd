extends Node2D

onready var bar = get_node("Bar")
var base_bar_length = 14.0
var bar_length = 14.0

signal bar_empty

func _process(delta):
	if bar.region_rect.size.x > bar_length:
		bar.region_rect.size.x -= delta*50.0
		if bar.region_rect.size.x < bar_length: bar.region_rect.size.x = bar_length
	elif bar.region_rect.size.x < bar_length:
		bar.region_rect.size.x += delta*50.0
		if bar.region_rect.size.x > bar_length: bar.region_rect.size.x = bar_length
	
	if bar.region_rect.size.x == bar_length && bar_length == 0:
		emit_signal("bar_empty")

func set_health(p):
	bar_length = 14.0*p
