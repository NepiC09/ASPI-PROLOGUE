extends Camera2D

#ссылки на узлы в сцене
onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

#доступ к глобальным данным
var _globalData = GlobalData

#экспортируемые - изменяемые значения
var max_zoom = 1.5
var min_zoom = 0.5

#сигналы
#signal zoom_changed


func _ready():
	#настройка границ камеры
	limit_left = topLeft.position.x
	limit_top = topLeft.position.y
	limit_right = bottomRight.position.x
	limit_bottom = bottomRight.position.y
	#установка зума на предыдущие сохранённые данные
	zoom.x = clamp(_globalData._cameraZoom.x, min_zoom, max_zoom)
	zoom.y = clamp(_globalData._cameraZoom.y, min_zoom, max_zoom)
	#установка глобальной ссылки на камеру
	_globalData._camera = self

func _exit_tree():
	#сохранения настройки зума для приятного перехода между сценами и сохранениями
	_globalData._cameraZoom = zoom 
	_globalData._camera = null #обнуление камеры, чтобы не было ошибок (на всякий случай)

##вызывается только при нажатии на кнопочки
#func _unhandled_input(_event):
#	#изменения зума камеры от СКМ
#	if Input.is_action_just_released("scroll_down") and !zoom_max():
#		zoom.x += 0.1
#		zoom.y += 0.1
#		emit_signal("zoom_changed")
#
#	if Input.is_action_just_released("scroll_up") and !zoom_min():
#		zoom.x -= 0.1
#		zoom.y -= 0.1
#		emit_signal("zoom_changed")

#проферка максимального зума
func zoom_max():
	if zoom.x >= max_zoom and zoom.y >= max_zoom:
		return 1
	else:
		return 0

#проверка минимального зума
func zoom_min():
	if zoom.x <= min_zoom and zoom.y <= min_zoom:
		return 1
	else:
		return 0
