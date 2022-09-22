extends CanvasLayer

onready var animation_player := $level_transition/animation_player

func transition_in():
	animation_player.play_backwards("Fade")

func transition_out():
	animation_player.play("Fade")


func _on_animation_player_animation_finished(_anim_name):
	pass


func _on_animation_player_animation_started(_anim_name):
	pass
