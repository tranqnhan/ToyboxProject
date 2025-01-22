extends Node

signal finished


func play_animation(amount: int):
	$CPUParticles2D1.amount = amount / 2
	$CPUParticles2D2.amount = amount / 2
	$ConfettiAnimation.current_animation = "particles"


func _on_confetti_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "particles":
		finished.emit()
