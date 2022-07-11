extends CanvasLayer

signal FadeInFinished

func _on_animation_finished(anim_name):
	if anim_name == "FadeIn":
		emit_signal("FadeInFinished")

func start_anim(anim_name):
	$Fade/AnimationPlayer.play(anim_name)
