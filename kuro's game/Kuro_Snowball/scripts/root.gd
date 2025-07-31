extends Node2D

#Items to instantiate
@export var menu: PackedScene
@export var game: PackedScene
@export var high_score: PackedScene

func _ready():
	Globals.load_player()
	
	var dup=menu.instantiate()
	dup.name="menu"
	add_child(dup)
	get_tree().set_quit_on_go_back(true)
	#get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/Login.tscn")
	
	
func _process(_delta):
	if Input.is_action_pressed("New_Game"):
		var dup=game.instantiate()
		dup.name="game"
		add_child(dup)
		$menu.queue_free()
		get_tree().set_quit_on_go_back(false)
	elif Input.is_action_pressed("Game_Over"):
		Globals.save_player()
		var dup=menu.instantiate()
		dup.name="menu"
		add_child(dup)
		$game.queue_free()
		get_tree().set_quit_on_go_back(true)
	elif Input.is_action_pressed("High_Score_Menu"):
		var dup=high_score.instantiate()
		dup.name="high_score"
		add_child(dup)
		$menu.queue_free()
		get_tree().set_quit_on_go_back(false)
	elif Input.is_action_pressed("High_Score_Back"):
		var dup=menu.instantiate()
		dup.name="menu"
		add_child(dup)
		$high_score.queue_free()
		get_tree().set_quit_on_go_back(true)
	
