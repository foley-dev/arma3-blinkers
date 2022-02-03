#include "..\macros.hpp"

GVAR(fnc_addAboutSection) = {
	if (player diarySubjectExists QUOTE(NAMESPACE)) exitWith {};

	player createDiarySubject [QUOTE(NAMESPACE), "Blinkers script"];
	player createDiaryRecord [
		QUOTE(NAMESPACE),
		"<br />
	<font size=18>Blinkers</font><br />
	<br />
	Turn signals script for Arma 3<br />
	<br />
	<font face='RobotoCondensedBold'>Usage</font><br />
	As a driver, you can use turn signals via action menu or keyboard binds:<br />
	<font face='RobotoCondensedBold'>[Z]</font> - toggle left indicator<br />
	<font face='RobotoCondensedBold'>[C]</font> - toggle right indicator<br />
	<font face='RobotoCondensedBold'>[F]</font> - toggle hazard lights<br />
	<br />
	<font size=12>Version: <font face='RobotoCondensedBold'>0.2</font><br />
	Discord: <font face='RobotoCondensedBold'>Foley#1330</font><br />
	GitHub: <font face='RobotoCondensedBold'>https://github.com/foley-dev/arma3-blinkers</font></font>"
	];
};
