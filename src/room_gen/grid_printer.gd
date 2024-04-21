extends Node

func print_grid(points: Array):
	var min_x = 0
	var min_y = 0
	var max_x = 0
	var max_y = 0
	
	# Find min and max coordinates
	for point in points:
		min_x = min(min_x, point.x)
		min_y = min(min_y, point.y)
		max_x = max(max_x, point.x)
		max_y = max(max_y, point.y)
	
	# Calculate grid size
	var width = max_x - min_x + 1
	var height = max_y - min_y + 1
	
	# Create grid
	var grid = []
	for y in range(height):
		var row = []
		for x in range(width):
			row.append("-")
		grid.append(row)
	
	# Populate grid with points
	for point in points:
		var grid_x = max_x - point.x
		var grid_y = point.y - min_y
		grid[grid_y][grid_x] = "X"
	
	# Print grid
	for row in grid:
		var row_str = ""
		for cell in row:
			row_str += cell
		print(row_str)
