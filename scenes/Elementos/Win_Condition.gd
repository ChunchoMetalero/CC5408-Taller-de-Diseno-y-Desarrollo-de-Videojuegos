extends Area2D

var characters_inside: Array[CharacterBody2D] = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _input(event):
	if event.is_action_pressed("interact"):
		for body in characters_inside:
			if LevelManager.levels.size() < 4 :
				LevelManager.next_level()
			else:
				LevelManager.credits

func _on_body_entered(body: Node):
	if body is CharacterBody2D:
		characters_inside.append(body)


func _on_body_exited(body: Node):
	characters_inside.erase(body)
	
