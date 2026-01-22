extends Node2D
@onready var score = $Pontos

func _process(delta: float) -> void:
	score.text = "Sua Pontuação: " + str(Autoscript.score)

func _on_tentar_novamente_pressed() -> void:
	Autoscript.reset_score()
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_button_pressed() -> void:
	get_tree().exit
