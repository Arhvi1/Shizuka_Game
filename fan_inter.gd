extends Area2D

@onready var anim_sprite = $fan
@onready var click_sound = $ClickSound
@onready var fan_sound = $FanSound

var is_on: bool = false
var dialog_played: bool = false # tracking dialogue playing

const lines: Array[String] = [
	"Well, it's cool now."
]

func _ready():
	anim_sprite.play("off")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Shizuka":
		body.set_interactable(self)

func _on_body_exited(body):
	if body.name == "Shizuka":
		body.clear_interactable()
	
func interact():
	is_on = !is_on
	update_animation()
	
	# Звук щелчка
	click_sound.pitch_scale = randf_range(0.95, 1.05)
	click_sound.play()
	
	if is_on and not dialog_played:
		DialogManager.start_dialog(global_position, lines)
		dialog_played = true
		fan_sound.volume_db = -10
		fan_sound.pitch_scale = randf_range(0.98, 1.02)
		fan_sound.play()
	
	else:
		var tween = create_tween()
		tween.tween_property(fan_sound, "volume_db", -20, 1.0)
		tween.tween_callback(fan_sound.stop)

func update_animation():
	if is_on:
		anim_sprite.play("on")
	else:
		anim_sprite.play("off")
