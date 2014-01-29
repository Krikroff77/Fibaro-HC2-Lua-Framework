Fibaro-HC2-Toolkit-Framework
============================

This Framework is a lua library for HC2 and is an addon for HC2 Toolkit application in a goal to aid the integration.
Hope that it will be useful!

Current version 1.0.3

Tested on Lua 5.1 with Fibaro HC2 3.5xx

<b>Informations:</b> Memory is preserved: The code is loaded only the first time in a virtual device main loop and reloaded only if application pool restarded.

Use: <b>Toolkit</b> or <b>Tk</b> shortcut to access Toolkit namespace members.
Example: 
          Toolkit:trace("value is %d", 35); <b>or</b> Tk:trace("value is %d", 35);
          Toolkit.assertArg("argument", arg, "string"); <b>or</b> Tk.assertArg("argument", arg, "string");


![Init Debug](https://raw.github.com/Krikroff77/Fibaro-HC2-Toolkit-Framework/master/Images/init.PNG)

Find more information on http://forum.fibaro.com/


Copyright (C) 2013-2014 Jean-Christophe Vermandé

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, orat your option) any later version.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Krikroff77/fibaro-hc2-toolkit-framework/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

