extends Area2D

signal lap_over

func _on_body_entered(body: Node2D) -> void:
	if body is DeLorian:
		$AnimationPlayer.play("lap")
		lap_over.emit()
