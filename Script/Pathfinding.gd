extends Node2D
class_name Pathfinding

var astar = AStar2D.new()
var tilemap: TileMap
var halfCellSize: Vector2
var usedRect: Rect2


func _physics_process(delta):
	update_navi_map()


func create_navi_map(tilemap):
	self.tilemap = tilemap
	
	halfCellSize = tilemap.cell_size / 2
	usedRect = tilemap.get_used_rect()
	
	var tiles = tilemap.get_used_cells()
	
	
	add_trav_tiles(tiles)
	connect_trav_tiles(tiles)
	
	
func add_trav_tiles(tiles):
	for tile in tiles:
		var id = get_id_point(tile)
		astar.add_point(id, tile)
	
	
	
func connect_trav_tiles(tiles):
	for tile in tiles:
		var id = get_id_point(tile)
		
		for point in [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]:
				var target = tile + point
				var targetId = get_id_point(target)
				
				if tile == target or not astar.has_point(targetId):
					continue
					
				astar.connect_points(id, targetId, true)
				

func update_navi_map():
	for point in astar.get_points():
		astar.set_point_disabled(point, false)
		
	var obstacles = get_tree().get_nodes_in_group("obstacles")
	
	for obstacle in obstacles:
		if obstacle is TileMap:
			var tiles = obstacle.get_used_cells()
			for tile in tiles:
				var id = get_id_point(tile)
				if astar.has_point(id):
					astar.set_point_disabled(id, true)
		if obstacle is KinematicBody2D:
			var tileCoord = tilemap.world_to_map(obstacle.collisionShape.global_position)
			var id = get_id_point(tileCoord)
			if astar.has_point(id):
				astar.set_point_disabled(id, true)
				
	
	
func get_id_point(point):
	var x = point.x - usedRect.position.x
	var y = point.y - usedRect.position.y
	
	return x + y * usedRect.size.x


#Function that for world coordinates
func get_new_path(start, end):
	var startTile = tilemap.world_to_map(start)
	var endTile = tilemap.world_to_map(end)
	
	var startId = get_id_point(startTile)
	var endId = get_id_point(endTile)
	
	if not astar.has_point(startId) or not astar.has_point(endId):
		return []
		
	var pathMap = astar.get_point_path(startId, endId)
	
	var pathWorld = []
	for point in pathMap:
		var pointWorld = tilemap.map_to_world(point) + halfCellSize
		pathWorld.append(pointWorld)
		
	return pathWorld	
	
	

