extends Node

var save_file="user://player_info.save"
var player_id=null
var player_name=null
var player_score=null
var player_time=null

var cur_score=null
var cur_time=null

var srn=DisplayServer.window_get_size()

func _ready():
	#encrypt_SilentWolf_ID()
	SilentWolf.configure({
		"api_key": decrypt_SilentWolf_ID(),
		"game_id": "Snowball1",
		"log_level": 1})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/root.tscn"
	})

func refresh_score():
	if(cur_score>player_score):
		player_score=cur_score
		player_time=cur_time

func load_player():
	#save_file
	if(FileAccess.file_exists(save_file)):
		var f = FileAccess.open(save_file, FileAccess.READ)
		player_id = f.get_var()
		player_name = f.get_var()
		player_score = f.get_var()
		player_time = f.get_var()
	
	if player_id == null:
		player_id = hash(randi()) % 1000000000 #9 digits long
	if player_name == null:
		player_name = ""
	if player_score == null:
		player_score = 0
	if player_time == null:
		player_time = 0
	
func save_player():
	var f = FileAccess.open(save_file, FileAccess.WRITE)
	f.store_var(player_id)
	f.store_var(player_name)
	f.store_var(player_score)
	f.store_var(player_time)
	
	var info={"p_name":player_name,"time":player_time}
	SilentWolf.Scores.save_score(str(player_id),player_score,"main",info)
	#SilentWolf.Scores.save_score(player_name,player_score)

func encrypt_SilentWolf_ID():
	var key=""
	var file_name="res://addons/cache.file"
	#3rd param password = 2col1
	var f = FileAccess.open_encrypted_with_pass(file_name, FileAccess.WRITE,"")
	f.store_var(key)

func decrypt_SilentWolf_ID():
	var file_name="res://addons/cache.file"
	var f=FileAccess.open_encrypted_with_pass(file_name, FileAccess.READ,"1qaz2wsx")
	if(f!=null):
		return f.get_var()
	else:
		return ""
