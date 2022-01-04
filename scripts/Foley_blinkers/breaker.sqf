#include "..\macros.hpp"
#define INTERVAL_RANDOM_DIST [0.45, 0.5, 0.55]

params ["_vehicle"];

[
	_vehicle,
	SETTING_CHANGED,
	{
		params ["_vehicle", "_currentSetting", "_previousSetting"];

		if (_currentSetting == SETTING_OFF || !alive _vehicle) exitWith {
			[
				_vehicle,
				BREAKER,
				[_vehicle, false]
			] call BIS_fnc_callScriptedEventHandler;
		};

		[_vehicle, _currentSetting] spawn {
			private _circuitClosed = true;

			while {alive _vehicle && _vehicle getVariable [QGVAR(setting), SETTING_OFF] == _currentSetting} do {
				[
					_vehicle,
					BREAKER,
					[_vehicle, _circuitClosed]
				] call BIS_fnc_callScriptedEventHandler;

				sleep INTERVAL_RANDOM_DIST;
				_circuitClosed = !_circuitClosed;
			};
		};
	}
] call BIS_fnc_addScriptedEventHandler;
