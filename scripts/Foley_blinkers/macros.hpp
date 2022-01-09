// Common
#define DOUBLES(var1,var2) var1##_##var2
#define QUOTE(var1) #var1
#define NAMESPACE Foley_blinkers
#define GVAR(var1) DOUBLES(NAMESPACE,var1)
#define QGVAR(var1) QUOTE(GVAR(var1))
#define BASE_DIR "scripts\Foley_blinkers\"

// Keybindings

// DIK_Z
#define KEY_INTERACT_LEFT 44

// DIK_C
#define KEY_INTERACT_RIGHT 46

// Enums
#define INTERACT_LEFT 1
#define INTERACT_RIGHT 2
#define INTERACT_HAZARDS 3

#define SETTING_LEFT 1
#define SETTING_RIGHT 2
#define SETTING_HAZARDS 3
#define SETTING_OFF 4

// Events

/*
	[
		_vehicle,
		INTERACTED,
		{
			params ["_vehicle", "_interactionType"];
		}
	] call BIS_fnc_addScriptedEventHandler;
*/
#define INTERACTED QGVAR(interacted)

/*
	[
		_vehicle,
		SETTING_CHANGED,
		{
			params ["_vehicle", "_currentSetting", "_previousSetting"];
		}
	] call BIS_fnc_addScriptedEventHandler;
*/
#define SETTING_CHANGED QGVAR(settingChanged)

/*
	[
		_vehicle,
		BREAKER,
		{
			params ["_vehicle", "_circuitClosed"];
		}
	] call BIS_fnc_addScriptedEventHandler;
*/
#define BREAKER QGVAR(breaker)
