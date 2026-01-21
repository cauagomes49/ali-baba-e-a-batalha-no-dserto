extends ProgressBar

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		max_value = player.hp_max
		value = player.hp
