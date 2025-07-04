extends Node2D

#Items to instantiate
@export var menu: PackedScene
@export var game: PackedScene
@export var login: PackedScene

func _ready():
	Globals.load_player()
	
	var dup=menu.instantiate()
	dup.name="menu"
	add_child(dup)
	
	#var dup=login.instantiate()
	#dup.name="login"
	#dup.scale=Vector2(0.25,0.25)
	#add_child(dup)
	
	SilentWolf.configure({
		"api_key": "W3YExim0YC6S6VBupAsUj8jK9RuxxPVktpwXHTK3",
		"game_id": "Snowball1",
		"log_level": 1})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/root.tscn"
	})
	
	#get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/Login.tscn")
	
func _process(delta):
	if Input.is_action_pressed("New_Game"):
		var dup=game.instantiate()
		dup.name="game"
		add_child(dup)
		$menu.queue_free()
	elif Input.is_action_pressed("Game_Over"):
		Globals.save_player()
		var dup=menu.instantiate()
		dup.name="menu"
		add_child(dup)
		$game.queue_free()
	
