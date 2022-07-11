extends Position2D

onready var camera: Camera2D = null
onready var sizeCorrect = $SizeCorrect

var _globalData = GlobalData

func _ready():
	camera = _globalData._camera
	camera.connect("zoom_changed", self, "_on_zoom_changed")
	_on_zoom_changed()

func _on_zoom_changed():
	sizeCorrect.rect_scale.x = camera.zoom.x * 3
	sizeCorrect.rect_scale.y = camera.zoom.x * 3
	sizeCorrect.rect_position.y = (sizeCorrect.rect_scale.x - 1) * 48
