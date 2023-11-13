extends Node

@export var main_menu: PackedScene
@export var credits: PackedScene

@export var levels: Array[PackedScene]

var current_level = 0

func _ready():
	pass
#	current_level = cargado


func go_to_level(index):
	if index < levels.size():
		var level = levels[index]
		if level:
			current_level = index
			get_tree().change_scene_to_packed(level)


func start_game():
	go_to_level(0)


func next_level():
	go_to_level(current_level + 1)
	

func restart_level():
	go_to_level(current_level)


func go_to_main_menu():
	current_level = 0
	if main_menu:
		get_tree().change_scene_to_packed(main_menu)

func go_to_credits():
	if credits:
		get_tree().change_scene_to_packed(credits)
