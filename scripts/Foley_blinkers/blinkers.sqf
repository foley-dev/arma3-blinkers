#define BLINK_NONE 0
#define BLINK_LEFT 1
#define BLINK_RIGHT 2
#define BLINK_BOTH 3
// #define LABEL_LEFT_LIT "<t color='#00ff00' shadowColor='#006600' size='1.25' font='RobotoCondensedBold' shadow='2'>&lt;</t>  <t color='#777777' size='0.75' font='EtelkaMonospacePro'>[Z]</t>"
// #define LABEL_LEFT_DIM "<t color='#006600' shadowColor='#006600' size='1.25' font='RobotoCondensedBold' shadow='2'>&lt;</t>  <t color='#777777' size='0.75' font='EtelkaMonospacePro'>[Z]</t>"
// #define LABEL_RIGHT_LIT "<t color='#00ff00' shadowColor='#006600' size='1.25' font='RobotoCondensedBold' shadow='2'>&gt;</t> <t color='#777777' size='0.75' font='EtelkaMonospacePro'>[C]</t>"
// #define LABEL_RIGHT_DIM "<t color='#006600' shadowColor='#006600' size='1.25' font='RobotoCondensedBold' shadow='2'>&gt;</t> <t color='#777777' size='0.75' font='EtelkaMonospacePro'>[C]</t>"
// #define LABEL_HAZARDS_LIT "<t color='#ff8888' shadowColor='#bb0000' size='1.25' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t>"
// #define LABEL_HAZARDS_DIM "<t color='#bb0000' shadowColor='#bb0000' size='1.25' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t>"
#define LABEL_LEFT_LIT "<t color='#00ff00' shadowColor='#006600' size='1.2' font='RobotoCondensedBold' shadow='2'>&lt;</t>&#160;&#160;&#160;Left Turn Signal <t color='#777777' size='1' font='RobotoCondensedBold'>[Z]</t>"
#define LABEL_LEFT_DIM "<t color='#006600' shadowColor='#006600' size='1.2' font='RobotoCondensedBold' shadow='2'>&lt;</t>&#160;&#160;&#160;Left Turn Signal <t color='#777777' size='1' font='RobotoCondensedBold'>[Z]</t>"
#define LABEL_RIGHT_LIT "<t color='#00ff00' shadowColor='#006600' size='1.2' font='RobotoCondensedBold' shadow='2'>&gt;</t>&#160;&#160;&#160;Right Turn Signal <t color='#777777' size='1' font='RobotoCondensedBold'>[C]</t>"
#define LABEL_RIGHT_DIM "<t color='#006600' shadowColor='#006600' size='1.2' font='RobotoCondensedBold' shadow='2'>&gt;</t>&#160;&#160;&#160;Right Turn Signal <t color='#777777' size='1' font='RobotoCondensedBold'>[C]</t>"
#define LABEL_HAZARDS_LIT "<t color='#ff8888' shadowColor='#bb0000' size='1.2' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t> Hazard Lights"
#define LABEL_HAZARDS_DIM "<t color='#bb0000' shadowColor='#bb0000' size='1.2' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t> Hazard Lights"
#define BIG_LABEL_LEFT "<t color='#00ff00' shadowColor='#006600' size='2.5' font='RobotoCondensedBold' shadow='2'>&lt;</t>&#160;&#160;&#160;&#160;<t color='#bb0000' shadowColor='#bb0000' size='1.75' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t>&#160;&#160;&#160;&#160;<t color='#006600' shadowColor='#006600' size='2.5' font='RobotoCondensedBold' shadow='2'>&gt;</t>"
#define BIG_LABEL_RIGHT "<t color='#006600' shadowColor='#006600' size='2.5' font='RobotoCondensedBold' shadow='2'>&lt;</t>&#160;&#160;&#160;&#160;<t color='#bb0000' shadowColor='#bb0000' size='1.75' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t>&#160;&#160;&#160;&#160;<t color='#00ff00' shadowColor='#006600' size='2.5' font='RobotoCondensedBold' shadow='2'>&gt;</t>"
#define BIG_LABEL_BOTH "<t color='#00ff00' shadowColor='#006600' size='2.5' font='RobotoCondensedBold' shadow='2'>&lt;</t>&#160;&#160;&#160;&#160;<t color='#ff8888' shadowColor='#bb0000' size='1.75' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t>&#160;&#160;&#160;&#160;<t color='#00ff00' shadowColor='#006600' size='2.5' font='RobotoCondensedBold' shadow='2'>&gt;</t>"
#define BIG_LABEL_NONE "<t color='#006600' shadowColor='#006600' size='2.5' font='RobotoCondensedBold' shadow='2'>&lt;</t>&#160;&#160;&#160;&#160;<t color='#bb0000' shadowColor='#bb0000' size='1.75' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t>&#160;&#160;&#160;&#160;<t color='#006600' shadowColor='#006600' size='2.5' font='RobotoCondensedBold' shadow='2'>&gt;</t>"
#define BIG_LABEL_BEACON_OFF ""
#define BIG_LABEL_BEACON_ONLY ""
#define BIG_LABEL_BEACON_AND_LIGHTS "<br /><t color='#66b3ff' shadowColor='#24394f' size='1.2' font='RobotoCondensedBold' shadow='2'>[Beacons]</t>&#160;&#160;&#160;&#160;&#160;<t color='#24394f' shadowColor='#24394f' size='1.2' font='RobotoCondensedBold' shadow='2'>[Siren]</t>"
#define BIG_LABEL_SPACING "<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />"
#define SOUND_BREAKER "RHS_ButtonPress"
#define SOUND_SWITCH "RHS_SwitchToggle"
#define SUNRISE 4
#define SUNSET 20

