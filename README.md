# arma3-blinkers

Turn signals script for Arma 3

## Features

* 3D dashboard and sound effects for 1st person view
* Keyboard binds:
    * <kbd>Z</kbd> - left indicator
    * <kbd>C</kbd> - right indicator
    * <kbd>F</kbd> - hazard lights
* Multiplayer support
* Optimized to handle many vehicles even on low graphics settings

## Quick start

1. Copy the `Foley_blinkers` folder to your scenario: `scripts\Foley_blinkers\`
2. Add to your scenario's `init.sqf`:
    ```sqf
    execVM "scripts\Foley_blinkers\init.sqf";
    ```

## Advanced usage

### Initialization

If you need to limit which vehicles should be affected, you can pass an array to the init script, for example:

```sqf
[myCar, myCar2, "I_Truck_02_box_F"] execVM "scripts\Foley_blinkers\init.sqf";
```

will initiate blinkers for `myCar`, `myCar2` and all vehicles of type `"I_Truck_02_box_F"`.

### Turn on programatically

You can turn the blinkers on and off by calling a function:

```sqf
[myCar, 1] call Foley_blinkers_fnc_applySetting;  // left
[myCar, 2] call Foley_blinkers_fnc_applySetting;  // right
[myCar, 3] call Foley_blinkers_fnc_applySetting;  // hazards
[myCar, 4] call Foley_blinkers_fnc_applySetting;  // off
```

In multiplayer, this will propagate to all clients.\
Before calling this function, ensure that the script has already been  initialized on all machines.

### Events

You can hook into the following events to execute your code when an action takes place.

* `Foley_blinkers_interacted`\
    Triggered when a player interacts via action menu or keyboard shortcut.

    ```sqf
    [
        myCar,
        "Foley_blinkers_interacted",
        {
            params ["_vehicle", "_interactionType"];
        }
    ] call BIS_fnc_addScriptedEventHandler;
    ```

* `Foley_blinkers_settingChanged`\
    Triggered when state of the blinkers is changed as a result of player interaction or a script.
    
    ```sqf
	[
		myCar,
		"Foley_blinkers_settingChanged",
		{
			params ["_vehicle", "_currentSetting", "_previousSetting"];
		}
	] call BIS_fnc_addScriptedEventHandler;
    ```

* `Foley_blinkers_breaker`\
    Triggered when blinkers or hazards are turned on and circuit breaker changes state (i.e. once every 0.5s)

    ```sqf
	[
		myCar,
		"Foley_blinkers_breaker",
		{
			params ["_vehicle", "_circuitClosed"];
		}
	] call BIS_fnc_addScriptedEventHandler;
    ```

### Configuration

The script comes with configuration for several vehicles. To add support for any other vehicle, edit `scripts\Foley_blinkers\config\extras.sqf`:

```sqf
[
	[
		"SOME_VEHICLE_CLASSNAME",  // classname of the vehicle
		[
			["FL", [0, 0, 0]],  // front-left indicator offset
			["RR", [0, 0, 0]],  // rear-right indicator offset
			["FR", [0, 0, 0]],  // front-right indicator offset
			["RL", [0, 0, 0]],  // rear-left indicator offset
			["DASH", [0, 0, 0]]  // dashboard offset
		]
	]
]
```

**Pull requests are welcome!**
