extends Camera2D

var screen_shake = 0.0


func shake(strength):
	screen_shake = strength

func _process(delta):
	offset = screen_shake * Vector2(1,0).rotated(cos(screen_shake))
	screen_shake /= 1.1