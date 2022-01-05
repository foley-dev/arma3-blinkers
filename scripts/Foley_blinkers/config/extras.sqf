/*
	Add or override blinker locations here
	
	Helpful script:
	[fl, rr, fr, rl, dash] apply {
		(cursorObject worldToModel getPos _x) apply {parseNumber (_x toFixed 2)}
	}
*/

[
	[
		"SOME_VEHICLE_CLASSNAME",  // classname of the vehicle
		[
			["FL", [0, 0, 0]],  // front-left indicator offset
			["RR", [0, 0, 0]],  // rear-right indicator offset
			["FR", [0, 0, 0]],  // front-right indicator offset
			["RL", [0, 0, 0]],  // rear-left indicator offset
			["DASH", [0, 0, 0]]  // dashboard offset
		]
	],
	[
		"ANOTHER_VEHICLE_CLASSNAME",
		[
			["FL", [0, 0, 0]],
			["RR", [0, 0, 0]],
			["FR", [0, 0, 0]],
			["RL", [0, 0, 0]],
			["DASH", [0, 0, 0]]
		]
	]
]
