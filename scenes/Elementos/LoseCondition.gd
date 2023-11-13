extends Area2D

var characters_inside: Array[CharacterBody2D] = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node):
	if body is CharacterBody2D:
		characters_inside.append(body)
		LevelManager.restart_level()


func _on_body_exited(body: Node):
	characters_inside.erase(body)
	
