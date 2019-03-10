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

var scene_rect = preload("res://Scenes/UI/Rect.tscn")
var scene_health = preload("res://Scenes/UI/Health.tscn")

var hp = 1

export var max_hp = 1
export var is_blocking = false
export var is_attackable = true
export var visible_health = true
export var healthbar_offset = 0
export var crit_chance = 0.2
export var crit_multiplier = 2.0

var stunned = 0

export(Type) var type = Type.OBJECT

var anim_blink = preload("res://Animations/Blink.tres")
var anim_blink_crit = preload("res://Animations/BlinkCrit.tres")
onready var blink_player = AnimationPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(blink_player)
	blink_player.add_animation("Blink",anim_blink)
	blink_player.add_animation("BlinkCrit",anim_blink_crit)
	pass # Replace with function body.

func _process(delta):
	if blink_player.is_playing(): return
	#Fade to correct position, looks waaaaaay better
	var goal_position = pos * 16 + Vector2(8,8)
	position += (goal_position - position) * clamp(delta * 50,0,1)

func init(nav,hero,m):
	astar = nav
	player = hero
	main = m
	
	hp = max_hp + 0.25 * main.current_level
	position = pos * 16 + Vector2(8,8)
	
	rect = scene_rect.instance()
	rect.set_type(type)
	add_child(rect)
	
	healthbar = scene_health.instance()
	healthbar.visible = false
	healthbar.position.y = -healthbar_offset
	healthbar.connect("bar_empty",self,"healthbar_empty")
	add_child(healthbar)
	
	if has_method("on_init"): call("on_init")

func stun(a):
	if a+1 > stunned:
		stunned = a+1

func take_turn():
	if stunned > 0:
		stunned -= 1
		return
	if has_method("on_turn"): call("on_turn")
	

func healthbar_empty():
	if has_method("on_health_empty"): call("on_health_empty")

func id_to_pos(i):
	return Vector2(fmod(i,get_tree().get_root().get_node("Main").map_width), floor(i / get_tree().get_root().get_node("Main").map_width))

func attack(entity):
	if has_method("on_attack"): call("on_attack",entity)

func heal(a):
	if has_method("on_heal"): call("on_heal",a)
	hp += a
	hp = clamp(hp,0,max_hp)
	healthbar.set_health(float(hp)/max_hp)

func deal_damage(d):
	var r = rand_range(0,1)
	if r<= crit_chance and (type == Type.ENEMY || type == Type.PLAYER):
		d *= crit_multiplier
	if has_method("on_damage"): call("on_damage",d)
	if is_attackable:
		hp -= d
		hp = clamp(hp,0,max_hp)
		healthbar.set_health(float(hp)/max_hp)
		if visible_health:
			if r <= crit_chance: blink_player.play("Blink")
			else: blink_player.play("Blink")
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
	#position = pos * 16 + Vector2(8,8)
	#print(id)
	#print(pos)
	pass
