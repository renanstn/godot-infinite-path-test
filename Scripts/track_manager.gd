extends Node3D

@export var track_segment_scene: PackedScene
@export var segment_length: float = 10.0
@export var preload_count: int = 10
@export var move_speed: float = 10.0
@export var player: Node3D

var segments: Array[Node3D] = []

func _ready():
	for i in range(preload_count):
		var seg = spawn_segment(-i * segment_length)
		segments.append(seg)

func spawn_segment(z_pos: float) -> Node3D:
	var instance = track_segment_scene.instantiate()
	add_child(instance)
	var t: Transform3D = instance.global_transform
	t.origin = Vector3(0.0, 0.0, z_pos)
	instance.global_transform = t
	return instance

func _process(delta):
	# Move train
	for seg in segments:
		seg.translate(Vector3(0, 0, move_speed * delta))

	var first_segment = segments[0]
	if first_segment.global_transform.origin.z > player.global_transform.origin.z + segment_length:
		# Remove segment
		first_segment.queue_free()
		segments.pop_front()
		# Add new segment
		var last_segment = segments[-1]
		var new_z = last_segment.global_transform.origin.z - segment_length
		var new_segment = spawn_segment(new_z)
		segments.append(new_segment)
