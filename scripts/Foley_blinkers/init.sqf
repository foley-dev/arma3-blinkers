#include "macros.hpp"

if (!hasInterface) exitWith {};

if (isNil QGVAR(initiated)) then {
	GVAR(initiated) = false;

	call compile preprocessFileLineNumbers (BASE_DIR + "modules\about.sqf");
	call compile preprocessFileLineNumbers (BASE_DIR + "modules\actions.sqf");
	call compile preprocessFileLineNumbers (BASE_DIR + "modules\audio.sqf");
	call compile preprocessFileLineNumbers (BASE_DIR + "modules\breaker.sqf");
	call compile preprocessFileLineNumbers (BASE_DIR + "modules\config.sqf");
	call compile preprocessFileLineNumbers (BASE_DIR + "modules\dashboard.sqf");
	call compile preprocessFileLineNumbers (BASE_DIR + "modules\debug.sqf");
	call compile preprocessFileLineNumbers (BASE_DIR + "modules\interaction.sqf");
	call compile preprocessFileLineNumbers (BASE_DIR + "modules\lights.sqf");

	GVAR(managedVehicles) = [];
	call GVAR(fnc_loadConfig);
	call GVAR(fnc_addAboutSection);
	[] spawn GVAR(initKeydownListener);

	addMissionEventHandler [
		"Draw3D",
		{
			{
				if (!alive _x) then {
					[_x, SETTING_OFF, true] call GVAR(fnc_applySetting);
					GVAR(managedVehicles) = GVAR(managedVehicles) select {alive _x};
					continue;
				};

				[_x] call GVAR(fnc_adjustOffsets);
			} forEach GVAR(managedVehicles);

			call GVAR(fnc_drawDashboard);
		}
	];

	addMissionEventHandler [
		"EachFrame",
		{
			call GVAR(fnc_dropParticles);
		}
	];

	GVAR(initiated) = true;
};

GVAR(fnc_initVehicle) = {
	params ["_vehicle"];

	if (_vehicle in GVAR(managedVehicles)) exitWith {};

	private _config = GVAR(config) get (typeOf _vehicle);

	if (isNil "_config") exitWith {};

	[_vehicle] call GVAR(fnc_initActionsForVehicle);
	[_vehicle] call GVAR(fnc_initAudioForVehicle);
	[_vehicle] call GVAR(fnc_initBreakerForVehicle);
	[_vehicle] call GVAR(fnc_initInteractionsForVehicle);
	[_vehicle, _config] call GVAR(fnc_initLightsForVehicle);

	GVAR(managedVehicles) pushBack _vehicle;
};


private _vehicles = [];

if (isNil "_this") then {
	_vehicles = vehicles select {typeOf _x in GVAR(config)};
} else {
	{
		private _item = _x;

		if (_item isEqualType objNull) then {
			_vehicles pushBackUnique _item;
		};

		if (_item isEqualType "") then {
			{
				_vehicles pushBackUnique _x;
			} forEach (vehicles select {typeOf _x == _item})
		};
	} forEach _this;
};

{
	[_x] call GVAR(fnc_initVehicle);
} forEach _vehicles;
