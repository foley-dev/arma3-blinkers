#include "..\macros.hpp"
#define SWITCH_ON "Foley_blinkers_switchOn"
#define SWITCH_OFF "Foley_blinkers_switchOff"
#define BREAKER_ON "Foley_blinkers_breakerOn"
#define BREAKER_OFF "Foley_blinkers_breakerOff"

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
	SETTING_CHANGED,
	{
		params ["_vehicle", "_interactionType"];

		private _sound = [SWITCH_ON, SWITCH_OFF] select (_interactionType == SETTING_OFF);
		[_vehicle, _sound] call GVAR(fnc_playSound);
	}
] call BIS_fnc_addScriptedEventHandler;

[
	_vehicle,
	BREAKER,
	{
		params ["_vehicle", "_circuitClosed"];
		
		private _sound = [BREAKER_ON, BREAKER_OFF] select _circuitClosed;
		[_vehicle, _sound] call GVAR(fnc_playSound);
	}
] call BIS_fnc_addScriptedEventHandler;
