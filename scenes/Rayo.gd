extends RayCast2D


@onready var line_2d: Line2D = $"../Line2D"
@onready var player: CharacterBody2D = $"../.."
@onready var pivote: Node2D = $".."

func _ready():
	line_2d.add_point(Vector2(0,0))
	line_2d.add_point(Vector2(0,0))
	target_position = Vector2(200,0)
	
	
func prender_linterna() -> void:
	if is_colliding():
		var scala = pivote.scale
		var collider = get_collider()
		var colliderPosition = get_collision_point()
		#print(collider)
		#print(colliderPosition)
		line_2d.points[1] = (colliderPosition - global_position) * scala
	else:
		apagar_linterna()
	
	
func apagar_linterna() -> void:
		line_2d.points[1] = Vector2.ZERO

