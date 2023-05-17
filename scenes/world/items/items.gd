extends Node

enum TOOL{SHOVEL, AXE, PICAXE, HOE, SWORD}

#	 0			1		   2					 3			4		   5			 6	   7		 8
#ID, Item name, stackable, max stackable number, is a cube, item icon, item texture, mesh, hardness, tool


var items_list : Dictionary = {
	0: ["dirt",true,64,true,"res://assets/img/hud/items/dirt_inventory.png","res://assets/3d_models/enviroment/dirt.tres","res://assets/3d_models/enviroment/cube_mesh.res", 100, TOOL.SHOVEL],
	1: ["oak plank",true,64,true,"res://assets/img/hud/items/oak_planks_inventory.png","res://assets/3d_models/enviroment/oak_planks.tres","res://assets/3d_models/enviroment/cube_mesh.res", 125, TOOL.AXE],
	2: ["cobblestone",true,64,true,"res://assets/img/hud/items/cobblestone_inventory.png","res://assets/3d_models/enviroment/cobblestone.tres","res://assets/3d_models/enviroment/cube_mesh.res", 300, TOOL.PICAXE],
	3: ["birch log",true,64,true,"res://assets/img/hud/items/birch_log_inventory.png","res://assets/3d_models/enviroment/birch_log.tres","res://assets/3d_models/enviroment/cube_mesh.res", 125, TOOL.AXE],
}
