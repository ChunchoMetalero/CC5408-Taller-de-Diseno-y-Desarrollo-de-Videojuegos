extends RayCast2D


#var is_casting = false setget set_is_casting



@onready var line_2d: Line2D = $Line2D


func _ready():
	set_physics_process(false)
	line_2d.points[1] = Vector2.ZERO
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventAction:
		if event.action == "light" and event.pressed:
			self.is_casting = event.pressed
			
	

func _physics_process(delta: float) -> void:
	var cast_point = target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
	line_2d.points[1] = cast_point
	
	
#func set_is_casting(cast):
#	is_casting = cast
#	set_physics_process(is_casting)
	
	
	pass
	
	
