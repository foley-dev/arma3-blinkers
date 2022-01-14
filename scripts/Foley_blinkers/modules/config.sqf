#include "..\macros.hpp"

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
