extends KinematicBody2D

onready var animationState = $AnimationTree.get("parameters/playback") #для переключения анимаций

#состояния
enum {
	MOVE,
	ATTACK
}

#состояние и вектор движения
var state = MOVE
var velocity = Vector2.ZERO
var _playerStats = PlayerStats
#константы передвижения
export var ACCELERATION = 1800
export var MAX_SPEED = 240
export var FRICTION = 1800

func _ready():
	_playerStats.player = self
	position = _playerStats.spawnPosition

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			pass

#Установка направления персонажа 
func set_direction(input_vector):
		$AnimationTree.set("parameters/Idle/blend_position", input_vector)
		$AnimationTree.set("parameters/Run/blend_position", input_vector)

func move_state(delta):
	#получаемый вектор из кнопок
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO: #RUN
		set_direction(input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta )
	else: #IDLE
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()

func move():
	velocity = move_and_slide(velocity)

func _exit_tree():
	_playerStats.player = null
