extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_nivel_1_pressed():
	get_tree().change_scene_to_file("res://scenes/Elementos/main.tscn")


func _on_nivel_2_pressed():
	get_tree().change_scene_to_file("res://Linterna Profe/Luces v2.tscn")


func _on_volver_pressed():
	get_tree().change_scene_to_file("res://scenes/Main Game/menu_principal.tscn")