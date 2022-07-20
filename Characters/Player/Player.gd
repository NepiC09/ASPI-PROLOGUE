extends KinematicBody2D

#ссылки на свойства узлов
onready var animationState = $AnimationTree.get("parameters/playback") #для переключения анимаций

#состояния
enum {
	MOVE,
	ATTACK,
	DIALOGUE
}

#переменные 
var state = MOVE #состояния персонажа 
var velocity = Vector2.ZERO #вектор движения
#сохранения персонажа можно сделать иным способом, более удобным, но пока работает и так
var _playerStats = PlayerStats #ссылка на глобальную сцену, где сохраняются свойства персонажа
#константы передвижения
export var ACCELERATION = 1800
export var MAX_SPEED = 240
export var FRICTION = 1800


func _ready():
	_playerStats.player = self #установка глобальной ссылки на игрока
	position = _playerStats.spawnPosition #спавн игрока в нужной позиции

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			pass
		DIALOGUE:
			dialogue_state()

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
	
	velocity = move_and_slide(velocity)

func dialogue_state():
	animationState.travel("Idle")

func _exit_tree(): 
	_playerStats.player = null #обнуление глобальной ссылки - на всякий случай
