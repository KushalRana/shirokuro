extends Node2D

var srn #to hold screen size
var force #affects acceleration
var max_spd

#Joystick position
var srn_x
var srn_y
#if is press and drag
var joystick_on
var base_pos
var dir

var camera_y_start
var camera_y_displaced
var camera_shift_interval

#Generate snowball
@export var snowball: PackedScene

func _ready():
	#srn=DisplayServer.screen_get_size()
	srn=DisplayServer.window_get_size()
	#$Player.apply_scale(Vector2(50.0,50.0))
	#$Player.position=Vector2(50.0,srn.y-10)
	$Player.position=Vector2(50.0,-10)
	
	force=20.0
	max_spd=300.0
	$Player/RigidBody2D.contact_monitor=true
	$Player/RigidBody2D.max_contacts_reported=20; 
	
	#var dup=snowball.instantiate()
	#dup.position=Vector2(100,0)
	#add_child(dup)
	
	$Snowball_Timer.start()
	
	srn_x=srn.x/2
	srn_y=srn.y/2
	joystick_on=false
	base_pos = Vector2(0,0)
	dir=0
	
	#Start camera abit lower so ground can be seen
	camera_y_start = srn.y-20.0
	#camera_y_displaced = 0.0
	camera_shift_interval = 100
	#self.position=Vector2(0.0,camera_y_start)
	$Camera2D.position=Vector2(srn.x/2,-camera_y_start/2)
	
	#$JumpButton.position=Vector2(srn.x-10-$JumpButton.shape.radius,srn.y-10-$JumpButton.shape.radius)
	$JumpButton.position=Vector2(srn.x-10-$JumpButton.shape.radius,srn.y-10-camera_y_start-$JumpButton.shape.radius)

func _process(delta):
	#keyboard handle
	if Input.is_action_pressed("Move_Right"):
		move_right()
	if Input.is_action_pressed("Move_Left"):
		move_left()

	if Input.is_action_pressed("Jump"):
		if $Player/RigidBody2D.get_colliding_bodies().size()>0 && $Player/RigidBody2D.get_colliding_bodies()[0].name!="LeftWall" && $Player/RigidBody2D.get_colliding_bodies()[0].name!="RightWall":
			jump()
		elif $Player/RigidBody2D.get_colliding_bodies().size()>1:
			jump()
		
	#Joystick handle
	if dir>0:
		move_right()
	elif dir<0:
		move_left()
		
	# Slide off walls
	$Player/RigidBody2D.apply_impulse(Vector2(0.0,0.1))
	
	#cap the speed
	cap_spd()
	
	#Screen movement
	#if $Player/RigidBody2D.global_position.y < ($Camera2D.offset.y-camera_shift_interval*2):
	#if $Player/RigidBody2D.position.y < (-camera_shift_interval*2):
	if $Player/RigidBody2D.position.y < ($Camera2D.offset.y-camera_shift_interval*3   ):
		#$Camera2D.position=Vector2(srn.x/2,-$Camera2D.position.y-200)
		$Camera2D.offset=Vector2(0.0,$Camera2D.offset.y-camera_shift_interval/2)
		$JumpButton.position=Vector2(srn.x-10-$JumpButton.shape.radius,srn.y-10-camera_y_start-$JumpButton.shape.radius+$Camera2D.offset.y)
	
func _on_snowball_timer_timeout() -> void:
	var dup=snowball.instantiate()
	#dup.position=Vector2(randf_range(0,srn.x-200),0)
	dup.position=Vector2(randf_range(0,srn.x),-camera_y_start+$Camera2D.offset.y)
	add_child(dup)
	
#Handling joystick
func _input(event):
	#if screen touched
	if event is InputEventScreenTouch:
		#And is pressed at bottom left (can fine tune location)
		if event.is_released():
			joystick_on=false
			base_pos=Vector2(0.0,0.0)
			dir=0
		elif event.is_pressed() && event.position.x<srn_x && event.position.y>srn_y:
			#the joystick is pressed on and start point is recorded
			joystick_on=true
			base_pos=event.position
		#else turn joystick off just in case
		else:
			joystick_on=false
			base_pos=Vector2(0.0,0.0)
			dir=0
	#if is screen drag
	elif event is InputEventScreenDrag:
		#if joystick is on then act on it
		if joystick_on == true:
			#The action here is to apply force in the direction but can be other logics
			dir=event.position.x-base_pos.x
			if dir>0:
				move_right()
			elif dir<0:
				move_left()
			
func move_right():
	$Player/RigidBody2D.apply_impulse(Vector2(force,0.0))
	$Player/RigidBody2D/AnimatedSprite2D.flip_h=false
		
func move_left():
	$Player/RigidBody2D.apply_impulse(Vector2(-force,0.0))
	$Player/RigidBody2D/AnimatedSprite2D.flip_h=true
		
func jump():
	$Player/RigidBody2D.apply_impulse(Vector2(0.0, -force*70))
	
func cap_spd():
#cap the speed
	if $Player/RigidBody2D.linear_velocity.x>max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2(max_spd,$Player/RigidBody2D.linear_velocity.y)
	if $Player/RigidBody2D.linear_velocity.x<-max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2(-max_spd,$Player/RigidBody2D.linear_velocity.y)
	if $Player/RigidBody2D.linear_velocity.y<-max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2($Player/RigidBody2D.linear_velocity.x,-max_spd)
