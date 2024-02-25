extends Node

var player_data = {
	"Money": 1000,
	"Current_Wave": 0
}

var tower_data = {
	"T34": {
		"damage": 20,
		"rof": 2,
		"range": 450,
		"cost": 200,
		"category": "projectile"},
	"M6": {
		"damage": 10,
		"rof": 1,
		"range": 705,
		"cost": 400,
		"category": "projectile"},
	"KV2": {
		"damage": 60,
		"rof": 4,
		"range": 320,
		"cost": 600,
		"category": "projectile"}}

var enemy_data = {
	"PzKpfwIV": {
		"speed" = 150,
		"hp" = 50,
		"base_damage" = 20,
		"money" = 25,
	},
	"PzKpfwIVG": {
		"speed" = 130,
		"hp" = 50,
		"base_damage" = 20,
		"money" = 35,
	},
	"VK3601H": {
		"speed" = 110,
		"hp" = 50,
		"base_damage" = 20,
		"money" = 50,
	},
	"TigerII": {
		"speed" = 100,
		"hp" = 50,
		"base_damage" = 20,
		"money" = 100,
	},
	"E100": {
		"speed" = 80,
		"hp" = 50,
		"base_damage" = 20,
		"money" = 200,
	}}

var wave_data = {
	1: {wave = [["PzKpfwIV",1.0],["PzKpfwIV",1.0],["PzKpfwIV",1.0],["PzKpfwIV",1.0],["PzKpfwIV",1.0]]},
	2: {wave = [["PzKpfwIVG",1.0],["PzKpfwIVG",1.0],["PzKpfwIVG",1.0],["PzKpfwIVG",1.0],["PzKpfwIVG",1.0]]},
	3: {wave = [["VK3601H",1.0],["VK3601H",1.0],["VK3601H",1.0],["VK3601H",1.0],["VK3601H",1.0]]},
	4: {wave = [["TigerII",1.0],["TigerII",1.0],["TigerII",1.0],["TigerII",1.0],["TigerII",1.0]]},
	5: {wave = [["E100",1.0],["E100",1.0],["E100",1.0],["E100",1.0],["E100",1.0]]}
}
