-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Toolkit Framework, lua library extention for HC2, hope that it will be useful.
-- This Framework is an addon for HC2 Toolkit application in a goal to aid the integration.
-- Tested on Lua 5.1 with Fibaro HC2 3.572 beta
--
-- Version 1.0.1 [Dec 12, 2013]
--
-- Memory is preserved: The code is loaded only the first time in a virtual device 
-- main loop and reloaded only if virtual device is "saved" or application pool restarded.
--
-- Copyright (C) 2013 Jean-Christophe Vermandé
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- at your option) any later version.
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
if not Toolkit then Toolkit = { 
  __header = "Toolkit",
  __version = "1.0.1",
  __luaBase = "5.1.0", 
  __copyright = "Jean-Christophe Vermandé",
  __licence = [[
	Copyright (C) 2013 Jean-Christophe Vermandé

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses></http:>.
  ]],
  __chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
  __hex = "0123456789abcdef",
  __frameworkHeader = (function(self)
    self:traceEx("green", "-------------------------------------------------------------------------");
    self:traceEx("green", "-- HC2 Toolkit Framework version %s", self.__version);
    self:traceEx("green", "-- Current interpreter version is %s", self.getInterpreterVersion());
    self:traceEx("green", "-- Total memory in use by Lua: %.2f Kbytes", self.getCurrentMemoryUsed());
    self:traceEx("green", "-------------------------------------------------------------------------");
  end),
  -- isTraceEnabled
  -- (boolean)	get or set to enable or disable trace
  isTraceEnabled = true,
  -- raiseError(message, level)
  -- message (string)	- message
  -- level (integer)	- level
  raiseError = (function(message, level) error(message, level); end),
  -- assert_arg(name, value, typeOf)
  -- (string)	name: name of argument
  -- (various)	value: value to check
  -- (type)		typeOf: type used to check argument
  assertArg = (function(name, value, typeOf)
    if type(value) ~= typeOf then
      Toolkit.raiseError("argument "..name.." must be "..typeOf, 2);
    end
  end),
  -- trace(value, args...)
  -- (string)	value: value to trace (can be a string template if args)
  -- (various)	args: data used with template (in value parameter)
  trace = (function(self, value, ...)
    if (self.isTraceEnabled) then
      if (value~=nil) then        
        return fibaro:debug(string.format(value, ...));
      end
    end
  end),
  -- traceEx(value, args...)
  -- (string)	color: color use to display the message (red, green, yellow)
  -- (string)	value: value to trace (can be a string template if args)
  -- (various)	args: data used with template (in value parameter)
  traceEx = (function(self, color, value, ...)
    self:trace(string.format('<%s style="color:%s;">%s</%s>', "span", color, string.format(value, ...), "span"));
  end),
  -- getInterpreterVersion()
  -- return current lua interpreter version
  getInterpreterVersion = (function()
    return _VERSION;
  end),
  -- getCurrentMemoryUsed()
  -- return total current memory in use by lua interpreter
  getCurrentMemoryUsed = (function()
    return collectgarbage("count");
  end),
  -- trim(value)
  -- (string)	value: the string to trim
  trim = (function(s)
    Toolkit.assertArg("value", s, type(""));
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
  end)
};Toolkit:__frameworkHeader();
end;
