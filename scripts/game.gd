extends Node2D

var srn #to hold screen size
var force #affects acceleration
var max_spd

#Generate snowball
@export var snowball: PackedScene

func _ready():
	srn=DisplayServer.screen_get_size();
	#$Player.apply_scale(Vector2(50.0,50.0))
	$Player.position=Vector2(50.0,srn.y-300)
	force=20.0
	max_spd=300.0
	
	#var dup=snowball.instantiate()
	#dup.position=Vector2(100,0)
	#add_child(dup)
	
	$Snowball_Timer.start()


func _process(delta):
	if Input.is_action_pressed("Move_Right"):
		$Player/RigidBody2D.apply_impulse(Vector2(force,0.0))
		$Player/RigidBody2D/AnimatedSprite2D.flip_h=false
	if Input.is_action_pressed("Move_Left"):
		$Player/RigidBody2D.apply_impulse(Vector2(-force,0.0))
		$Player/RigidBody2D/AnimatedSprite2D.flip_h=true
	if Input.is_action_pressed("Jump")&&$Player/RigidBody2D.linear_velocity.y>-0.2&&$Player/RigidBody2D.linear_velocity.y<10.0:
		$Player/RigidBody2D.apply_impulse(Vector2(0.0, -force*100))
		
	#cap the speed
	if $Player/RigidBody2D.linear_velocity.x>max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2(max_spd,$Player/RigidBody2D.linear_velocity.y)
	if $Player/RigidBody2D.linear_velocity.x<-max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2(-max_spd,$Player/RigidBody2D.linear_velocity.y)
	if $Player/RigidBody2D.linear_velocity.y<-max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2($Player/RigidBody2D.linear_velocity.x,-max_spd)
		
	# Bounce off walls
	#if $Player/RigidBody2D/CollisionShape2D.shape.collide(Transform2D(),$BackGround/LeftWall/CollisionShape2D.shape,Transform2D()):
	#	$Player/RigidBody2D.linear_velocity=Vector2(-$Player/RigidBody2D.linear_velocity.x   ,0.0)


func _on_snowball_timer_timeout() -> void:
	var dup=snowball.instantiate()
	dup.position=Vector2(randf_range(0,srn.x-200),0)
	add_child(dup)
