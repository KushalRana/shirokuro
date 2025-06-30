extends Node2D

func _ready():
	$RigidBody2D.set_lock_rotation_enabled(true)
	$RigidBody2D/AnimatedSprite2D.play("walk")
	#$RigidBody2D.position=Vector2(10,srn.y-10)
	#$RigidBody2D.position=Vector2(50,0)
	#$RigidBody2D/CollisionShape2D.scale=Vector2(0.25,0.25)
	#$RigidBody2D/AnimatedSprite2D.scale=Vector2(0.25,0.25)
	#$RigidBody2D.scale=Vector2(5.0,5.0)
