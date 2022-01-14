#include "..\macros.hpp"
#define INTERVAL_RANDOM_DIST [0.45, 0.50, 0.55]

GVAR(fnc_initBreakerForVehicle) = {
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

			if (_vehicle getVariable [QGVAR(breakerWorking), false]) exitWith {};
			_vehicle setVariable [QGVAR(breakerWorking), true];

			[_vehicle, _currentSetting] spawn {
				params ["_vehicle", "_currentSetting"];

				private _interval = _vehicle getVariable QGVAR(interval);

				if (isNil "_interval") then {
					_interval = random INTERVAL_RANDOM_DIST;
					_vehicle setVariable [QGVAR(interval), _interval, local _vehicle];
				};

				private _circuitClosed = true;

				while {alive _vehicle && (_vehicle getVariable [QGVAR(setting), SETTING_OFF]) != SETTING_OFF} do {
					[
						_vehicle,
						BREAKER,
						[_vehicle, _circuitClosed]
					] call BIS_fnc_callScriptedEventHandler;
					_vehicle setVariable [QGVAR(circuitClosed), _circuitClosed];

					sleep _interval;
					_circuitClosed = !_circuitClosed;
				};
				
				_vehicle setVariable [QGVAR(breakerWorking), false];
			};
		}
	] call BIS_fnc_addScriptedEventHandler;
};
