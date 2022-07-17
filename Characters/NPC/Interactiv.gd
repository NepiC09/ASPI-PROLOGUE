extends Polygon2D

#для удобства
onready var camera = GlobalData._camera

func _ready():
	#настройка изменений размера и положения сцены относительно зума камеры
# warning-ignore:return_value_discarded
	camera.connect("zoom_changed", self, "_on_zoom_changed")
	_on_zoom_changed() #сразу же настраиваем, не дожидаясь сигнала

#настройка изменений размера и положения сцены относительно зума камеры
func _on_zoom_changed():
	scale.x = camera.zoom.x * 3
	scale.y = camera.zoom.x * 3
	position.y = (scale.x - 1) * 48 + 24
