#include "..\macros.hpp"

params ["_vehicle"];

GVAR(initDebugForVehicle) = {
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
};

if (DEBUG_FPS) then {
	[] spawn {
		waitUntil {
			!isNull player;
		};

		GVAR(debugFpsReps) = 10;
		GVAR(debugFpsTarget) = 60;
		GVAR(debugFpsPreviousVelocity) = velocity vehicle player;

		addMissionEventHandler [
			"EachFrame",
			{
				if (diag_frameNo % 10 == 0) then {
					hintSilent ([
						"fps", diag_fps, "", 
						"min fps", diag_fpsMin, "", 
						"reps", GVAR(debugFpsReps), "", 
						"delta time", diag_deltaTime , "", 
						"acceleration", ((vectorMagnitude (GVAR(debugFpsPreviousVelocity) vectorDiff (velocity vehicle player))) / diag_deltaTime) toFixed 3
					] joinString "\n");
				};

				GVAR(debugFpsPreviousVelocity) = velocity vehicle player;
				private _diff = (diag_fps - GVAR(debugFpsTarget)) / (1 max abs (diag_fps - GVAR(debugFpsTarget)));
				
				if (abs (GVAR(debugFpsTarget) - diag_fps) > 15) then {
					_diff = _diff * 4;
				};

				if (abs (GVAR(debugFpsTarget) - diag_fps) > 10) then {
					_diff = _diff * 4;
				};

				if (abs (GVAR(debugFpsTarget) - diag_fps) > 5) then {
					_diff = _diff * 4;
				};

				if (diag_fps < GVAR(debugFpsTarget)) then {
					_diff = _diff * 2;
				};

				_diff = round _diff;
				GVAR(debugFpsReps) = GVAR(debugFpsReps) + _diff;
				GVAR(debugFpsReps) = GVAR(debugFpsReps) min 10000;
				GVAR(debugFpsReps) = GVAR(debugFpsReps) max 1;

				for "_i" from 1 to GVAR(debugFpsReps) do {
					private _res = lineIntersectsSurfaces [eyePos player, [0,0,0], objNull, objNull, true, -1, "VIEW", "FIRE", false];
				};
			}
		];
	};
};
