extends ColorRect

onready var animation_player := $animation_player



func transition_in():
	animation_player.play_backwards("Fade")

func transition_out():
	animation_player.play("Fade")


func _on_animation_player_animation_finished(_anim_name):
	print("fini anim")


func _on_animation_player_animation_started(anim_name):
	print("animat started")
