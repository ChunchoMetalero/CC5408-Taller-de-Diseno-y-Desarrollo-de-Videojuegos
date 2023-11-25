class_name PickLanternArea
extends Area2D

var pickables: Array[PickLantern] = []

func _ready():
	body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node):
	if body is PickLantern:
		pickables.push_back(body)


#func _on_body_exited(body: Node):
	#kables.erase(body)

# Returns the closest pickable
func get_pickable() -> PickLantern:
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
