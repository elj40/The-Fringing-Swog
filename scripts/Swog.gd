extends KinematicBody2D

const GRAVITY = 300
const TONGUE_PULL = 500;

export(int) var MOVE_SPEED = 100;
export(int) var JUMP_POWER = -250;
export(float, 1) var ground_friction = 0.8;
export(int) var FRICTION_SPEED = 100;
export(int) var DAMAGE_SPEED = 100;
var direction = 1;
var dead:bool = false
var won:bool = false
var fafb:bool = false


var tongue_velocity = Vector2()
var velocity = Vector2()
func _ready():
	pass # Replace with function body.
	
			
func die():
	get_tree().change_scene("res://scenes/DesertStage.tscn")

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
	if dead or won: return;
	
	if Input.is_action_just_pressed("ui_left") and velocity.x > 0: 
		velocity.x = 0;
	if Input.is_action_just_pressed("ui_right") and velocity.x < 0:
		velocity.x = 0;
		
	var grounded = is_on_floor()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= MOVE_SPEED*delta
		direction = 1;
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_right"):
		velocity.x += MOVE_SPEED*delta
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
	fafb = velocity.length_squared() > DAMAGE_SPEED*DAMAGE_SPEED
	$AirEffect.visible = velocity.length_squared() > DAMAGE_SPEED*DAMAGE_SPEED*1.05
	
	#Friction on the ground
	if grounded and abs(velocity.x) > DAMAGE_SPEED:
		velocity.x *= ground_friction;
		
	if not grounded:
		rotate_swog()
		$AnimatedSprite.play("air")
	if Input.is_action_just_pressed("ui_accept") and grounded:
		velocity.y = JUMP_POWER
		
	#Updating the tongue
	# Hook physics
	if $Tongue.hooked:
		var target_dir = $Tongue/Tip.global_position - global_position;
		velocity += target_dir.normalized() * TONGUE_PULL * delta;
	#Open mouth when swinging
	if $Tongue.hooked or $Tongue.flying: $AnimatedSprite.play("mouth_open")
		
	#Update position and check collisions
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += GRAVITY * delta
	
	#kill enemies
	kill_enemies()
	

func kill_enemies():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var body = get_slide_collision(i).collider;
			if body.is_in_group("Enemy"):
				if fafb: body.die()
				else: die()

	
