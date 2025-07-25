extends Node2D

var base_height
var img_height
var img_height_2

var img_scale=1.0

func _ready():
	$RightWall/CollisionShape2D.position=Vector2(Globals.srn.x,0.0)
	
	#display background image of the ground
	$Ground_Image.position=Vector2(0.0,$Ground_Image.texture.get_height()/2)
	#display background image above ground
	base_height=$Base_Image.texture.get_height()
	img_height=$Bottom_Image.texture.get_height()
	img_height_2=$Bottom_Image_2.texture.get_height()
	$Base_Image.position=Vector2(0.0,-base_height/2)
	#Behind so can fade out the mountain anytime
	$Bottom_Image.position=Vector2(0.0,-img_height/2)
	$Bottom_Image_2.position=Vector2(0.0,-img_height-img_height_2/2)
	
func change_scale(sc):
	img_scale=sc
	$Ground_Image.scale=Vector2(img_scale,img_scale)
	#display background image of the ground
	$Ground_Image.position=Vector2(0.0,img_scale*$Ground_Image.texture.get_height()/2)
	
	$Base_Image.scale=Vector2(img_scale,img_scale)
	$Bottom_Image.scale=Vector2(img_scale,img_scale)
	$Bottom_Image_2.scale=Vector2(img_scale,img_scale)
	#display background image above ground
	base_height=$Base_Image.texture.get_height()*img_scale
	img_height=$Bottom_Image.texture.get_height()*img_scale
	img_height_2=$Bottom_Image_2.texture.get_height()*img_scale
	$Base_Image.position=Vector2(0.0,-base_height/2)
	#Behind so can fade out the mountain anytime
	$Bottom_Image.position=Vector2(0.0,-img_height/2)
	$Bottom_Image_2.position=Vector2(0.0,-img_height-img_height_2/2)

#if player is 1 image size above this image, move 2 image above
#to make it seems continuous (added overlapping)
func update_pos(player_pos):
	if ($Bottom_Image.position.y-img_height)>player_pos.y:
		$Bottom_Image.position=Vector2(0.0,$Bottom_Image_2.position.y-img_height_2/2-img_height/2+10)
	if ($Bottom_Image_2.position.y-img_height_2)>player_pos.y:
		$Bottom_Image_2.position=Vector2(0.0,$Bottom_Image.position.y-img_height_2/2-img_height/2+10)
	#Start to fade out mountain when 1 srn height left
	var fade_base=player_pos.y+img_height
	if fade_base>0 && fade_base<Globals.srn.y:
		$Base_Image.modulate.a=1.0*fade_base/Globals.srn.y

		
		
	
		
