extends Node2D

@export var cliff_a: PackedScene
@export var cliff_b: PackedScene
@export var cliff_c: PackedScene
@export var cliff_d: PackedScene
@export var cliff_e: PackedScene
@export var cliff_f: PackedScene


func add_obstacle(item,pos,flip):
	var dup
	
	if(item==1):
		dup=cliff_a.instantiate()
	elif(item==2):
		dup=cliff_b.instantiate()
	elif(item==3):
		dup=cliff_c.instantiate()
	elif(item==4):
		dup=cliff_d.instantiate()
	elif(item==5):
		dup=cliff_e.instantiate()
	elif(item==6):
		dup=cliff_f.instantiate()
		
	var cliff_height=dup.find_child("StaticBody2D").find_child("Sprite2D").texture.get_height()
	
	var rescale = 2.7/10*Globals.srn.x/cliff_height
	dup.rotation_degrees=90.0
	dup.position+=pos
	#shift half the height from 0,0 with scaling
	#if flip x axis, since rotated, is x position shift and y position scale
	if(flip):
		dup.position+=Vector2(-cliff_height*rescale/2,0.0)
		dup.scale=Vector2(rescale,-rescale)
	else:
		dup.position+=Vector2(cliff_height*rescale/2,0.0)
		dup.scale=Vector2(rescale,rescale)
	
	add_child(dup)
