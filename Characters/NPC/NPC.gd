extends KinematicBody2D

onready var animationState = $AnimationTree.get("parameters/playback") #для переключения анимаций
onready var DialogBox = preload("res://GUI/Dialog System/Dialog.tscn")
onready var remoteTransform = $RemoteTransform2D
onready var interactiv = $Interactiv

#состояния
enum {
	MOVE
}

#состояние и вектор движения
var state = MOVE
var velocity = Vector2.ZERO
var player_on_area = false
#константы передвижения
export var ACCELERATION = 1800
export var MAX_SPEED = 240
export var FRICTION = 1800

func _unhandled_input(event):
	if Input.is_action_just_pressed("action"):
		var dialogBox = DialogBox.instance()
		get_tree().current_scene.get_node("Dialogs").add_child(dialogBox)
		remoteTransform.remote_path = dialogBox.get_path()
		interactiv.visible = false

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


func _on_Area2D_body_entered(body):
	animationState.travel("Idle")
	player_on_area = true
	interactiv.visible = true


func _on_Area2D_body_exited(body):
	player_on_area = false
	interactiv.visible = false
