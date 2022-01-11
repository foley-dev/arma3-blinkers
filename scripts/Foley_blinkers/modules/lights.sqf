#include "..\macros.hpp"
#define LIGHT_RELATIVE_INTENSITY 500
#define MAX_DYNAMIC_LIGHTS 3

params ["_vehicle", "_config"];

{
	private _offset = _config get _x;

	if (isNil "_offset") then {continue;};
	if !(_offset isEqualTypeArray [0, 0, 0]) then {continue;};

	private _light = "#lightreflector" createVehicleLocal (getPos _vehicle);
	_light setLightIntensity 0;
	_light setLightAttenuation [0.001, 100, 100, 100, 0.001, 0.002];
	_light setLightColor [1.0, 0.75, 0.0]; 
	_light setLightUseFlare true;
	_light setLightFlareSize 0.2;
	_light setLightFlareMaxDistance 5000;
	_light setLightDayLight true;
	_light setLightConePars [270, 120, 1];
	_light attachTo [_vehicle, _offset];
	_light setVectorDirAndUp [([0, 0, 0] vectorFromTo _offset), [0, 0, 1]];
	
	private _tracker = "Sign_sphere25cm_F" createVehicleLocal (getPos _vehicle);
	hideObject _tracker;

	_vehicle setVariable [QGVAR(light) + _x, _light];
	_vehicle setVariable [QGVAR(lightOffset) + _x, _offset];
	_vehicle setVariable [QGVAR(lightTracker) + _x, _tracker];
} forEach ["FL", "FR", "RL", "RR"];

if (isNil QGVAR(priorityLights)) then {
	GVAR(priorityLights) = [];
};

GVAR(fnc_rankLights) = {
	private _sorted = [GVAR(activeLights), [positionCameraToWorld [0, 0, 0]], {_input0 distanceSqr _x}, "ASCEND"] call BIS_fnc_sortBy;
	private _priority = [];

	{
		if (count _priority >= MAX_DYNAMIC_LIGHTS) then {
			break;
		};

		private _light = _x;	
		private _distance = (positionCameraToWorld [0, 0, 0]) distance _light;

		if (_distance > 1000) then {
			break;
		};

		private _screenPos = worldToScreen getPosVisual _light;
		private _outsideScreen = _screenPos isEqualTo [] || {
			_screenPos # 0 > safeZoneX + safeZoneW || _screenPos # 0 < safeZoneX ||
			_screenPos # 1 > safeZoneY + safeZoneH || _screenPos # 1 < safeZoneY
		};

		if (_outsideScreen) then {
			continue;
		};

		if (_distance < 100) then {
			// This check is skipped for distant lights
			private _lightPosASL = (getPosASLVisual _light) vectorAdd (
				((getPosASLVisual _light) vectorFromTo (AGLToASL positionCameraToWorld [0, 0, 0])) vectorMultiply 0.2
			);
			private _canSee = [player, "VIEW"] checkVisibility [AGLToASL positionCameraToWorld [0, 0, 0], _lightPosASL];

			if (_canSee < 0.01) then {
				continue;
			};
		};

		_priority pushBack _light;
	} forEach _sorted;

	GVAR(priorityLights) = _priority;

	// {
	// 	private _color = [
	// 		[0, 1, 0, 1],
	// 		[1, 1, 0, 1],
	// 		[0, 0, 0, 0.1]
	// 	] select _forEachIndex;

	// 	{
	// 		drawLine3D [positionCameraToWorld [0.1, -1.5, 0], getPosVisual _x, _color];
	// 	} forEach _x;
	// } forEach [_priority];

	// hintSilent (["priority", count _priority, "\nall lights", count GVAR(activeLights), "\nall particles", count GVAR(activeParticles)] joinString "\n");
};

GVAR(lightsLookup) = [
	SETTING_OFF,
	SETTING_LEFT,
	SETTING_RIGHT,
	SETTING_HAZARDS
] createHashMapFromArray [
	[[], ["FL","FR","RL","RR"]],
	[["FL","RL"], ["FR","RR"]],
	[["FR","RR"], ["FL","RL"]],
	[["FL","FR","RL","RR"], []]
];

if (isNil QGVAR(activeLights)) then {
	GVAR(activeLights) = [];
};

