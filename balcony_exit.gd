extends Area2D

@onready var anim_sprite: AnimatedSprite2D = $fade
@onready var balcony_sound: AudioStreamPlayer2D = $balconyDoor

func _ready():
	# Подключаем сигналы
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):  # Лучше проверять по группе
		body.set_interactable(self)
		print("Игрок у двери")

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.clear_interactable()
		print("Игрок отошёл от двери")

func interact():
	DialogManager.stop_dialog()
	balcony_sound.play()
	anim_sprite.visible = true
	anim_sprite.play("fade_in")
	await anim_sprite.animation_finished  # Ждём завершения анимации
	
	var next_scene = load("res://Scenes/Maps/Main_room.tscn")
	get_tree().change_scene_to_packed(next_scene)
	
