#include "..\macros.hpp"
#define GREEN_LIT [0, 1, 0, 1]
#define GREEN_DIM [0, 0.4, 0, 0.67]
#define RED_LIT [1, 0, 0, 1]
#define RED_DIM [0.7, 0, 0, 0.67]
#define REFERENCE_SIZE 0.1
#define REFERENCE_DISTANCE 0.5
#define SYMBOL_LEFT "<"
#define SYMBOL_RIGHT ">"
#define SYMBOL_HAZARDS "<!>"

GVAR(fnc_drawDashboard) = {
	if (!((vehicle player) in GVAR(managedVehicles)) || cameraView != "INTERNAL" || !alive player) exitWith {};

	private _vehicle = vehicle player;
	private _state = _vehicle getVariable [QGVAR(setting), SETTING_OFF];
	private _circuitClosed = _vehicle getVariable [QGVAR(circuitClosed), false];

	if (!_circuitClosed) then {
		_state = SETTING_OFF;
	};

	private _colorLeft = [GREEN_DIM, GREEN_LIT] select (_state == SETTING_LEFT || _state == SETTING_HAZARDS);
	private _colorHazards = [RED_DIM, RED_LIT] select (_state == SETTING_HAZARDS);
	private _colorRight = [GREEN_DIM, GREEN_LIT] select (_state == SETTING_RIGHT || _state == SETTING_HAZARDS);

	if (driver _vehicle != player) then {
		// Dim icons for passengers
		_colorLeft set [3, (_colorLeft select 3) / 2];
		_colorHazards set [3, (_colorHazards select 3) / 2];
		_colorRight set [3, (_colorRight select 3) / 2];
	};

	private _offsetLeft = _vehicle getVariable QGVAR(dashboardOffsetLeft);
	private _offsetHazards = _vehicle getVariable QGVAR(dashboardOffsetHazards);
	private _offsetRight = _vehicle getVariable QGVAR(dashboardOffsetRight);

	if (isNil "_offsetLeft") then {
		private _dashOffset = GVAR(config) get (typeOf _vehicle) get "DASH";

		_offsetLeft = _dashOffset vectorAdd [-0.04, 0, 0];
		_vehicle setVariable [QGVAR(dashboardOffsetLeft), _offsetLeft];

		_offsetHazards = _dashOffset;
		_vehicle setVariable [QGVAR(dashboardOffsetHazards), _offsetHazards];

		_offsetRight = _dashOffset vectorAdd [0.04, 0, 0];
		_vehicle setVariable [QGVAR(dashboardOffsetRight), _offsetRight];
	};

	private _size = REFERENCE_SIZE * (
		REFERENCE_DISTANCE / (
			(positionCameraToWorld [0, 0, 0]) distance (_vehicle modelToWorldVisual _offsetHazards)
		)
	);
	_size = parseNumber (_size toFixed 2);

	drawIcon3D ["", _colorLeft, _vehicle modelToWorldVisual _offsetLeft, 0, 0, 0, SYMBOL_LEFT, 2, _size, "RobotoCondensedBold"];
	drawIcon3D ["", _colorHazards, _vehicle modelToWorldVisual _offsetHazards, 0, 0, 0, SYMBOL_HAZARDS, 2, 0.7 * _size, "RobotoCondensedBold"];
	drawIcon3D ["", _colorRight, _vehicle modelToWorldVisual _offsetRight, 0, 0, 0, SYMBOL_RIGHT, 2, _size, "RobotoCondensedBold"];
};
