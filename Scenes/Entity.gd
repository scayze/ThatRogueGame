extends Sprite
class_name Entity

enum Type {
	OBJECT
	PLAYER
	ENEMY
	GOAL
	GOAL_FADED
}

var id = 0
var pos = Vector2(0,0)
var astar : AStar
var player : Entity
var main

var rect
var healthbar

var scene_rect = preload("res://Scenes/Rect.tscn")
var scene_health = preload("res://Scenes/Health.tscn")

var hp = 1

export var max_hp = 1
export var is_blocking = false
export var is_attackable = true
export var visible_health = true
export var healthbar_offset = 0

export(Type) var type = Type.OBJECT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(nav,hero,m):
	astar = nav
	player = hero
	main = m
	
	hp = max_hp
	
	rect = scene_rect.instance()
	rect.set_type(type)
	add_child(rect)
	
	healthbar = scene_health.instance()
	healthbar.visible = false
	healthbar.position.y = -healthbar_offset
	healthbar.connect("bar_empty",self,"healthbar_empty")
	add_child(healthbar)
	
	if has_method("on_init"): call("on_init")

func take_turn():
	if has_method("on_turn"): call("on_turn")

func healthbar_empty():
	if has_method("on_health_empty"): call("on_health_empty")

func id_to_pos(i):
	return Vector2(fmod(i,get_tree().get_root().get_node("Main").map_width), floor(i / get_tree().get_root().get_node("Main").map_width))

func attack(entity):
	if has_method("on_attack"): call("on_attack",entity)

func deal_damage(d):
	if has_method("on_damage"): call("on_damage",d)
	if is_attackable:
		hp -= d
		healthbar.set_health(float(hp)/max_hp)
		if visible_health:
			healthbar.visible = true
	if hp <= 0: die()

func die():
	if has_method("on_death"): call("on_death")
	else: 
		main.remove_entity(self)
		queue_free()

func update():
	pos = id_to_pos(id)
	z_index = pos.y
	position = pos * 16 + Vector2(8,8)
	#print(id)
	#print(pos)
	pass