if (isNil QGVAR(activeParticles)) then {
	GVAR(activeParticles) = [];
};

[
	_vehicle,
	BREAKER,
	{
		params ["_vehicle", "_circuitClosed"];

		private _setting = _vehicle getVariable [QGVAR(setting), SETTING_OFF];
		private _effectiveSetting = _setting;

		if (!_circuitClosed) then {
			_effectiveSetting = SETTING_OFF;
		};

		(GVAR(lightsLookup) get _effectiveSetting) params ["_lightsOn", "_lightsOff"];
		private _intensity = ((getLighting select 1) max 1) * LIGHT_RELATIVE_INTENSITY;
		private _distance = (positionCameraToWorld [0, 0, 0]) distance _vehicle;

		{
			private _light = _vehicle getVariable [QGVAR(light) + _x, objNull];
			GVAR(activeLights) pushBackUnique _light;

			private _particleSpec = [_vehicle, _vehicle getVariable (QGVAR(lightOffset) + _x)];
			GVAR(activeParticles) pushBackUnique _particleSpec;
		} forEach _lightsOn;
		
		call GVAR(fnc_rankLights);

		{
			private _light = _vehicle getVariable [(QGVAR(light) + _x), objNull];

			if (_light in GVAR(priorityLights)) then {
				_light setLightIntensity _intensity;
			} else {
				_light setLightIntensity 0;
			};
		} forEach _lightsOn;
		
		{
			private _light = _vehicle getVariable [(QGVAR(light) + _x), objNull];
			_light setLightIntensity 0;
			GVAR(activeLights) deleteAt (GVAR(activeLights) find _light);
			
			private _particleSpec = [_vehicle, _vehicle getVariable (QGVAR(lightOffset) + _x)];
			GVAR(activeParticles) deleteAt (GVAR(activeParticles) find _particleSpec);
		} forEach _lightsOff;
	}
] call BIS_fnc_addScriptedEventHandler;

GVAR(fnc_adjustOffsets) = {
	params ["_vehicle", "_recalculateAdjustment"];

	{
		private _light = _vehicle getVariable (QGVAR(light) + _x);
		private _offset = _vehicle getVariable (QGVAR(lightOffset) + _x);
		private _tracker = _vehicle getVariable (QGVAR(lightTracker) + _x);

		_tracker setPosASL getPosASLVisual _light;

		private _posASL = AGLToASL (_vehicle modelToWorldVisual _offset);
		private _adjustment = _vehicle getVariable [QGVAR(lightAdjustment) + _x, [0, 0, 0]];
		private _adjustedPosASL = _posASL vectorAdd _adjustment;
		_light setPosASL _adjustedPosASL;

		if (_recalculateAdjustment && _light in GVAR(activeLights)) then {
			private _diff = _posASL vectorDiff (getPosASLVisual _tracker);
			_adjustment = _adjustment vectorAdd (_diff vectorMultiply 0.999);
			_vehicle setVariable [QGVAR(lightAdjustment) + _x, _adjustment];
		};
	} forEach ["FL", "FR", "RL", "RR"];
};

GVAR(fnc_dropParticles) = {
	{
		_x params ["_vehicle", "_offset"];

		private _distance = _vehicle distance positionCameraToWorld [0, 0, 0];

		if (_distance > 2000) then {
			continue;
		};

		private _size = 0.4;

		if (_distance < 30) then {
			_size = linearConversion [0, 30, _distance, 0.1, 0.4, true];
		} else {
			_size = linearConversion [30, 200, _distance, 0.4, 1.0, true];
		};

		private _illumination = linearConversion [0, 100, sqrt (getLighting select 1), 5, 100, true];
	
		drop [
			[
				"\A3\data_f\kouleSvetlo",
				1,
				0,
				1
			],
			"",
			"Billboard",
			1,
			(1.01 / diag_fpsmin),
			_offset,
			[0, 0, 0],
			1,
			1.275,
			1,
			0,
			[_size], 
			[[0.6, 0.35, 0, 1]], 
			[1000],
			1,
			0,
			"",
			"",
			_vehicle,
			0,
			false,
			-1,
			[[0.6, 0.35, 0, 1] apply {_x * _illumination}]
		];
	} forEach GVAR(activeParticles);
};
