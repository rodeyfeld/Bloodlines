extends RayCast2D

var is_casting := false setget set_is_casting
onready var line2d = $Line2D
onready var tween = $Tween
onready var casting_particles = $CastingParticles2d
onready var collision_particles = $CollisionParticles2d
onready var beam_particles = $BeamParticles2d

func _ready() -> void:
	set_physics_process(false)
	line2d.points[1] = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		self.is_casting = true


func physics_process(delta: float) -> void:
	var cast_point := cast_to
	force_raycast_update()
	collision_particles.emitting = is_colliding()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
	line2d.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	casting_particles.emitting = is_casting
	beam_particles.emitting = is_casting
	if is_casting:
		appear()
	else:
		collision_particles.emitting = false
		beam_particles.emitting = false
		disappear()
	set_physics_process(is_casting)

func appear() -> void:
	tween.stop_all()
	tween.interpolate_property(line2d, "width", 0, 10.0, .2)
	tween.start()

func disappear() -> void:
	tween.stop_all()
	tween.interpolate_property(line2d, "width", 10.0, 0, 0.1)
	tween.start()
