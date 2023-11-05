extends KinematicBody2D

const GRAVITY = 300
const TONGUE_PULL = 500;

export(int) var move_speed = 100;
export(int) var jump_power = -200;
export(int) var DAMAGE_SPEED = 500;
var direction = 1;


var tongue_velocity = Vector2()
var velocity = Vector2()
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed( 1 ):
			#$Tongue.shoot(event.position -get_viewport().size*0.5)
			pass
		else:
			#$Tongue.release()
			pass

func rotate_swog():
	var velocity_dir = atan2(velocity.y, velocity.x)
	var sprite_dir = velocity_dir+PI
	if direction == -1:
		sprite_dir= velocity_dir
	$AirEffect.set_rotation(sprite_dir)
	if $Tongue.hooked:
		var target_dir = $Tongue/Tip.global_position - global_position;
		sprite_dir = atan2(target_dir.y, target_dir.x) + PI
		if direction == -1:
			sprite_dir = atan2(target_dir.y, target_dir.x)
	$AnimatedSprite.set_rotation(sprite_dir)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		velocity.x = 0;
		
	var grounded = is_on_floor()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= move_speed*delta
		direction = 1;
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_right"):
		velocity.x += move_speed*delta
		direction = -1
		$AnimatedSprite.play("run")
	elif grounded:
		$AnimatedSprite.play("idle")
		velocity.x = 0
		

		
	if velocity.x > 0: 
		direction = -1 
	else: 
		direction = 1
	$AnimatedSprite.flip_h = direction == -1;
	$AnimatedSprite.set_rotation(0)
	
	$AirEffect.flip_h = direction == -1;
	$AirEffect.set_rotation(0)
	$AirEffect.visible = velocity.length_squared() > DAMAGE_SPEED*DAMAGE_SPEED

	if not grounded:
		rotate_swog()
		$AnimatedSprite.play("air")
	if Input.is_action_just_pressed("ui_accept") and grounded:
		velocity.y = jump_power
		
		# Hook physics
	if $Tongue.hooked:
		var target_dir = $Tongue/Tip.global_position - global_position;
		velocity += target_dir.normalized() * TONGUE_PULL * delta;
		
	if $Tongue.hooked or $Tongue.flying: $AnimatedSprite.play("mouth_open")
		
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += GRAVITY * delta
	

	
	
	
