#define SUNRISE 4
#define SUNSET 20

params ["_vehicle"];


private _locations = _blinkerLocations get (typeOf _vehicle);

if (isNil "_locations") exitWith {};

{
	private _light = "#lightreflector" createVehicleLocal (getPos _vehicle);
	_light setLightIntensity 0;
	_light setLightAttenuation [0.001, 100, 100, 100, 0.001, 0.002];
	_light setLightColor [1.0, 0.75, 0.0]; 
	_light attachTo [_vehicle, _x select 1];
	_light setLightUseFlare true;
	_light setLightFlareSize 0.5;
	_light setLightFlareMaxDistance 5000;
	_light setLightDayLight true;
    _light setLightConePars [270, 120, 1];
    _light setVectorDirAndUp [([0, 0, 0] vectorFromTo (_x select 1)), [0, 0, 1]];


	private _sphere = "Sign_Sphere25cm_F" createVehicleLocal (getPos _vehicle);
	hideObject _sphere;
	_sphere attachTo [_vehicle,  _x select 1];
	
	_vehicle setVariable ["Foley_lightPoint" + (_x select 0), _light];
	_vehicle setVariable ["Foley_lightPoint" + (_x select 0) + "_mempoint", _x select 1];
	_vehicle setVariable ["Foley_lightPoint" + (_x select 0) + "_sphere", _sphere];
	_vehicle setVariable ["Foley_blinkerState", BLINK_NONE];
} forEach _locations;

private _breaker = false;
private _interval = random [0.45, 0.5, 0.55];
private _previousState = BLINK_NONE;

while {alive _vehicle} do {
	private _effectiveState = _vehicle getVariable ["Foley_blinkerState", BLINK_NONE];

	if (_breaker) then {
		_effectiveState = BLINK_NONE;
	};

	_vehicle setVariable ["Foley_blinkerEffectiveState", _effectiveState];

	(_lightLookup get _effectiveState) params ["_lightPointsOn", "_lightPointsOff"];

	private _intensity = 1000;

	if (dayTime > SUNRISE && dayTime < SUNSET) then {
		_intensity = _intensity * 10;
	};
	
	if (dayTime > SUNRISE + 1 && dayTime < SUNSET - 1) then {
		_intensity = _intensity * 10;
	};
	
	if (dayTime > SUNRISE + 2 && dayTime < SUNSET - 2) then {
		_intensity = _intensity * 10;
	};

	{
		private _lightPoint = _vehicle getVariable _x;
		_lightPoint setLightIntensity _intensity;
	} forEach _lightPointsOn;
	
	{
		private _lightPoint = _vehicle getVariable _x;
		_lightPoint setLightIntensity 0;
	} forEach _lightPointsOff;

	_previousState = _effectiveState;
	_breaker = !_breaker;
	sleep _interval;

	// if (_vehicle distance (positionCameraToWorld [0, 0, 0]) > 10000) then {
	// 	sleep 3;
	// };
};
