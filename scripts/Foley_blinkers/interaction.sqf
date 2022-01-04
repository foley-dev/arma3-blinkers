#include "..\macros.hpp"

params ["_vehicle"];

GVAR(fnc_applySetting) = {
	params ["_vehicle", "_setting", "_previousSetting"];

	if (_setting != _previousSetting) then {
		_vehicle setVariable [QGVAR(setting), _setting, true];
		[
			_vehicle,
			SETTING_CHANGED,
			[_vehicle, _setting, _previousSetting]
		] remoteExecCall ["BIS_fnc_callScriptedEventHandler", 0, false];
	};
};

[
	_vehicle,
	INTERACTED,
	{
		params ["_vehicle", "_interactionType"];

		private _previousSetting = _vehicle getVariable [QGVAR(setting), SETTING_OFF];
		private _setting = [SETTING_OFF, _interactionType] select (_interactionType != _previousSetting);
		[_vehicle, _setting, _previousSetting] call GVAR(fnc_applySetting);
	}
] call BIS_fnc_addScriptedEventHandler;

GVAR(automaticHazards) = {
	params ["_vehicle"];

	waitUntil {
		sleep 0.1;
		!alive _vehicle || !canMove _vehicle
	};

	if (alive _vehicle && local _vehicle) then {
		private _previousSetting = _vehicle getVariable [QGVAR(setting), SETTING_OFF];
		[_vehicle, SETTING_HAZARDS, _previousSetting] call GVAR(fnc_applySetting);
	};

	if (alive _vehicle) then {
		waitUntil {
			sleep 1;
			!canMove _vehicle
		};

		[_vehicle] spawn GVAR(automaticHazards);
	};
};

[_vehicle] spawn GVAR(automaticHazards);
