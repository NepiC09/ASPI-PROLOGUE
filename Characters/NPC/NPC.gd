extends KinematicBody2D

#ссылки на узлы сцены
onready var remoteTransform = $RemoteTransform2D
onready var interactiv = $Interactiv
#ссылки на свойства объектов
onready var animationState = $AnimationTree.get("parameters/playback") #для переключения анимаций
#ссылки на сцены в проекте
onready var DialogBox = preload("res://Dialog System/Dialog.tscn")

#состояния
enum {
	MOVE
}

#переменные
var state = MOVE #состояния персонажа 
var velocity = Vector2.ZERO #вектор его движения
var dialog_process = false #находится ли персонаж в диалоге
var playerInArea :KinematicBody2D = null #есть ли ИГРОК внутри области персонажа (пока без взаимодействия между НПС)
var dialogBox :Position2D #диалоговое окно, которое будет спавниться
var character :Character #ресурсы персонажа, со всей инфой (изменения здесь могут быть сохранены или перезаписаны)
#константы передвижения
export var ACCELERATION = 1800
export var MAX_SPEED = 240
export var FRICTION = 1800

#активация диалога
func _unhandled_input(_event):
	if Input.is_action_just_pressed("action") and playerInArea != null and !dialog_process: 
		make_dialog_box() #создаёт диалоговое окно и настраивает
		if dialogBox.needToDelete: #ВРЕМЕННЫЙ КОСТЫЛЬ
			dialogBox.queue_free()
			playerInArea.set_physics_process(true)
			dialog_process = false
		else:
			set_dialog_process() #настраивает процесс диалога
	if Input.is_action_just_released("ui_accept") and dialog_process and dialogBox.needToDelete:
		dialogBox.queue_free()
		playerInArea.set_physics_process(true)
		dialog_process = false

func _ready():
	interactiv.visible = false

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

#Установка направления персонажа 
func set_direction(vector):
		$AnimationTree.set("parameters/Idle/blend_position", vector)
		$AnimationTree.set("parameters/Run/blend_position", vector)

func move_state(_delta):
	move()

func move():
	velocity = move_and_slide(velocity)

#игрок зашёл в область
func _on_Area2D_body_entered(body):
	playerInArea = body
	animationState.travel("Idle")
	interactiv.visible = true

#игрок вышели из области
func _on_Area2D_body_exited(_body):
	playerInArea = null
	interactiv.visible = false

#создание диалогового окна
func make_dialog_box():
	dialogBox = DialogBox.instance()
	dialogBox.character = character
	get_tree().current_scene.get_node("Dialogs").add_child(dialogBox)
	remoteTransform.remote_path = dialogBox.get_path()

#Настройка диалогового процесса с игроком - будет изменено, наверное
func set_dialog_process():
	dialog_process = true 
	interactiv.visible = false #отключается отображение возможности интерактива
	playerInArea.set_physics_process(false) #отнимается возможность игрока передвигаться
	playerInArea.animationState.travel("Idle") #переводит его анимацию в Idle
	#поворачивает собеседников лицом друг к другу
	set_direction(playerInArea.position - position) 
	playerInArea.set_direction(position - playerInArea.position)
