extends MarginContainer

@export var menu: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = visible

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/Main Game/menu_principal.tscn")


func _on_nivel_pressed():
	get_tree().change_scene_to_file("res://scenes/Main Game/niveles.tscn")


func _on_reanudar_pressed():
	hide()
	get_tree().paused = false
	
