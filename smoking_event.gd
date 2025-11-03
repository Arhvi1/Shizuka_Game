extends Area2D

@onready var background_music = $BackgroundMusic
@onready var rain_sound = $Rain_sound

var player: CharacterBody2D = null  # Явно указываем тип для автодополнения
var first_interaction: bool = true  # Флаг для отслеживания первого взаимодействия

const line1: Array[String] = [
	"Any way out of this?...
	 I want to hope
	 *sighs deeply*
	 I'm in a loop with no exit."
]

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		player = body  # Сохраняем игрока
		body.set_interactable(self)  # Показываем подсказку взаимодействия
		print("Игрок у перил")

func _on_body_exited(body: Node):
	if body.is_in_group("player"):
		player = null  # Очищаем ссылку
		body.clear_interactable()  # Убираем подсказку
		print("Игрок отошёл от перил")

func interact():
	if not player:
		return
	player.is_leaning = !player.is_leaning  # Переключаем состояние
	if player.is_leaning:
		player._play_animation("balcony_idle")  # Анимация опирания
		if first_interaction:
			background_music.play()
			DialogManager.start_dialog(Vector2(980, 570), line1)
			first_interaction = false
		var tween = create_tween()
		tween.tween_property(rain_sound, "volume_db", -16, 1.0)
		
	else:
		player._update_animation()  # Возвращаем обычную анимацию
		var tween = create_tween()
		tween.tween_property(background_music, "volume_db", -10, 1.0)
