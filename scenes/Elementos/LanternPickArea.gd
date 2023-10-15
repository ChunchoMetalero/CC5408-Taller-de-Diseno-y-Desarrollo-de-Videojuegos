class_name PickableArea
extends Area2D

var pickables: Array[Pickable] = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node):
	if body is Pickable:
		pickables.push_back(body)


func _on_body_exited(body: Node):
	pickables.erase(body)

# Returns the closest pickable
func get_pickable() -> Pickable:
	var result = null
	for pickable in pickables:
		if not result:
			result = pickable
			continue
		var result_dist = global_position.distance_squared_to(result.global_position)
		var pickable_dist = global_position.distance_squared_to(pickable.global_position)
		if pickable_dist < result_dist:
			result_dist = pickable
	return result
