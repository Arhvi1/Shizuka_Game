extends Area2D

@onready var click_sound: AudioStreamPlayer2D = $ClickSound
@onready var tv_light: PointLight2D = $Inter_light_tv
@onready var tv_sound: AudioStreamPlayer2D = $TvStaticLoop2

var is_on: bool = false
var dialog_played: bool = false # tracking dialogue playing

const lines: Array[String] = [
	"life no hereafter."
]

func _ready():
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
		DialogManager.start_dialog(Vector2(1018.0, 550.0), lines)
		dialog_played = true
		

func update_animation():
	if is_on:
		tv_light.visible = true
		tv_sound.play()
	else:
		tv_light.visible = false
		tv_sound.stop()
	
