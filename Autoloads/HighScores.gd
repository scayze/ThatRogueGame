extends Node

func _ready():
	pass

func get_scores():
	var scores = []
	var file = File.new()
	if file.open("user://highscores.txt", File.READ) != 0:
	    print("Error opening file")
	    return
	while !file.eof_reached():
		var line = file.get_line()
		scores.append(int(line))
	scores.remove(scores.size()-1)
	file.close()
	scores.sort()
	scores.invert()
	return scores

func save_score(score):
	var file = File.new()
	if file.open("user://highscores.txt", File.READ_WRITE) != 0:
	    print("Error opening file")
	    return
	file.seek_end()
	#file.store_string("\n")
	file.store_line(str(score))
	file.close()