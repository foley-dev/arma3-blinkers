#define BASE_LIGHT_INTENSITY 1000

GVAR(lightsLookup) = [
	SETTING_LEFT,
	SETTING_RIGHT,
	SETTING_HAZARDS,
	SETTING_OFF
] createHashMapFromArray [
	[[], ["FL","FR","RL","RR"]],
	[["FL","RL"], ["FR","RR"]],
	[["FR","RR"], ["FL","RL"]],
	[["FL","FR","RL","RR"], []]
];

GVAR(fnc_createLights) = {
	params ["_vehicle", "_locations"];
};

GVAR(fnc_getLightIntensity) = {
	(date call BIS_fnc_sunriseSunsetTime) params ["_sunrise", "_sunset"];

	
};