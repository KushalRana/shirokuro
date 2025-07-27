extends Node2D

func _ready():
	
	var h=$Sprite2D.texture.get_height()
	var w=$Sprite2D.texture.get_width()
	
	var h_ratio = 2.0/7*Globals.srn.y/h
	var w_ratio = 2.5/3*Globals.srn.x/w
	
	if h_ratio<w_ratio:
		w_ratio=h_ratio
	else:
		h_ratio=w_ratio

	$Sprite2D.scale=Vector2(w_ratio,h_ratio)
	$Sprite2D.position=Vector2(Globals.srn.x/2,Globals.srn.y/2)

	var button_scale_x = 3.0/8 * w / $Sprite2D/Game_Over_Button.texture_normal.get_width()
	var button_scale_y =  2.0/8 * h / $Sprite2D/Game_Over_Button.texture_normal.get_height()
	$Sprite2D/Game_Over_Button.scale=Vector2(button_scale_x,button_scale_y)
	
	#$Sprite2D/Game_Over_Button.position=Vector2(-$Sprite2D/Game_Over_Button.texture_normal.get_width()*button_scale_x/2, -$Sprite2D/Game_Over_Button.texture_normal.get_height()*button_scale_y/2)
	$Sprite2D/Game_Over_Button.position=Vector2($Sprite2D/Game_Over_Button.texture_normal.get_width()*button_scale_x/4, $Sprite2D/Game_Over_Button.texture_normal.get_height()*button_scale_y*3/4)
	$Sprite2D/Game_Over_Button/Label.position=Vector2(($Sprite2D/Game_Over_Button.texture_normal.get_width()-$Sprite2D/Game_Over_Button/Label.size.x)/2 , ($Sprite2D/Game_Over_Button.texture_normal.get_height()-$Sprite2D/Game_Over_Button/Label.size.y)/2)
	
	$Sprite2D/Game_Over_Text.position=Vector2(-w/2.0,-h/2.0)
	$Sprite2D/Game_Over_Text.text+="\nMax Height: "+str(Globals.cur_score)
	$Sprite2D/Game_Over_Text.text+="\nSurvival Time: "+str(Globals.cur_time)
	$Sprite2D/Game_Over_Text.text+="\nPlayer: "
	
	#$Sprite2D/Name_Input.position==Vector2(-w/2.0,-h/2.0)
	#$Sprite2D/Name_Input.position==Vector2(-100.0,0.0)
	$Sprite2D/Name_Input.position=Vector2(-w/2.0,h/2.0-$Sprite2D/Name_Input.get_rect().size.y-5)
	$Sprite2D/Name_Input.text=Globals.player_name
	
	$Sprite2D/Name_Input.grab_focus()
	
	$Sprite2D/Name_Input/focus_name_input.position=Vector2($Sprite2D/Name_Input.get_rect().size.x/2,$Sprite2D/Name_Input.get_rect().size.y/2)
	$Sprite2D/Name_Input/focus_name_input.shape.size=Vector2($Sprite2D/Name_Input.get_rect().size.x,$Sprite2D/Name_Input.get_rect().size.y)
	$Sprite2D/Name_Input/Name_Input_Left.scale=Vector2($Sprite2D/Name_Input.get_rect().size.x/$Sprite2D/Name_Input/Name_Input_Left.texture_normal.get_width()/3.0,$Sprite2D/Name_Input.get_rect().size.y/$Sprite2D/Name_Input/Name_Input_Left.texture_normal.get_height())
	$Sprite2D/Name_Input/Name_Input_Left.position=Vector2($Sprite2D/Name_Input.get_rect().size.x+$Sprite2D/Name_Input/Name_Input_Left.texture_normal.get_width()*$Sprite2D/Name_Input/Name_Input_Left.scale.x,$Sprite2D/Name_Input.get_rect().size.y)
	$Sprite2D/Name_Input/Name_Input_Right.scale=Vector2(-$Sprite2D/Name_Input/Name_Input_Left.scale.x,$Sprite2D/Name_Input/Name_Input_Left.scale.y)
	$Sprite2D/Name_Input/Name_Input_Right.position=Vector2(5.0+$Sprite2D/Name_Input/Name_Input_Left.position.x,$Sprite2D/Name_Input/Name_Input_Left.position.y)


func _on_name_input_text_changed(new_text: String) -> void:
	Globals.player_name=$Sprite2D/Name_Input.text

func _on_focus_name_input_pressed() -> void:
	if $Sprite2D/Name_Input.has_focus():
		$Sprite2D/Name_Input.release_focus()
	$Sprite2D/Name_Input.grab_focus()

func _on_name_input_left_pressed() -> void:
	$Sprite2D/Name_Input.caret_column=max($Sprite2D/Name_Input.caret_column-1,0)


func _on_name_input_right_pressed() -> void:
	$Sprite2D/Name_Input.caret_column=min($Sprite2D/Name_Input.caret_column+1,len($Sprite2D/Name_Input.text))
