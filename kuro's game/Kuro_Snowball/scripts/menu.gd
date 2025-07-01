extends Node2D

var srn

func _ready():
	srn=DisplayServer.window_get_size()
	
	var h=$Sprite2D.texture.get_height()
	var w=$Sprite2D.texture.get_width()
	
	var h_ratio = 2.0/3*srn.y/h
	var w_ratio = 2.5/3*srn.x/w

	$Sprite2D.scale=Vector2(w_ratio,h_ratio)
	$Sprite2D.position=Vector2(srn.x/2,srn.y/2)

	$Sprite2D/New_Game_Button.scale=Vector2(5.0,3.5)
	$Sprite2D/New_Game_Button.position=Vector2(-$Sprite2D/New_Game_Button.texture_normal.get_width()*5.0/2, -h/2.0+$Sprite2D/New_Game_Button.texture_normal.get_height()*3.5)
	$Sprite2D/New_Game_Button/Label.position=Vector2(($Sprite2D/New_Game_Button.texture_normal.get_width()-$Sprite2D/New_Game_Button/Label.size.x)/2 , ($Sprite2D/New_Game_Button.texture_normal.get_height()-$Sprite2D/New_Game_Button/Label.size.y)/2)
	
	#debug info
	#$Label.text=str(srn.y)
	#$Label.text+="\n"+str(h)
	#$Label.text+="\n"+str(2.0/3*srn.y/h)
	
