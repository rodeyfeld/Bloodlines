extends Area2D

var unit_stunned = null
var new_target = null
var curr_minimum_distance = 1000000.0

	

func _on_Area2D_body_entered(body):
	if body.get_collision_mask_bit(5):
		if body != unit_stunned and !body.status_tags.shocked:
			if self.global_position.distance_to(body.global_position) < curr_minimum_distance:
				curr_minimum_distance = self.global_position.distance_to(body.global_position)
				new_target = body
