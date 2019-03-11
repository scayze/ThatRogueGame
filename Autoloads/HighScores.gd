extends Node

func _ready():
	pass

func get_scores():
	var scores = parse_json(ProjectSettings.get_setting("global/scores"))
	if scores == null: scores = []
	scores.sort()
	scores.invert()
	return scores

func save_score(score):
	var scores = get_scores()
	if scores == null: scores = []
	scores.append(score)
	print("Saving score")
	ProjectSettings.set_setting("global/scores",to_json(scores))
	ProjectSettings.save()