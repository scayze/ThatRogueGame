extends AudioStreamPlayer

func _ready():
	volume_db = -30
	pass


func _on_AudioStreamPlayer_finished():
	queue_free()
