#include "macros.hpp"

GVAR(config) = createHashMap;
GVAR(fnc_loadConfig) = {
	{
		private _config = parseSimpleArray preprocessFile (BASE_DIR + "config\" + _x);
		GVAR(config) merge (createHashMapFromArray _config);
	} forEach ["bis.sqf", "uk3cb.sqf", "extras.sqf"];

	{
		GVAR(config) set [_x, createHashMapFromArray (GVAR(config) get _x)];
	} forEach keys GVAR(config);
};
call GVAR(fnc_loadConfig);

GVAR(managedVehicles) = [];
GVAR(fnc_initVehicle) = {
	params ["_vehicle"];

	if (_vehicle in GVAR(managedVehicles)) exitWith {};

	private _config = GVAR(config) get (typeOf _vehicle);

	if (isNil "_config") exitWith {};

	[_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\actions.sqf");
	[_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\audio.sqf");
	[_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\breaker.sqf");
	[_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\interaction.sqf");
	// [_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\debug.sqf");
	[_vehicle, _config] call compile preprocessFileLineNumbers (BASE_DIR + "modules\lights.sqf");

	GVAR(managedVehicles) pushBack _vehicle;
};

private _vehicles = [];

if (!isNil "_this") then {
	_vehicles = _this;
} else {
	_vehicles = vehicles select {typeOf _x in GVAR(config)};
};

{
	private _v = _x;

	if (_x isEqualType "") then {
		{
			[_x] call GVAR(fnc_initVehicle);
		} forEach (vehicles select {typeOf _x == _v})
	};
	
	if (_x isEqualType objNull) then {
		[_x] call GVAR(fnc_initVehicle);
	};
} forEach _vehicles;

call compile preprocessFileLineNumbers (BASE_DIR + "modules\dashboard.sqf");
addMissionEventHandler [
	"Draw3D",
	{
		{
			if (!alive _x) then {
				GVAR(managedVehicles) = GVAR(managedVehicles) select {alive _x};
				continue;
			};

			[_x] call GVAR(fnc_drawDashboard);

			if (abs speed _x > 0.01) then {
				[_x, diag_frameNo % 2 == 0] call GVAR(fnc_adjustOffsets);
			};
		} forEach GVAR(managedVehicles);
	}
];

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
