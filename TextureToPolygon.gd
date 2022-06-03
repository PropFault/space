tool
extends CollisionPolygon2D
export(Texture) var tex

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func isSimilar(pixel1, pixel2, tolerance):
	return abs(pixel1.to_rgba32() - pixel2.to_rgba32()) < tolerance

var points = []
func randomWalk(x, y, image):
	var alphaPixel = Color(0,0,0,1)
	var readPixel = alphaPixel
	var cursor = Vector2(x,y)
	var width = image.get_width()
	var height = image.get_height()
	var center = Vector2(width/2, height/2)
	var rng = RandomNumberGenerator.new()
	image.lock()
	while(isSimilar(readPixel, alphaPixel, 600)):
		var move = Vector2(min(rng.randi_range(-1,3),1), min(rng.randi_range(-1,3),1)).rotated(PI/2)
		var angle = (cursor-center).angle_to_point(center)
		move = move.rotated(-angle)
		cursor = cursor + move
		cursor = Vector2(clamp(cursor.x, 0, width), clamp(cursor.y, 0, height))
		readPixel = image.get_pixelv(cursor)
	image.unlock()
	return Vector2(cursor.x - width/2, cursor.y - height/2)
func generate_points():
	var image = tex.get_data()
	var width = image.get_width()
	var height = image.get_height()
	var points = []
	for x in range(0, width,1):
		points.append(randomWalk(x,0,image))
	for y in range(0, height,1):
		points.append(randomWalk(width,y,image))
	for x in range(0, width,1):
		points.append(randomWalk(width-x,height-1,image))
	for y in range(0,height,1):
		points.append(randomWalk(0,height-y,image))
	return points
func generate():
	
	points = []
	points = generate_points()
	var first = points[0]
	var i = 0
	while(i < points.size()):
		var j = 0
		while(j < points.size()):
			if(points[i] == points[j] and i != j):
				points.remove(j)
			else:
				j = j+1
		i = i + 1
	var ordered = []
	i = 0
	var rng = RandomNumberGenerator.new()
	while(points.size() > 0):
		var j = 0
		var f = rng.randi_range(0, points.size() - 1)
		while(j < points.size()):
			if(points[j].distance_to(points[i]) < points[f].distance_to(points[i]) and j != i):
				f = j
			j = j + 1
		ordered.append(points[i])
		points.remove(i)
		if f > i:
			f = f - 1
		i = f
	self.polygon = ordered

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()


func _process(delta):
	if(self.polygon.size() == 0):
		generate()

#func _draw():
#	
#	var woundPoints = []
#	var origin = Vector2(0,0)
#	var angle = 0
#	var base = Vector2(32/2.0,0)
#	var step = PI / 1000
#	while(angle < 2*PI):
#		var point = Vector2(base.x * cos(angle) - base.y * sin(angle),
#							base.y * cos(angle) + base.x * sin(angle))
#		
#		draw_line(origin, point, Color.red)
#		angle = angle + step
#
