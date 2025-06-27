extends Node2D

func _ready():
	#var srn=DisplayServer.screen_get_size()
	var srn=DisplayServer.window_get_size()
	#$Ground/CollisionShape2D.position=Vector2(0.0,srn.y-200)
	#$Ground/CollisionShape2D.position=Vector2(0.0,srn.y-10)
		
	#$Ground/CollisionShape2D.position=Vector2(0.0,100)
	$RightWall/CollisionShape2D.position=Vector2(srn.x,0.0)
	
	#display background image of the ground
	$Ground_Image.position=Vector2(0.0,$Ground_Image.texture.get_height()/2)
	#display background image above ground
	$Bottom_Image.position=Vector2(0.0,-$Bottom_Image.texture.get_height()/2)
	$Bottom_Image_2.position=Vector2(0.0,-$Bottom_Image.texture.get_height()-$Bottom_Image_2.texture.get_height()/2)
	

#if player is 1 image size above this image, move 2 image above
#to make it seems continuous
func update_pos(player_pos):
	if ($Bottom_Image.position.y-$Bottom_Image.texture.get_height())>player_pos.y:
		$Bottom_Image.position=Vector2(0.0,$Bottom_Image.position.y-$Bottom_Image_2.texture.get_height()-$Bottom_Image.texture.get_height())
	if ($Bottom_Image_2.position.y-$Bottom_Image_2.texture.get_height())>player_pos.y:
		$Bottom_Image_2.position=Vector2(0.0,$Bottom_Image_2.position.y-$Bottom_Image_2.texture.get_height()-$Bottom_Image.texture.get_height())
		
		
	
		
