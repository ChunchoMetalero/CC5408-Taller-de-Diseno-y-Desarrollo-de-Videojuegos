extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Iniciar.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_iniciar_pressed():
	get_tree().change_scene_to_file("res://scenes/Levels/Level0.tscn")
	


func _on_salir_pressed():
	get_tree().quit()


func _on_niveles_pressed():
	get_tree().change_scene_to_file("res://scenes/Main Game/niveles.tscn")
