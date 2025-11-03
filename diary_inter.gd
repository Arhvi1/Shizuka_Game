extends Area2D

@onready var diary: Node2D = $Diary
@onready var book_sound: AudioStreamPlayer2D = $WpnHudoff

var is_diary_open: bool = false

func _ready():
	# Скрываем дневник при старте
	if diary:
		diary.visible = false
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Shizuka":
		body.set_interactable(self)
		print("Игрок у дневника")

func _on_body_exited(body):
	if body.name == "Shizuka":
		body.clear_interactable()
		print("Игрок отошёл от дневника")

func interact():
	if not diary:
		return
	
	is_diary_open = !is_diary_open
	
	if is_diary_open:
		book_sound.play()
		# Открываем дневник
		diary.visible = true
		_disable_player_movement()
		print("Дневник открыт")
	else:
		# Закрываем дневник
		diary.visible = false
		_enable_player_movement()
		print("Дневник закрыт")

func _disable_player_movement():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_physics_process(false)

func _enable_player_movement():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Включаем обратно физику
		player.set_physics_process(true)
		
