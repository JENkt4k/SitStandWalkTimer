extends VBoxContainer
# Reference to the shader material
@export_category("Timers")
@export var sit_timer: Timer
@export var stand_timer: Timer
@export var walk_timer: Timer

@export_category("Sounds")
@export var sit_player: AudioStreamPlayer
@export var stand_player: AudioStreamPlayer
@export var walk_player: AudioStreamPlayer

var current_timer

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_timer = sit_timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate minutes and seconds based on TIME
	var total_seconds = int(current_timer.time_left)
	var minutes = (total_seconds / 60) % 60
	var seconds = total_seconds % 60
	# Pass the calculated minutes and seconds to the shader
	$ColorRect.get_material().set_shader_parameter("minutes", minutes)
	$ColorRect.get_material().set_shader_parameter("seconds", seconds)

# Function to pause the current timer and switch to the specified timer
func switch_to_timer(new_timer: Timer) -> void:
	if current_timer != new_timer:
		current_timer.set_paused(true)
		if new_timer.paused:
			new_timer.set_paused(false)
		else:
			new_timer.start()
		current_timer = new_timer
	else:
		new_timer.set_paused(not new_timer.paused)

# Called when the sit button is pressed
func _on_sit_pressed() -> void:
	switch_to_timer(sit_timer)

# Called when the stand button is pressed
func _on_stand_pressed() -> void:
	switch_to_timer(stand_timer)

# Called when the walk button is pressed
func _on_walk_pressed() -> void:
	switch_to_timer(walk_timer)

# Timer timeout handlers
func _on_sit_timer_timeout() -> void:
	sit_player.play()
	current_timer.stop()
	current_timer = stand_timer
	stand_timer.start()
	stand_timer.set_paused(false)

func _on_stand_timer_timeout() -> void:
	stand_player.play()
	current_timer.stop()
	current_timer = walk_timer
	walk_timer.start()
	walk_timer.set_paused(false)
	
func _on_walk_timer_timeout() -> void:
	walk_player.play()
	current_timer.stop()
	current_timer = sit_timer
	sit_timer.start()
	sit_timer.set_paused(false)
