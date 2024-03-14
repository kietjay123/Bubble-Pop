extends Node2D


var ballRadius = 50
var firstCast := Vector2(0,0)# Called when the node enters the scene tree for the first time.
var path : Array[Vector2]
var isPressing := false
var dragging := false
var hittedPos : Vector2 
var ammo : Array
var currentBall : Ball
var secondBall : Ball
var inProgress := false
var currentTween : Tween
var ableToSwapBall := true

@export var ballSpped : int = 1500


@onready var ballManager := $"../../Ball manager"

signal lose


func _ready():
	ammo = LevelCrud.ammo
	initCurrentBall()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	if !inProgress :
		var mousePos : Vector2
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			mousePos = event.position
			if event.pressed:
				dragging = true
			elif dragging :
				releaseBall(mousePos)
		if event is InputEventMouseMotion and dragging:
			var _result = caculateBallTrajectory(event.position)


func releaseBall(mousePos : Vector2) -> void :
	ableToSwapBall = false
	shoot(mousePos)
	await currentBall.collided
	updateCurrentBall()
	ableToSwapBall = true


#caculate path for ball tweening
func caculateBallTrajectory(delta : Vector2) -> Array[Vector2] :
	var hittedSideWall := false
	path.clear()
	path.append(global_position)
	var normal : Vector2
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, to_global((delta - position).normalized() * 1920), 0x7FFFFFFF, [])
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var result = space_state.intersect_ray(query)
	normal = result["normal"]
	path.append(result["position"])
	firstCast = to_global((delta - position).normalized() * 1920)
	if (result["collider"].name == "Left border" || result["collider"].name == "Right border") :
		hittedSideWall = true
	elif (result["collider"].name == "Top border" || result["collider"].name == "Bottom border") :
		hittedSideWall = false
	else :
		hittedSideWall = false
		hittedPos = result["position"]
	
	while (hittedSideWall) :
		var end : = to_global(((path[path.size() - 1] - path[path.size() - 2]).bounce(normal)).normalized() * 1920 + to_local(path[path.size() - 1]))
		var start : Vector2 = lerp(path[path.size() - 1], end, 0.0005)
		
		var query2 = PhysicsRayQueryParameters2D.create(start, end, 0x7FFFFFFF, [])
		query2.collide_with_areas = true
		query2.collide_with_bodies = false
		var result2 = space_state.intersect_ray(query2)
		path.append(result2["position"])
		normal = result2["normal"]
		if (result2["collider"].name == "Left border" || result2["collider"].name == "Right border") :
			hittedSideWall = true
		elif (result2["collider"].name == "Top border" || result2["collider"].name == "Bottom border") :
			hittedSideWall = false
		else :
			hittedSideWall = false
			hittedPos = result2["position"]
	queue_redraw()
	
	return path




func _draw():
	if ( path.size() >= 2 ):
		draw_polyline(toLocal(path), Color.RED, 5)
		pass
	pass

func toLocal(pPath : Array) -> Array :
	var result : Array = []
	for i in pPath :
		result.append(to_local(i))
	return result


func shoot(MousePos : Vector2) -> void :
	inProgress = true
	var shootingBall := currentBall
	shootingBall.isShooting = true
	var positions : Array[Vector2]  = caculateBallTrajectory(MousePos)
	for i in positions.size() :
		var tween = create_tween()
		currentTween = tween
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		var from : Vector2 = positions[i]
		var to : Vector2 = positions[ (i + 1) % positions.size() ]
		tween.tween_property(shootingBall, "position", to_local(to), (to - from).length() / ballSpped)
		await tween.finished





#for shooting
func updateCurrentBall() -> void :
	ammo.pop_front()
	if ammo.size() == 1 :
		currentBall = secondBall
		currentBall.position = Vector2.ZERO
	elif ammo.size() == 0 : 
		emit_signal("lose")
	else :
		currentBall = secondBall
		currentBall.position = Vector2.ZERO
		secondBall = ballManager.createBall(ammo[0])
		call_deferred("add_child", secondBall)
		secondBall.position += Vector2(200, 0)
		secondBall.collided.connect(onShootingBallCollided)



func initCurrentBall() -> void :
	if ammo.size() == 1 :
		currentBall = ballManager.createBall(ammo[0])
		add_child(currentBall)
		currentBall.collided.connect(onShootingBallCollided)
	elif ammo.size() == 0 : 
		emit_signal("lose")
	else  :
		currentBall = ballManager.createBall(ammo[0])
		add_child(currentBall)
		currentBall.collided.connect(onShootingBallCollided)
		secondBall = ballManager.createBall(ammo[1])
		add_child(secondBall)
		secondBall.position += Vector2(200, 0)
		secondBall.collided.connect(onShootingBallCollided)


func onShootingBallCollided(ball : Ball) -> void :
	ball.isShooting = false
	inProgress = false
	currentTween.stop()
	call_deferred("remove_child", ball)
	ballManager.call_deferred("add_child", ball)
	ballManager.snapGunBall(ball)


func _on_swap_ball_pressed():
	if ableToSwapBall :
		var swapBall = ammo[1]
		ammo.push_front(swapBall)
		ammo.remove_at(2)
		var tempBall = secondBall
		secondBall = currentBall
		secondBall.position += Vector2(200, 0)
		currentBall = tempBall
		currentBall.position -= Vector2(200, 0)


func addBallToAmmo(type : int) -> void :
	print(type)
	ammo.push_front(type)
	
	secondBall.queue_free()
	secondBall = currentBall
	secondBall.position += Vector2(200, 0)
	currentBall = ballManager.createBall(ammo[0])
	add_child(currentBall)
	currentBall.collided.connect(onShootingBallCollided)





