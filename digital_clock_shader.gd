extends VBoxContainer
# Reference to the shader material
@export var shader_material : ShaderMaterial
@export var timer : Timer
#var timer = $"../Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate minutes and seconds based on TIME
	var total_seconds = int(timer.time_left)
	var minutes = (total_seconds / 60) % 60
	var seconds = total_seconds % 60
	# Pass the calculated minutes and seconds to the shader
	$ColorRect.get_material().set_shader_parameter("minutes", minutes)
	#shader_material.set_shader_parameter("minutes", minutes)
	$ColorRect.get_material().set_shader_parameter("seconds", seconds)
	#shader_material.set_shader_param("seconds", seconds)


func _on_sit_pressed() -> void:
	if timer.paused:
		timer.set_paused(false)
	else:
		timer.set_paused(true)
