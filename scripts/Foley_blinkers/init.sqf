#include "macros.hpp"

if (isNil QGVAR(initiated)) then {
	GVAR(initiated) = false;

	{	
		call compile preprocessFileLineNumbers (BASE_DIR + _x);
	} forEach [
		"modules\about.sqf",
		"modules\actions.sqf",
		"modules\audio.sqf",
		"modules\breaker.sqf",
		"modules\config.sqf",
		"modules\dashboard.sqf",
		"modules\debug.sqf",
		"modules\interaction.sqf",
		"modules\lights.sqf"
	];

	GVAR(managedVehicles) = [];
	call GVAR(fnc_loadConfig);
		
	if (hasInterface) then {
		call GVAR(fnc_addAboutSection);
		[] spawn GVAR(initKeydownListener);

		addMissionEventHandler [
			"Draw3D",
			{
				call GVAR(fnc_drawDashboard);
			}
		];

		addMissionEventHandler [
			"EachFrame",
			{
				if (isGamePaused) exitWith {};
				
				private _destroyedVehicles = GVAR(managedVehicles) select {!alive _x};

				if (count _destroyedVehicles > 0) then {
					{
						[_x, SETTING_OFF, true] call GVAR(fnc_applySetting);
					} forEach _destroyedVehicles;
					GVAR(managedVehicles) = GVAR(managedVehicles) select {alive _x};
				};

				call GVAR(fnc_dropParticles);
			}
		];
	};

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
	[_vehicle] call GVAR(initDebugForVehicle);
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
