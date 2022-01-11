#include "macros.hpp"

GVAR(config) = createHashMap;
GVAR(fnc_loadConfig) = {
	{
		private _config = parseSimpleArray preprocessFile (BASE_DIR + "config\" + _x);
		GVAR(config) merge (createHashMapFromArray _config);
	} forEach ["bis.sqf", "uk3cb.sqf", "extras.sqf"];

	{
		GVAR(config) set [_x, createHashMapFromArray (GVAR(config) get _x)];
	} forEach keys GVAR(config);
};
call GVAR(fnc_loadConfig);

GVAR(managedVehicles) = [];
GVAR(fnc_initVehicle) = {
	params ["_vehicle"];

	if (_vehicle in GVAR(managedVehicles)) exitWith {};

	private _config = GVAR(config) get (typeOf _vehicle);

	if (isNil "_config") exitWith {};

	[_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\actions.sqf");
	[_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\audio.sqf");
	[_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\breaker.sqf");
	[_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\interaction.sqf");
	[_vehicle] call compile preprocessFileLineNumbers (BASE_DIR + "modules\debug.sqf");
	[_vehicle, _config] call compile preprocessFileLineNumbers (BASE_DIR + "modules\lights.sqf");

	GVAR(managedVehicles) pushBack _vehicle;
};

private _vehicles = [];

if (!isNil "_this") then {
	_vehicles = _this;
} else {
	_vehicles = vehicles select {typeOf _x in GVAR(config)};
};

{
	private _v = _x;

	if (_x isEqualType "") then {
		{
			[_x] call GVAR(fnc_initVehicle);
		} forEach (vehicles select {typeOf _x == _v})
	};
	
	if (_x isEqualType objNull) then {
		[_x] call GVAR(fnc_initVehicle);
	};
} forEach _vehicles;

[] spawn GVAR(listenKeyDown);
call compile preprocessFileLineNumbers (BASE_DIR + "modules\dashboard.sqf");
call compile preprocessFileLineNumbers (BASE_DIR + "modules\about.sqf");
addMissionEventHandler [
	"Draw3D",
	{
		{
			if (!alive _x) then {
				GVAR(managedVehicles) = GVAR(managedVehicles) select {alive _x};
				[_x, SETTING_OFF, true] call GVAR(fnc_applySetting);
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
};
