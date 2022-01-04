{
	[_x] execVM "scripts\Foley_blinkers\blinkers.sqf";
} forEach (vehicles select {_x isKindOf "LandVehicle"});

// Foley_reps = 10;
// Foley_fps = 60;
// Foley_offsetFactor = 1;
// Foley_previousVelocity = velocity vehicle player;

// addMissionEventHandler [
// 	"EachFrame",
// 	{
// 		if (diag_frameNo % 10 == 0) then {
// 			hintSilent ([
// 				"fps", diag_fps, "", 
// 				"min fps", diag_fpsMin, "", 
// 				"reps", Foley_reps, "", 
// 				"delta time", diag_deltaTime , "", 
// 				"acceleration", ((vectorMagnitude (Foley_previousVelocity vectorDiff (velocity vehicle player))) / diag_deltaTime) toFixed 3
// 			] joinString "\n");
// 		};

// 		Foley_previousVelocity = velocity vehicle player;
// 		private _diff = (diag_fps - Foley_fps) / (1 max abs (diag_fps - Foley_fps));
		
// 		if (abs (Foley_fps - diag_fps) > 15) then {
// 			_diff = _diff * 4;
// 		};

// 		if (abs (Foley_fps - diag_fps) > 10) then {
// 			_diff = _diff * 4;
// 		};

// 		if (abs (Foley_fps - diag_fps) > 5) then {
// 			_diff = _diff * 4;
// 		};

// 		if (diag_fps < Foley_fps) then {
// 			_diff = _diff * 2;
// 		};

// 		_diff = round _diff;
// 		Foley_reps = Foley_reps + _diff;
// 		Foley_reps = Foley_reps min 10000;
// 		Foley_reps = Foley_reps max 1;

// 		for "_i" from 1 to Foley_reps do {
//     		private _res = lineIntersectsSurfaces [eyePos player, [0,0,0], objNull, objNull, true, -1, "VIEW", "FIRE", false];
// 		};
// 	}
// ];

#define GREEN_LIT [0, 1, 0, 1]
#define GREEN_DIM [0, 0.4, 0, 0.67]
#define RED_LIT [1, 0, 0, 1]
#define RED_DIM [0.7, 0, 0, 0.67]

addMissionEventHandler [
	"Draw3D",
	{
		{
			private _vehicle = _x;

			if (vehicle player == _vehicle && cameraView == "INTERNAL") then {
				private _state = _vehicle getVariable ["Foley_blinkerEffectiveState", 0];
				private _colorLeft = [GREEN_DIM, GREEN_LIT] select (_state == 1 || _state == 3);
				private _colorRight = [GREEN_DIM, GREEN_LIT] select (_state == 2 || _state == 3);
				private _colorHazards = [RED_DIM, RED_LIT] select (_state == 3);

				if (driver vehicle player != player) then {
					_colorLeft set [3, (_colorLeft select 3) / 2];
					_colorRight set [3, (_colorRight select 3) / 2];
					_colorHazards set [3, (_colorHazards select 3) / 2];
				};

				drawIcon3D ["", _colorLeft, player modelToWorldVisual [-0.08, 0.58, 0.52], 0, 0, 0, "<", 2, 0.09, "RobotoCondensedBold"];
				drawIcon3D ["", _colorHazards, player modelToWorldVisual [-0.04, 0.58, 0.52], 0, 0, 0, "<!>", 2, 0.07, "RobotoCondensedBold"];
				drawIcon3D ["", _colorRight, player modelToWorldVisual [0.00, 0.58, 0.52], 0, 0, 0, ">", 2, 0.09, "RobotoCondensedBold"];
			};

			if (abs speed _vehicle < 0.01) then { 
				continue;
			};

			if (_vehicle distance player > 1000 && diag_frameNo % 10 != 0) then {
				continue;
			};
			
			{
				private _light = _vehicle getVariable ("Foley_lightPoint" + _x);
				private _memPoint = _vehicle getVariable ("Foley_lightPoint" + _x + "_mempoint");
				private _sphere = _vehicle getVariable ("Foley_lightPoint" + _x + "_sphere");

				private _adjustment = _vehicle getVariable ["Foley_lightPoint" + _x + "_adjustment", [0, 0, 0]];
				_sphere setPosASL getPosASLVisual _light;

				private _pos = _vehicle modelToWorldVisual _memPoint;
				private _adjustedPos = (AGLToASL _pos) vectorAdd _adjustment;
				_light setPosASL _adjustedPos;

				private _acceleration = (vectorMagnitude ((_vehicle getVariable ["Foley_lastVelocity", [0, 0, 0]]) vectorDiff velocity _vehicle))  / diag_deltaTime;
				_vehicle setVariable ["Foley_lastVelocity", velocity _vehicle];

				if (diag_frameNo % 10 == 0 || _acceleration > 3 && diag_frameNo % 2 == 0) then {
					_adjustment = _adjustment vectorAdd (((AGLToASL _pos) vectorDiff (getPosASLVisual _sphere)) vectorMultiply 0.999);
					_vehicle setVariable ["Foley_lightPoint" + _x + "_adjustment", _adjustment];
				};
			} forEach ["FL", "RR", "FR", "RL"];		
		} forEach (vehicles select {_x isKindOf "LandVehicle"});
	}
];