params ["_vehicle"];

// [fl, rr, fr, rl] apply {(cursorObject worldToModel getPos _x) apply {parseNumber (_x toFixed 2)}}
private _blinkerLocations = createHashMapFromArray [
	[
		"UK3CB_AAF_I_Offroad",
		[
			["FL", [-0.85, 2.1, -0.33]],
			["RR", [0.8, -2.9, -0.4]],
			["FR", [0.8, 2.1, -0.33]],
			["RL", [-0.85, -2.9, -0.4]]
		]
	],
	[
		"B_GEN_Van_02_vehicle_F",
		[
			["FL", [-0.7, 3.95, -0.6]],
			["RR", [0.95, -3.2, -0.5]],
			["FR", [0.7, 3.95, -0.6]],
			["RL", [-0.95, -3.2, -0.5]]
		]
	],
	[
		"C_Van_02_vehicle_F",
		[
			["FL", [-0.7, 3.95, -0.6]],
			["RR", [0.95, -3.2, -0.5]],
			["FR", [0.7, 3.95, -0.6]],
			["RL", [-0.95, -3.2, -0.5]]
		]
	],
	[
		"O_G_Van_02_vehicle_F",
		[
			["FL", [-0.7, 3.95, -0.6]],
			["RR", [0.95, -3.2, -0.5]],
			["FR", [0.7, 3.95, -0.6]],
			["RL", [-0.95, -3.2, -0.5]]
		]
	],
	[
		"UK3CB_AAF_I_GAZ_Vodnik_MedEvac",
		[
			["FL", [-0.91,3.15,-1.35]],
			["RR", [0.96,-2.31,-1.47]],
			["FR", [0.92,3.17,-1.35]],
			["RL", [-0.94,-2.32,-1.47]]
		]
	],
	[
		"I_Truck_02_medical_F",
		[
			["FL", [-0.85, 3.9, -1.24]],
			["RR", [0.76, -3.5, -1.33]],
			["FR", [0.78, 3.9, -1.24]],
			["RL", [-0.81, -3.5, -1.33]]
		]
	],
	[
		"I_Truck_02_box_F",
		[
			["FL", [-0.85, 3.9, -1.24]],
			["RR", [0.76, -3.5, -1.33]],
			["FR", [0.78, 3.9, -1.24]],
			["RL", [-0.81, -3.5, -1.33]]
		]
	],
	[
		"I_Truck_02_fuel_F",
		[
			["FL", [-0.85, 3.9, -1.24]],
			["RR", [0.76, -3.5, -1.33]],
			["FR", [0.78, 3.9, -1.24]],
			["RL", [-0.81, -3.5, -1.33]]
		]
	],
	[
		"UK3CB_C_Ikarus",
		[
			["FL", [-1.05,5.02,-0.52]],
			["RR", [0.77,-5.81,-0.78]],
			["FR", [0.79,5.04,-0.51]],
			["RL", [-1.06,-5.8,-0.77]]
		]
	],
	[
		"C_Hatchback_01_F",
		[
			["FL", [-0.59,1.96,-0.55]],
			["RR", [0.71,-2.25,-0.25]],
			["FR", [0.5,1.95,-0.55]],
			["RL", [-0.76,-2.25,-0.26]]
		]
	],
	[
		"C_SUV_01_F",
		[
			["FL", [-0.85,1.89,-0.4]],
			["RR", [0.82,-2.75,-0.15]],
			["FR", [0.83,1.88,-0.4]],
			["RL", [-0.85,-2.78,-0.15]]
		]
	],
	[
		"UK3CB_C_Datsun_Closed",
		[
			["FL", [-0.6,2.31,-0.9]],
			["RR", [0.75,-2.19,-0.81]],
			["FR", [0.6,2.33,-0.91]],
			["RL", [-0.7,-2.19,-0.81]]
		]
	],
	[
		"UK3CB_C_Golf",
		[
			["FL", [-0.49,2.03,-0.65]],
			["RR", [0.65,-1.7,-0.5]],
			["FR", [0.59,2.03,-0.64]],
			["RL", [-0.65,-1.7,-0.5]]
		]
	],
	[
		"UK3CB_C_Pickup",
		[
			["FL", [-0.74,2.7,-0.65]],
			["RR", [0.77,-2.23,-0.7]],
			["FR", [0.78,2.67,-0.65]],
			["RL", [-0.74,-2.21,-0.7]]
		]
	],
	[
		"UK3CB_C_Ural_Recovery",
		[
			["FL", [-0.94,4.05,-0.59]],
			["RR", [1.02,-3.25,-0.66]],
			["FR", [0.91,4.07,-0.58]],
			["RL", [-1.03,-3.27,-0.65]]
		]
	],
	[
		"UK3CB_C_Landcruiser",
		[
			["FL", [-0.85,2.21,-0.39]],
			["RR", [0.86,-2.4,-0.34]],
			["FR", [0.86,2.21,-0.38]],
			["RL", [-0.88,-2.41,-0.34]]
		]
	],
	[
		"UK3CB_CHC_C_Lada",
		[
			["FL", [-0.61,2.11,-0.87]],
			["RR", [0.54,-1.8,-0.74]],
			["FR", [0.6,2.12,-0.87]],
			["RL", [-0.55,-1.79,-0.74]]
		]
	],
	[
		"UK3CB_AAF_O_Tigr_FFV",
		[
			["FL", [-1,2.47,-0.71]],
			["RR", [1,-2.3,-1.2]],
			["FR", [0.91,2.46,-0.71]],
			["RL", [-1.12,-2.31,-1.19]]
		]
	],
	[
		"O_Truck_03_device_F",
		[
			["FL", [-0.83,3.03,-0.78]],
			["RR", [1.08,-4.93,-0.92]],
			["FR", [0.83,3.03,-0.79]],
			["RL", [-1.06,-4.95,-0.93]]
		]
	],
	[
		"UK3CB_AAF_B_M1025",
		[
			["FL", [-1.02,2.21,-0.78]],
			["RR", [0.82,-2.29,-0.82]],
			["FR", [0.87,2.22,-0.78]],
			["RL", [-0.95,-2.28,-0.83]]
		]
	]
];

