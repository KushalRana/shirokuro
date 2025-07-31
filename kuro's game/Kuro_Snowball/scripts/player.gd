extends Node2D

var player_scale=-1

func _ready():
	$RigidBody2D.set_lock_rotation_enabled(true)
	$RigidBody2D/AnimatedSprite2D.play("idle")
	#$RigidBody2D.position=Vector2(10,srn.y-10)
	#$RigidBody2D.position=Vector2(50,0)
	#$RigidBody2D/CollisionShape2D.scale=Vector2(0.25,0.25)
	#$RigidBody2D/AnimatedSprite2D.scale=Vector2(0.25,0.25)
	#$RigidBody2D.scale=Vector2(5.0,5.0)
	
	player_scale=1.0/8*Globals.srn.x/($RigidBody2D/CollisionShape2D.shape.radius * 2.0)
	$RigidBody2D/CollisionShape2D.scale=Vector2(player_scale,player_scale)
	$RigidBody2D/AnimatedSprite2D.scale=Vector2(player_scale,player_scale)
	$RigidBody2D/CollisionShape2D.position*=Vector2(player_scale,player_scale)
	#$RigidBody2D.gravity_scale*=player_scale
	#$RigidBody2D.mass*=player_scale
	#$RigidBody2D.linear_damp*=player_scale

func _process(_delta):
	if $RigidBody2D.linear_velocity.length()<1 :
		$RigidBody2D/AnimatedSprite2D.play("idle")
	else:
		$RigidBody2D/AnimatedSprite2D.play("walk")
