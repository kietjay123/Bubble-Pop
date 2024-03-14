extends Node


var gridSize : float = 100
var startPos := Vector2(50,50)


signal win


var neighboorPosRelative := [
	[Vector2(0, 1), Vector2(1, 0), Vector2(-1, 0), Vector2(-1, 1)],
	[Vector2(1, 1), Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1)]
	]

var neighboroffset : Array = [
	[Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1), Vector2(-1, 1), Vector2(-1, -1)],
	[Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1), Vector2(1, 1), Vector2(1, -1)]
]


var objectMap : Array
var horizontalSize : int 

signal onBallsDestroyed
signal moveCam



func _ready() :
	import(LevelCrud.map, LevelCrud.levelSize)


func instanciateBall(map : Array) -> Array:
	var ball : Ball
	for i in map.size() :
		for ii in map[i].size():
			if(map[i][ii] == null):
				pass
			else :
				ball = createBall(map[i][ii][0], Vector2(ii, i))
				add_child(ball)
				map[i][ii].push_front(ball)
				ball.position = getTileCoord(Vector2(ii, i))
	return map


func getTileCoord( pos : Vector2) -> Vector2 :
	var tileX = pos.x * gridSize
	if (int(pos.y) % 2) :
		tileX += gridSize/2
	var tileY = pos.y * gridSize
	return Vector2(tileX, tileY) + Vector2(gridSize / 2, gridSize / 2)


func createBall(ballType, pos : Vector2 = Vector2.ZERO) -> Ball:
	var ball 
	match int(ballType) :
		Ball.Type.red :
			ball = RedBall.new()
		Ball.Type.green :
			ball = GreenBall.new()
		Ball.Type.blue :
			ball = BlueBall.new()
		Ball.Type.bomb :
			ball = Bomb.new()
		Ball.Type.rocket :
			ball = Rocket.new()
		Ball.Type.rainbow :
			ball = Rainbow.new()
		Ball.Type.laser :
			ball = Laser.new()
		Ball.Type.rock :
			ball = Rock.new()
		_ :
			print("fuck you")
	ball.pos = pos
	ball.set_scale(Vector2(gridSize, gridSize) / (ball.texture.get_size()))
	return ball


func addBall(ballType, pos : Vector2) -> Ball :
	var ball : Ball = createBall(ballType, pos)
	call_deferred("add_child", ball)
	objectMap[pos.y][pos.x] = [ball, ballType]
	ball.position = getTileCoord(pos)
	return ball




func deleteBall(pos : Array) :
	for i in pos :
		objectMap[i.y][i.x][0].queue_free()
		objectMap[i.y][i.x] = null
	updateScore(pos)

func updateScore(pos : Array) -> void :
	emit_signal("onBallsDestroyed", pos)


func normalHitted(pos : Vector2) -> void :
	floodFillAlgoDelete(pos, objectMap[pos.y][pos.x][1])
	floodFillAlgoCheck()

func bombHitted(_pos : Vector2) -> void :
	pass


func floodFillAlgoDelete(startingPos : Vector2, type = Ball.Type.blue) -> void  :
	var result : Array = []
	var queue : Array = []
	queue.push_front(startingPos)
	var pos : Vector2
	while  !queue.is_empty():
		pos = queue.pop_back()
		if (objectMap[pos.y][pos.x] == null  || objectMap[pos.y][pos.x][1] != type ):
			continue
		else :
			result.append(pos)
			objectMap[pos.y][pos.x][1] = 99
			
			for i in neighboroffset[int(pos.y) % 2] :
				queue.push_front(pos + i)
	#print(result)
	if result.size() < 3 :
		for i in result :
			objectMap[i.y][i.x][1] = type
		return
	deleteBall(result)



#check for disconnected island by running flood fill algo for every root node
func floodFillAlgoCheck() -> void  :
	var remain : Array = []
	var rootBubble : Array = []
	for i in objectMap[0]:
		if i != null :
			rootBubble.append(i[0].pos)
	var dup := objectMap.duplicate(true)
	
	
	for i in rootBubble :
		var queue : Array = []
		queue.push_front(i)
		while  !queue.is_empty():
			var pos : Vector2 = queue.pop_back()
			if (dup[pos.y][pos.x] == null) :
				continue
			else :
				if dup[pos.y][pos.x].size() > 2 :
					continue
					
				dup[pos.y][pos.x].append(1)
				remain.append(pos)
				
				for ii in neighboroffset[int(pos.y) % 2] :
					queue.push_front(pos + ii)
	
	if remain.size() == 0 :
		emit_signal("win")
	
	var result := ballPosList()
	
	for i in remain :
		result.erase(i)
	deleteBall(result)
	
	#debugging stuff
	#for i in dup.size() :
		#print(str(i) + " : "+ str(dup[i]))
	#print(remain)


func ballPosList() -> Array:
	var result : Array = []
	for i in objectMap.size() :
		for ii in objectMap[i].size() :
			if objectMap[i][ii] != null :
				result.append(Vector2(ii, i))
	return result




func import( map : Array , mapSize : int ) -> void :
	if !map.size() :
		objectMap = instanciateBall([])
		return
	horizontalSize = mapSize
	gridSize  = floor(ProjectSettings.get_setting("display/window/size/viewport_width") / horizontalSize)
	var dup = map.duplicate(true)
	for i in dup :
		i.append(null)
	for i in 50 :
		var nArray := []
		nArray.resize(dup[0].size())
		dup.append(nArray)
	objectMap = instanciateBall(dup)


func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed() :
		if event.keycode == KEY_1 :
			for i in objectMap :
				pass


func moveCamera() -> void :
	var record : int = 0
	var array := ballPosList()
	for i in array :
		if i.y > record :
			record = i.y
	emit_signal("moveCam", record)


func snapGunBall(ball : Ball) -> void :
	var replacmentBall = addBall(ball.ballType, getBallPos(ball.get_parent().to_global(ball.position)))
	ball.queue_free()
	match ball.ballType :
		Ball.Type.red, Ball.Type.green, Ball.Type.blue :
			normalHitted(replacmentBall.pos)
		Ball.Type.bomb :
			print("bomb")
		Ball.Type.rocket:
			print("rocket")
		Ball.Type.rainbow:
			print("rainbow")
		Ball.Type.laser:
			print("laser")
		_:
			print("fkc")
	
	moveCamera()




func getBallPos(ballPos : Vector2 ) -> Vector2 :
	var columm : int = floor(ballPos.y / gridSize)
	var row  : int
	if columm % 2 == 1 :
		row = clamp(abs(((ballPos.x - (gridSize / 2)) / gridSize)), 0, horizontalSize - 2)
	else : # including 0
		row = clamp(floor(ballPos.x / gridSize), 0, horizontalSize - 1)
	return Vector2(row, columm)




