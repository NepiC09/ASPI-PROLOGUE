extends KinematicBody2D

#ссылки на узлы сцены
onready var remoteTransform = $RemoteTransform2D
onready var interactiv = $Interactiv
onready var textBox = $TextBox
#ссылки на свойства объектов
onready var animationState = $AnimationTree.get("parameters/playback") #для переключения анимаций
#ссылки на сцены в проекте
onready var DialogBox = preload("res://Dialog System/Dialog.tscn")


#состояния
enum {
	MOVE,
	DIALOGUE
}

#переменные
var state = MOVE #состояния персонажа 
var velocity = Vector2.ZERO #вектор его движения

#диалоговая система
var speaker2 :KinematicBody2D = null #есть ли ИГРОК внутри области персонажа (пока без взаимодействия между НПС)
var dialogBox :Position2D #диалоговое окно, которое будет спавниться
var character :Character #ресурсы персонажа, со всей инфой (изменения здесь могут быть сохранены или перезаписаны)

#константы передвижения
export var ACCELERATION = 1800
export var MAX_SPEED = 240
export var FRICTION = 1800


func _unhandled_input(_event):
	#активация диалога
	if Input.is_action_just_pressed("action") and speaker2 != null and state != DIALOGUE:
		make_dialog_box() #создаёт диалоговое окно и настраивает
		interactiv.visible = false

func _ready():
	textBox._text = "[wave amp=30 freq=10]ДДДДД[/wave]"

func _physics_process(_delta):
	match state:
		MOVE:
			pass
		DIALOGUE:
			dialogue_state()

#Установка направления персонажа 
func set_direction(vector):
		$AnimationTree.set("parameters/Idle/blend_position", vector)
		$AnimationTree.set("parameters/Run/blend_position", vector)

func dialogue_state():
	animationState.travel("Idle")

#игрок зашёл в область
func _on_Area2D_body_entered(body):
	speaker2 = body
	interactiv.visible = true

#игрок вышели из области
func _on_Area2D_body_exited(_body):
	speaker2 = null
	interactiv.visible = false

#создание диалогового окна
func make_dialog_box():
	dialogBox = DialogBox.instance()
	textBox.visible = true
	
	dialogBox.speaker1 = self
	dialogBox.speaker2 = speaker2
	
	get_tree().current_scene.get_node("Dialogs").add_child(dialogBox)
	remoteTransform.remote_path = dialogBox.get_path()
