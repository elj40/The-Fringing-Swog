extends KinematicBody2D

const GRAVITY = 300
const TONGUE_PULL = 105

export(int) var move_speed = 4000;
export(int) var jump_power = -200;
var direction = 1;


var tongue_velocity = Vector2()
var velocity = Vector2()
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed( 1 ):
			$Tongue.shoot(event.position - get_viewport().size*0.5)
		else:
			$Tongue.release()

func rotate_swog():
	var velocity_dir = atan2(velocity.y, velocity.x)
	var sprite_dir = velocity_dir+PI
	if direction == -1:
		sprite_dir= velocity_dir
	$AnimatedSprite.set_rotation(sprite_dir)

func _physics_process(delta):
	velocity.x = 0
	var grounded = is_on_floor()
	if Input.is_action_pressed("ui_left"):
		velocity.x = -move_speed*delta
		direction = 1;
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_right"):
		velocity.x = move_speed*delta
		direction = -1
		$AnimatedSprite.play("run")
	elif grounded:
		$AnimatedSprite.play("idle")
	
	$AnimatedSprite.flip_h = direction == -1;
	$AnimatedSprite.set_rotation(0)
	
	# Hook physics
	if $Tongue.hooked:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		tongue_velocity = to_local($Tongue.tip).normalized() * TONGUE_PULL
		if tongue_velocity.y > 0:
			# Pulling down isn't as strong
			tongue_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			tongue_velocity.y *= 1.65
		if sign(tongue_velocity.x) != sign(direction):
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			tongue_velocity.x *= 0.7
	else:
		# Not hooked -> no chain velocity
		tongue_velocity = Vector2(0,0)
	velocity += tongue_velocity

	
	if not grounded:
		rotate_swog()
		$AnimatedSprite.play("air")
	if Input.is_action_just_pressed("ui_accept") and grounded:
		velocity.y = jump_power
		
	
		
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += GRAVITY * delta
	

	
	
	
