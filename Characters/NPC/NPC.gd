extends KinematicBody2D

onready var animationState = $AnimationTree.get("parameters/playback") #для переключения анимаций
#состояния
enum {
	MOVE
}

#состояние и вектор движения
var state = MOVE
var velocity = Vector2.ZERO
#константы передвижения
export var ACCELERATION = 1800
export var MAX_SPEED = 240
export var FRICTION = 1800

func _ready():
	pass

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

#Установка направления персонажа 
func set_direction(vector):
		$AnimationTree.set("parameters/Idle/blend_position", vector)
		$AnimationTree.set("parameters/Run/blend_position", vector)

func move_state(delta):
	move()

func move():
	velocity = move_and_slide(velocity)
