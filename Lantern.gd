extends StaticBody2D



@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D
@onready var pivote: Node2D = $Pivote

var angule: float = PI/3

func _ready() -> void:
	get_tree().get_
	
	line_2d.add_point(Vector2(0,0))
	line_2d.add_point(Vector2(0,0))
	ray_cast_2d.target_position = Vector2(cos(angule),sin(angule))


func _physics_process(delta: float) -> void:
	var scala = pivote.scale
	if Input.is_action_pressed("light"):
		line_2d.points[1] = (Vector2(cos(angule),sin(angule))) * scala
	else:
		line_2d.points[1] = Vector2.ZERO
