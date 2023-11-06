extends KinematicBody2D

export(int) var move_speed: int = 3000;
export(int) var direction: int = 1;
var dead : bool = false;

var velocity: Vector2 = Vector2();
const GRAVITY = 300;

func _physics_process(delta):
	if dead: return;
	
	if is_on_wall():
		direction *= -1;
	$AnimatedSprite.flip_h = direction == 1;
	$AnimatedSprite.play("run")
	
	velocity.x = move_speed*direction*delta;
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if $RayCast2D.is_colliding() == false:
		direction *= -1
		$RayCast2D.position.x *= -1
		
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var body = get_slide_collision(i).collider;
			if "Swog" in body.name:
				if body.fafb: die()
				else: body.die()
			


func die():
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.play("dead")
	$Timer.start()


func _on_Timer_timeout():
	queue_free()

 
