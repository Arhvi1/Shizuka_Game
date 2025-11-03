# Character.gd
extends CharacterBody2D

@export_group("Movement Settings")
@export var speed: float = 300.0
@export var acceleration: float = 2500.0
@export var friction: float = 1200.0
@onready var camera: Camera2D = $Camera2D
@onready var _animated_sprite: AnimatedSprite2D = $playerAnimation
@onready var interact_prompt: Label = $TextEdit
@onready var steps_sound: AudioStreamPlayer2D = $StepsSound

const lines: Array[String] = [
	"Well, it's cool now."
]

#Animation
var _facing_direction: Vector2 = Vector2.DOWN
var _current_animation: String = ""
var current_interactable = null
var _is_flipped: bool = false
var is_leaning: bool = false
var step_frame: int = 0


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	interact_prompt.visible = false
	camera.enabled = true  # Disabled by default
	add_to_group("player")
	# Reset camera limits
	

func _process(_delta):
	if _animated_sprite.is_playing and (_animated_sprite.animation.begins_with("walk_down")
		or _animated_sprite.animation.begins_with("walk_up")
		or _animated_sprite.animation.begins_with("walk_down") or _animated_sprite.animation.begins_with("walk_horizontal")):
		if not steps_sound.is_playing():
			_setup_audio_based_on_scene()
			steps_sound.pitch_scale = randf_range(0.95, 1.05)
			steps_sound.play()
	else:
		if steps_sound.is_playing():
			steps_sound.stop()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(self):
		return
	
	_handle_movement(delta)
	move_and_slide()
	_update_animation()
	_update_facing()
	

func _handle_movement(delta: float) -> void:
	if is_leaning:  # Добавляем эту проверку
		velocity = Vector2.ZERO
		return
	
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector != Vector2.ZERO:
		_facing_direction = input_vector.normalized()
		var target_velocity: Vector2 = input_vector * speed
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func _update_animation() -> void:
	var new_animation := _determine_animation()
	
	if new_animation != _current_animation:
		_play_animation(new_animation)
		_current_animation = new_animation

func _determine_animation() -> String:
	if velocity.length() > 5.0:
		if abs(_facing_direction.x) > abs(_facing_direction.y):
			return "walk_horizontal"
		else:
			return "walk_down" if _facing_direction.y > 0 else "walk_up"
	else:
		if abs(_facing_direction.x) > abs(_facing_direction.y):
			return "idle_horizontal"
		else:
			return "idle_down" if _facing_direction.y > 0 else "idle_up"

func _play_animation(animation_name: String) -> void:
	if is_instance_valid(_animated_sprite) and _animated_sprite.sprite_frames:
		if _animated_sprite.sprite_frames.has_animation(animation_name):
			_animated_sprite.play(animation_name)

func _update_facing() -> void:
	if not is_instance_valid(_animated_sprite):
		return
	
	if abs(_facing_direction.x) > abs(_facing_direction.y):
		_animated_sprite.flip_h = (_facing_direction.x < 0)
		_is_flipped = (_facing_direction.x < 0)
	else:
		_animated_sprite.flip_h = false
		_is_flipped = false

func _unhandled_input(event):
	if not is_instance_valid(self):
		return
	
	if event.is_action_pressed("interact") and current_interactable:
		current_interactable.interact()


func set_interactable(obj):
	if not is_instance_valid(self):
		return
	
	current_interactable = obj
	if is_instance_valid(interact_prompt):
		interact_prompt.visible = true

func clear_interactable():
	if not is_instance_valid(self):
		return
	
	current_interactable = null
	if is_instance_valid(interact_prompt):
		interact_prompt.visible = false

func pause_control(paused: bool):
	if not is_instance_valid(self):
		return
	
	set_physics_process(not paused)
	set_process_unhandled_input(not paused)
	
	if is_instance_valid(camera):
		camera.enabled = not paused
		if not paused:
			camera.make_current()

func enable_camera(enable: bool):
	if not is_instance_valid(self) or not is_instance_valid(camera):
		return
	
	camera.enabled = enable
	if enable:
		camera.make_current()

func _setup_audio_based_on_scene():
	var current_scene = get_tree().current_scene
	if current_scene and current_scene.scene_file_path:
		var scene_path = current_scene.scene_file_path
		
		# Проверяем содержит ли путь к сцене "Dream_1"
		if "street" in scene_path:
			steps_sound.bus = "phaser"
			print("Reverb bus для Dream_1 сцены")
		else:
			steps_sound.bus = "Master"
