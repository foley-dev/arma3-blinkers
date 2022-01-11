#include "..\macros.hpp"

if (player diarySubjectExists QUOTE(NAMESPACE)) exitWith {};

player createDiarySubject [QUOTE(NAMESPACE), "Blinkers script"];
player createDiaryRecord [
	QUOTE(NAMESPACE),
	"<font size=16>Blinkers</font><br />
by Foley<br />
<br />
<font face='RobotoCondensedLight'>Turn signals script for Arma 3</font><br />
<br />
<font face='RobotoCondensedBold'>Usage</font><br />
As a driver, you can use turn signals via action menu or keyboard binds listed below.<br />
<br />
<font face='EtelkaMonospacePro'>[Z]</font> - toggle left indicator<br />
<font face='EtelkaMonospacePro'>[C]</font> - toggle right indicator<br />
<font face='EtelkaMonospacePro'>[F]</font> - toggle hazard lights<br />
<br />
<font size=12>Version: <font face='RobotoCondensedBold'>0.1</font><br />
Discord: <font face='RobotoCondensedBold'>Foley#1330</font></font><br />
GitHub: <font face='RobotoCondensedBold'>https://github.com/foley-dev/arma3-blinkers</font></font>"
];
