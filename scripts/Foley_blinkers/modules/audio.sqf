#include "..\macros.hpp"
#define SWITCH_ON QGVAR(switchOn)
#define SWITCH_OFF QGVAR(switchOff)
#define BREAKER_ON QGVAR(breakerOn)
#define BREAKER_OFF QGVAR(breakerOff)

GVAR(fnc_initAudioForVehicle) = {
	params ["_vehicle"];
	
	[
		_vehicle,
		SETTING_CHANGED,
		{
			params ["_vehicle", "_interactionType"];

			private _currentlyOn = _interactionType != SETTING_OFF;
			private _previouslyOn = (_vehicle getVariable [QGVAR(setting), SETTING_OFF]) != SETTING_OFF;

			if (_previouslyOn) then {
				[_vehicle, SWITCH_OFF] call GVAR(fnc_playSound);
			};

			if (_currentlyOn) then {
				[_vehicle, SWITCH_ON] call GVAR(fnc_playSound);
			};
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
};

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