private _locations = _blinkerLocations get (typeOf _vehicle);

if (isNil "_locations") exitWith {};

{
	private _light = "#lightreflector" createVehicleLocal (getPos _vehicle); 
	_light setLightIntensity 0;
	_light setLightAttenuation [0.001, 100, 100, 100, 0.001, 0.002];
	_light setLightColor [1.0, 0.75, 0.0]; 
	_light attachTo [_vehicle, _x select 1];
	_light setLightUseFlare true;
	_light setLightFlareSize 0.5;
	_light setLightFlareMaxDistance 250 + (_forEachIndex * 250);
	_light setLightDayLight true;
    _light setLightConePars [270, 120, 1];
    _light setVectorDirAndUp [([0, 0, 0] vectorFromTo (_x select 1)), [0, 0, 1]];


	private _sphere = "Sign_Sphere25cm_F" createVehicleLocal (getPos _vehicle);
	hideObject _sphere;
	_sphere attachTo [_vehicle,  _x select 1];
	
	_vehicle setVariable ["Foley_lightPoint" + (_x select 0), _light];
	_vehicle setVariable ["Foley_lightPoint" + (_x select 0) + "_mempoint", _x select 1];
	_vehicle setVariable ["Foley_lightPoint" + (_x select 0) + "_sphere", _sphere];
	_vehicle setVariable ["Foley_blinkerState", BLINK_NONE];
} forEach _locations;

