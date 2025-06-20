extends Node2D

func _ready():
	var srn=DisplayServer.screen_get_size()
	$Ground/CollisionShape2D.position=Vector2(0.0,srn.y-200)
	#$Ground/CollisionShape2D.position=Vector2(0.0,100)
	$RightWall/CollisionShape2D.position=Vector2(srn.y,0.0)
