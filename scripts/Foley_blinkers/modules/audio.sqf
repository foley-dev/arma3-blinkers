#include "..\macros.hpp"
#define TOGGLE_SOUND "RHS_SwitchToggle"
#define BREAKER_SOUND "RHS_ButtonPress"

params ["_vehicle"];

GVAR(fnc_playSound) = {
	params ["_vehicle", "_sound"];

	if (vehicle player != _vehicle || cameraView != "INTERNAL") exitWith {};

	playSound _sound;

	if (driver _vehicle == player) then {
		playSound _sound;  // Amplify sound for the driver
	};

	if (isEngineOn _vehicle) then {
		playSound _sound;  // Amplify sound when engine on
	};
};

[
	_vehicle,
	INTERACTED,
	{
		params ["_vehicle", "_interactionType"];

		[_vehicle, TOGGLE_SOUND] call GVAR(fnc_playSound);
	}
] call BIS_fnc_addScriptedEventHandler;

[
	_vehicle,
	BREAKER,
	{
		params ["_vehicle", "_circuitClosed"];

		if (_circuitClosed) then {
			[_vehicle, BREAKER_SOUND] call GVAR(fnc_playSound);
		};
	}
] call BIS_fnc_addScriptedEventHandler;
