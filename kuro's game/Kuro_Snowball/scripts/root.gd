extends Node2D

#Items to instantiate
@export var menu: PackedScene
@export var game: PackedScene

func _ready():
	var dup=menu.instantiate()
	dup.name="menu"
	add_child(dup)
	
func _process(delta):
	if Input.is_action_pressed("New_Game"):
		var dup=game.instantiate()
		dup.name="game"
		add_child(dup)
		$menu.queue_free()
	
	