private _actionLeft = _vehicle addAction [
	LABEL_LEFT_DIM,
	{
		params ["_target", "_caller", "_actionId", "_arguments"];

		if ((_target getVariable "Foley_blinkerState") == BLINK_LEFT) then {
			_target setVariable ["Foley_blinkerState", BLINK_NONE, true];
		} else {
			_target setVariable ["Foley_blinkerState", BLINK_LEFT, true];
		};

		playSound SOUND_SWITCH;
	},
	nil,
	1002,
	false,
	false,
	"BuldRotateSelZ",
	"driver _target == _this",
	5
];

private _actionRight = _vehicle addAction [
	LABEL_RIGHT_DIM,
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		
		if ((_target getVariable "Foley_blinkerState") == BLINK_RIGHT) then {
			_target setVariable ["Foley_blinkerState", BLINK_NONE, true];
		} else {
			_target setVariable ["Foley_blinkerState", BLINK_RIGHT, true];
		};

		playSound SOUND_SWITCH;
	},
	nil,
	1001,
	false,
	false,
	"BuldBrushSetHeight",
	"driver _target == _this",
	5
];

private _actionHazards = _vehicle addAction [
	LABEL_HAZARDS_DIM,
	{
		params ["_target", "_caller", "_actionId", "_arguments"];

		if ((_target getVariable "Foley_blinkerState") == BLINK_BOTH) then {
			_target setVariable ["Foley_blinkerState", BLINK_NONE, true];
		} else {
			_target setVariable ["Foley_blinkerState", BLINK_BOTH, true];
		};

		playSound SOUND_SWITCH;
	},
	nil,
	1000,
	false,
	false,
	"",
	"driver _target == _this",
	5
];

if (isNil "Foley_blinkerEHInitialized") then {
	player addEventHandler [
		"GetOutMan",
		{
			"Foley_blinkers" cutText ["",  "PLAIN NOFADE", 0.2, false, true];
		}
	];
	Foley_blinkerEHInitialized = true;
};

[_vehicle] spawn {
	params ["_vehicle"];

	waitUntil {
		!alive _vehicle || !canMove _vehicle || damage _vehicle > 0.5
	};

	if (alive _vehicle && local _vehicle) then {
		_vehicle setVariable ["Foley_blinkerState", BLINK_BOTH, true];
	};
};

private _lightLookup = [
	BLINK_NONE,
	BLINK_LEFT,
	BLINK_RIGHT,
	BLINK_BOTH
] createHashMapFromArray [
	[[], ["Foley_lightPointFL","Foley_lightPointFR","Foley_lightPointRL","Foley_lightPointRR"]],
	[["Foley_lightPointFL","Foley_lightPointRL"], ["Foley_lightPointFR","Foley_lightPointRR"]],
	[["Foley_lightPointFR","Foley_lightPointRR"], ["Foley_lightPointFL","Foley_lightPointRL"]],
	[["Foley_lightPointFL","Foley_lightPointFR","Foley_lightPointRL","Foley_lightPointRR"], []]
];
private _breaker = false;
private _interval = random [0.45, 0.5, 0.55];
private _previousState = BLINK_NONE;

