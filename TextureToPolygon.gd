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
	var cursorX = x
	var cursorY = y
	var width = image.get_width()
	var height = image.get_height()
	var rng = RandomNumberGenerator.new()
	image.lock()
	while(isSimilar(readPixel, alphaPixel, 1000)):
		cursorY = clamp(cursorY +min(rng.randi_range(-1,3),1), 0, height-1)
		cursorX = clamp(cursorX +min(rng.randi_range(-1,3),1), 0, width-1)
		readPixel = image.get_pixel(cursorX, cursorY)
	image.unlock()
	return Vector2(cursorX - width/2, cursorY - height/2)
func generate():
	var image = tex.get_data()
	var width = image.get_width()
	var height = image.get_height()
	points = []
	for x in range(0, width-1,2):
		points.append(randomWalk(x,0,image))
	for y in range(0, height-1,2):
		points.append(randomWalk(0,y,image))
	for x in range(0, width-1,2):
		points.append(randomWalk(x,height-1,image))
	for y in range(0, height-1,2):
		points.append(randomWalk(width-1,y,image))
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
	# sort points by winding
	var woundPoints = []
	var origin = Vector2(width/2.0, height/2.0)
	var angle = 0
	var base = origin + Vector2(width/2, 0)
	var step = PI / 1000
	while(angle < 2*PI):
		var point = Vector2(base.x * cos(angle) - base.y * sin(angle),
							base.y * cos(angle) + base.x * sin(angle))
		draw_line(origin, point, Color.red)
		angle = angle + step
	self.polygon = points

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
