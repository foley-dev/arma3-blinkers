#include "..\macros.hpp"
#define LEFT_LIT "<t color='#00ff00' shadowColor='#006600' size='1.1' font='RobotoCondensedBold' shadow='2'>&lt;</t>&#160;&#160;&#160;Left Turn Signal <t color='#777777' size='1' font='RobotoCondensedBold'>[Z]</t>"
#define LEFT_DIM "<t color='#006600' shadowColor='#006600' size='1.1' font='RobotoCondensedBold' shadow='2'>&lt;</t>&#160;&#160;&#160;Left Turn Signal <t color='#777777' size='1' font='RobotoCondensedBold'>[Z]</t>"
#define RIGHT_LIT "<t color='#00ff00' shadowColor='#006600' size='1.1' font='RobotoCondensedBold' shadow='2'>&gt;</t>&#160;&#160;&#160;Right Turn Signal <t color='#777777' size='1' font='RobotoCondensedBold'>[C]</t>"
#define RIGHT_DIM "<t color='#006600' shadowColor='#006600' size='1.1' font='RobotoCondensedBold' shadow='2'>&gt;</t>&#160;&#160;&#160;Right Turn Signal <t color='#777777' size='1' font='RobotoCondensedBold'>[C]</t>"
#define HAZARDS_LIT "<t color='#ff8888' shadowColor='#bb0000' size='1.1' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t> Hazard Lights <t color='#777777' size='1' font='RobotoCondensedBold'>[Z+C]</t>"
#define HAZARDS_DIM "<t color='#bb0000' shadowColor='#bb0000' size='1.1' font='RobotoCondensedBold' shadow='2'>&lt;!&gt;</t> Hazard Lights <t color='#777777' size='1' font='RobotoCondensedBold'>[Z+C]</t>"
#define BASE_PRIORITY 4040

params ["_vehicle"];

private _actionLeft = _vehicle addAction [
	LEFT_DIM,
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
   		[_target, INTERACTED, [_target, INTERACT_LEFT]] call BIS_fnc_callScriptedEventHandler;
	},
	nil,
	BASE_PRIORITY + 0.2,
	false,
	false,
	"",
	"driver _target == _this",
	5
];

private _actionRight = _vehicle addAction [
	RIGHT_DIM,
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
   		[_target, INTERACTED, [_target, INTERACT_RIGHT]] call BIS_fnc_callScriptedEventHandler;
	},
	nil,
	BASE_PRIORITY + 0.1,
	false,
	false,
	"",
	"driver _target == _this",
	5
];

private _actionHazards = _vehicle addAction [
	HAZARDS_DIM,
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
   		[_target, INTERACTED, [_target, INTERACT_HAZARDS]] call BIS_fnc_callScriptedEventHandler;
	},
	nil,
	BASE_PRIORITY,
	false,
	false,
	"",
	"driver _target == _this",
	5
];

_vehicle setVariable [QGVAR(actionLeft), _actionLeft];
_vehicle setVariable [QGVAR(actionRight), _actionRight];
_vehicle setVariable [QGVAR(actionHazards), _actionHazards];

[
	_vehicle,
	BREAKER,
	{
		params ["_vehicle", "_circuitClosed"];

		private _setting = _vehicle getVariable [QGVAR(setting), SETTING_OFF];

		_vehicle setUserActionText [
			_vehicle getVariable QGVAR(actionLeft),
			[LEFT_DIM, LEFT_LIT] select ((_setting == SETTING_LEFT || _setting == SETTING_HAZARDS) && _circuitClosed)
		];

		_vehicle setUserActionText [
			_vehicle getVariable QGVAR(actionRight),
			[RIGHT_DIM, RIGHT_LIT] select ((_setting == SETTING_RIGHT || _setting == SETTING_HAZARDS) && _circuitClosed)
		];

		_vehicle setUserActionText [
			_vehicle getVariable QGVAR(actionHazards),
			[HAZARDS_DIM, HAZARDS_LIT] select (_state == SETTING_HAZARDS && _circuitClosed)
		];
	}
] call BIS_fnc_addScriptedEventHandler;

waitUntil {
	!isNull (findDisplay 46)
};

(findDisplay 46) displayAddEventHandler [
	"KeyDown",
	{
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

		if (_key != KEY_INTERACT_LEFT && _key != KEY_INTERACT_RIGHT) exitWith {};
		if (driver vehicle player != player || (vehicle player) getVariable [QGVAR(actionLeft), -1] != -1) exitWith {};

		private _interactionType = [INTERACT_LEFT, INTERACT_RIGHT] select (_key == KEY_INTERACT_RIGHT);
   		[vehicle player, INTERACTED, [vehicle player, _interactionType]] call BIS_fnc_callScriptedEventHandler;
	}
];
