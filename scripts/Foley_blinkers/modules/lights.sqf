#include "..\macros.hpp"
#define BASE_LIGHT_INTENSITY 1000

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
	_light setLightFlareSize 0.33;
	_light setLightFlareMaxDistance 5000;
	_light setLightDayLight true;
	_light setLightConePars [270, 120, 1];
	_light attachTo [_vehicle, _offset];
	_light setVectorDirAndUp [([0, 0, 0] vectorFromTo _offset), [0, 0, 1]];
	
	private _tracker = "Sign_sphere25cm_F" createVehicleLocal (getPos _vehicle);
	hideObject _tracker;
	_tracker attachTo [_vehicle, _offset];

	_vehicle setVariable [QGVAR(light) + _x, _light];
	_vehicle setVariable [QGVAR(lightOffset) + _x, _offset];
	_vehicle setVariable [QGVAR(lightTracker) + _x, _tracker];
} forEach ["FL", "FR", "RL", "RR"];

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

GVAR(fnc_getLightIntensity) = {
	(date call BIS_fnc_sunriseSunsetTime) params ["_sunrise", "_sunset"];

	private _sunrise = _sunrise - 0.75;
	private _sunset = _sunset + 0.75;
	private _intensityMultiplier = 1;

	if (dayTime > _sunrise && dayTime < _sunset) then {
		private _hoursDiff = (dayTime - _sunrise) min (_sunset - dayTime) min 3;
		_intensityMultiplier = 20 ^ _hoursDiff;
	};

	BASE_LIGHT_INTENSITY * _intensityMultiplier
};

[
	_vehicle,
	BREAKER,
	{
		params ["_vehicle", "_circuitClosed"];

		private _effectiveSetting = _vehicle getVariable [QGVAR(setting), SETTING_OFF];

		if (!_circuitClosed) then {
			_effectiveSetting = SETTING_OFF;
		};

		(GVAR(lightsLookup) get _effectiveSetting) params ["_lightsOn", "_lightsOff"];
		private _intensity = call GVAR(fnc_getLightIntensity);

		{
			private _light = _vehicle getVariable [(QGVAR(light) + _x), objNull];
			_light setLightIntensity _intensity;
		} forEach _lightsOn;
		
		{
			private _light = _vehicle getVariable [(QGVAR(light) + _x), objNull];
			_light setLightIntensity 0;
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

		if (_recalculateAdjustment) then {
			private _diff = _posASL vectorDiff (getPosASLVisual _tracker);
			_adjustment = _adjustment vectorAdd (_diff vectorMultiply 0.999);
			_vehicle setVariable [QGVAR(lightAdjustment) + _x, _adjustment];
		};
	} forEach ["FL", "FR", "RL", "RR"];
};
