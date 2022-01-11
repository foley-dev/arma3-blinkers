#include "..\macros.hpp"

params ["_vehicle"];

if (DEBUG) then {
	[
		_vehicle,
		INTERACTED,
		{
			systemChat str [INTERACTED, _this];
		}
	] call BIS_fnc_addScriptedEventHandler;

	[
		_vehicle,
		SETTING_CHANGED,
		{
			systemChat str [SETTING_CHANGED, _this];
		}
	] call BIS_fnc_addScriptedEventHandler;

	[
		_vehicle,
		BREAKER,
		{
			systemChat str [BREAKER, _this];
		}
	] call BIS_fnc_addScriptedEventHandler;
};

if (DEBUG_FPS) then {
	Foley_reps = 10;
	Foley_fps = 60;
	Foley_offsetFactor = 1;
	Foley_previousVelocity = velocity vehicle player;

	addMissionEventHandler [
		"EachFrame",
		{
			if (diag_frameNo % 10 == 0) then {
				hintSilent ([
					"fps", diag_fps, "", 
					"min fps", diag_fpsMin, "", 
					"reps", Foley_reps, "", 
					"delta time", diag_deltaTime , "", 
					"acceleration", ((vectorMagnitude (Foley_previousVelocity vectorDiff (velocity vehicle player))) / diag_deltaTime) toFixed 3
				] joinString "\n");
			};

			Foley_previousVelocity = velocity vehicle player;
			private _diff = (diag_fps - Foley_fps) / (1 max abs (diag_fps - Foley_fps));
			
			if (abs (Foley_fps - diag_fps) > 15) then {
				_diff = _diff * 4;
			};

			if (abs (Foley_fps - diag_fps) > 10) then {
				_diff = _diff * 4;
			};

			if (abs (Foley_fps - diag_fps) > 5) then {
				_diff = _diff * 4;
			};

			if (diag_fps < Foley_fps) then {
				_diff = _diff * 2;
			};

			_diff = round _diff;
			Foley_reps = Foley_reps + _diff;
			Foley_reps = Foley_reps min 10000;
			Foley_reps = Foley_reps max 1;

			for "_i" from 1 to Foley_reps do {
				private _res = lineIntersectsSurfaces [eyePos player, [0,0,0], objNull, objNull, true, -1, "VIEW", "FIRE", false];
			};
		}
	];
};
