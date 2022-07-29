extends KinematicBody2D

#ссылки на узлы сцены
onready var remoteTransform = $RemoteTransform2D
onready var interactiv = $Interactiv
onready var textBox = $TextBox
#ссылки на свойства объектов
onready var animationState = $AnimationTree.get("parameters/playback") #для переключения анимаций
#ссылки на сцены в проекте
onready var DialogManager = preload("res://Dialog System/DialogManager.tscn")


#состояния
enum {
	MOVE,
	DIALOGUE
}

#переменные
var state = MOVE #состояния персонажа 
var velocity = Vector2.ZERO #вектор его движения

#диалоговая система
var player :KinematicBody2D = null #есть ли ИГРОК внутри области персонажа (пока без взаимодействия между НПС)
var dialogManager :Node2D
var character :Character #ресурсы персонажа, со всей инфой (изменения здесь могут быть сохранены или перезаписаны)

#константы передвижения
export var ACCELERATION = 1800
export var MAX_SPEED = 240
export var FRICTION = 1800


func _unhandled_input(_event):
	#активация диалога
	if Input.is_action_just_pressed("action") and player != null and state != DIALOGUE:
		make_dialog_box() #создаёт диалоговое окно и настраивает
		interactiv.visible = false

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
	player = body
	interactiv.visible = true

#игрок вышели из области
func _on_Area2D_body_exited(_body):
	player = null
	interactiv.visible = false

#создание диалогового окна
func make_dialog_box():
	dialogManager = DialogManager.instance()
	
	dialogManager.NPC = self
	dialogManager.player = player
	
	get_tree().current_scene.add_child(dialogManager)
