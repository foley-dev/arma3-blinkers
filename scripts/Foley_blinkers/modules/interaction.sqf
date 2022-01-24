#include "..\macros.hpp"

GVAR(fnc_initInteractionsForVehicle) = {
	params ["_vehicle"];
	
	private _currentSetting = _vehicle getVariable [QGVAR(setting), SETTING_OFF];

	if (_currentSetting != SETTING_OFF) then {
		[_vehicle, _currentSetting, true, true] call GVAR(fnc_applySetting);
	};

	[
		_vehicle,
		INTERACTED,
		{
			params ["_vehicle", "_interactionType"];

			private _previousSetting = _vehicle getVariable [QGVAR(setting), SETTING_OFF];
			private _setting = [SETTING_OFF, _interactionType] select (_interactionType != _previousSetting);
			[_vehicle, _setting] call GVAR(fnc_applySetting);
		}
	] call BIS_fnc_addScriptedEventHandler;

	[_vehicle] spawn GVAR(automaticHazards);
};

GVAR(fnc_applySetting) = {
	params ["_vehicle", "_setting", ["_force", false], ["_localOnly", false]];

	private _previousSetting = _vehicle getVariable [QGVAR(setting), SETTING_OFF];

	if (_setting != _previousSetting || _force) then {
		_vehicle setVariable [QGVAR(setting), _setting, !_localOnly];

		if (_localOnly) then {
			[
				_vehicle,
				SETTING_CHANGED,
				[_vehicle, _setting, _previousSetting]
			] call BIS_fnc_callScriptedEventHandler;
		} else {
			[
				_vehicle,
				SETTING_CHANGED,
				[_vehicle, _setting, _previousSetting]
			] remoteExecCall ["BIS_fnc_callScriptedEventHandler", 0, false];
		};
	};
};

GVAR(automaticHazards) = {
	params ["_vehicle"];

	waitUntil {
		sleep 0.5;
		!alive _vehicle || !canMove _vehicle
	};

	if (alive _vehicle && local _vehicle) then {
		[_vehicle, SETTING_HAZARDS] call GVAR(fnc_applySetting);
	};

	if (alive _vehicle) then {
		waitUntil {
			sleep 1;
			canMove _vehicle
		};

		[_vehicle] spawn GVAR(automaticHazards);
	};
};