while {alive _vehicle} do {
	private _effectiveState = _vehicle getVariable ["Foley_blinkerState", BLINK_NONE];

	if (_breaker) then {
		_effectiveState = BLINK_NONE;
	};

	_vehicle setVariable ["Foley_blinkerEffectiveState", _effectiveState];

	if (driver _vehicle == player) then {
		if (_effectiveState == BLINK_NONE) then {
			_vehicle setUserActionText [_actionLeft, LABEL_LEFT_DIM];
			_vehicle setUserActionText [_actionRight, LABEL_RIGHT_DIM];
			_vehicle setUserActionText [_actionHazards, LABEL_HAZARDS_DIM];
			// if (cameraView == "INTERNAL") then {
			// 	"Foley_blinkers" cutText [BIG_LABEL_SPACING + BIG_LABEL_NONE, "PLAIN NOFADE", 0.2, false, true];
			// };
		};

		if (_effectiveState == BLINK_LEFT) then {
			_vehicle setUserActionText [_actionLeft, LABEL_LEFT_LIT];
			_vehicle setUserActionText [_actionRight, LABEL_RIGHT_DIM];
			_vehicle setUserActionText [_actionHazards, LABEL_HAZARDS_DIM];

			// if (cameraView == "INTERNAL") then {
			// 	"Foley_blinkers" cutText [BIG_LABEL_SPACING + BIG_LABEL_LEFT, "PLAIN NOFADE", 0.2, false, true];
			// };
		};

		if (_effectiveState == BLINK_RIGHT) then {
			_vehicle setUserActionText [_actionLeft, LABEL_LEFT_DIM];
			_vehicle setUserActionText [_actionRight, LABEL_RIGHT_LIT];
			_vehicle setUserActionText [_actionHazards, LABEL_HAZARDS_DIM];

			// if (cameraView == "INTERNAL") then {
			// 	"Foley_blinkers" cutText [BIG_LABEL_SPACING + BIG_LABEL_RIGHT, "PLAIN NOFADE", 0.2, false, true];
			// };
		};
		
		if (_effectiveState == BLINK_BOTH) then {
			_vehicle setUserActionText [_actionLeft, LABEL_LEFT_LIT];
			_vehicle setUserActionText [_actionRight, LABEL_RIGHT_LIT];
			_vehicle setUserActionText [_actionHazards, LABEL_HAZARDS_LIT];

			// if (cameraView == "INTERNAL") then {
			// 	"Foley_blinkers" cutText [BIG_LABEL_SPACING + BIG_LABEL_BOTH, "PLAIN NOFADE", 0.2, false, true];
			// };
		};
	};

	if (vehicle player == _vehicle && cameraView == "INTERNAL") then {
		if (_previousState != _effectiveState && _effectiveState != BLINK_NONE) then {
			playSound SOUND_BREAKER;

			if (driver _vehicle == player) then {
				playSound SOUND_BREAKER;  // Amplify sound for the driver
			};

			if (isEngineOn _vehicle) then {
				playSound SOUND_BREAKER;  // Amplify sound when engine on
			};
		};
	};


	(_lightLookup get _effectiveState) params ["_lightPointsOn", "_lightPointsOff"];

	private _intensity = 1000;

	if (dayTime > SUNRISE && dayTime < SUNSET) then {
		_intensity = _intensity * 10;
	};
	
	if (dayTime > SUNRISE + 1 && dayTime < SUNSET - 1) then {
		_intensity = _intensity * 10;
	};
	
	if (dayTime > SUNRISE + 2 && dayTime < SUNSET - 2) then {
		_intensity = _intensity * 10;
	};

	private _xOffset = ((velocityModelSpace _vehicle) vectorMultiply -0.05) select 0;
	private _yOffset = ((velocityModelSpace _vehicle) vectorMultiply -0.055) select 1;
	{
		private _lightPoint = _vehicle getVariable _x;
		_lightPoint setLightIntensity _intensity;
	} forEach _lightPointsOn;
	
	{
		private _lightPoint = _vehicle getVariable _x;
		_lightPoint setLightIntensity 0;
	} forEach _lightPointsOff;

	_previousState = _effectiveState;
	_breaker = !_breaker;
	sleep _interval;

	if (_vehicle distance (positionCameraToWorld [0, 0, 0]) > 1000) then {
		sleep 3;
	};
};
