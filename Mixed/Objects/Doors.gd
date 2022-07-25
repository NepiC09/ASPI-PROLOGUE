extends Sprite

#ссылки на дочерние узлы сцены
onready var timer = $Timer

#ссылка на Fade элемент
onready var UI = get_tree().current_scene.get_node("Fade")
var player :KinematicBody2D
var playerStats = PlayerStats

#экспортируемые - изменяемые переменные
export var anim_speed = 4 #скорость анимации
export var anim_end = 12 #фрейм конца анимации

export var change_to = "" #на какую карту перенесёт
export var set_position_to = Vector2.ZERO #на какую позицию перенесёт

#переменные
var opening :bool #открывается ли дверь аль закрывается 
var player_on_area :bool #находится ли игрок в области
var start_frame :int #начальный фрейм


func _ready():
	start_frame = frame #установка стартового фрейма
	UI.connect("FadeInFinished", self, "_on_FadeInFinished")
	set_active(false) #анимация

#Click to E key
func _unhandled_input(_event):
	if player_on_area and Input.is_action_just_released("action"):
		UI.start_anim("FadeIn") #переход на другую локацию

#Анимация открытия или закрытия двери
func _on_Timer_timeout():
	if opening:
		if frame == start_frame+anim_end:
			timer.stop()
		else:
			frame += anim_speed
	else:
		if frame == start_frame:
			timer.stop()
		else:
			frame -= anim_speed

#Смена сцены после анимации FadeIn
func _on_FadeInFinished():
	playerStats.spawnPosition = set_position_to #установка позиции спавана игрока
# warning-ignore:return_value_discarded
	get_tree().change_scene(change_to) #смена сцены

#Вход и выход игрока
func _on_Area2D_body_entered(_body):
	player = _body
	set_active(true)

func _on_Area2D_body_exited(_body):
	player = null
	set_active(false)

func set_active(_bool):
	opening = _bool
	player_on_area = _bool
	if timer.is_inside_tree():
		timer.start() #включение анимации
