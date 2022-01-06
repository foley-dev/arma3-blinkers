#include "..\macros.hpp"

params ["_vehicle"];

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
