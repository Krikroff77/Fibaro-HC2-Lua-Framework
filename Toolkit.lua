-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Toolkit Framework, lua library extention for HC2, hope that it will be useful.
-- This Framework is an addon for HC2 Toolkit application in a goal to aid the integration.
-- Tested on Lua 5.1 with Fibaro HC2 3.572 beta
--
-- Version 1.0.2 [12-13-2013]
--
-- Use: Toolkit or Tk shortcut to access Toolkit namespace members.
--
-- Example:
-- Toolkit:trace("value is %d", 35); or Tk:trace("value is %d", 35);
-- Toolkit.assertArg("argument", arg, "string"); or Tk.assertArg("argument", arg, "string");
--
-- http://krikroff77.github.io/Fibaro-HC2-Toolkit-Framework/
--
-- Memory is preserved: The code is loaded only the first time in a virtual device 
-- main loop and reloaded only if application pool restarded.
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
  __version = "1.0.2",
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
  __frameworkHeader = (function(self)
    self:traceEx("green", "-------------------------------------------------------------------------");
    self:traceEx("green", "-- HC2 Toolkit Framework version %s", self.__version);
    self:traceEx("green", "-- Current interpreter version is %s", self.getInterpreterVersion());
    self:traceEx("green", "-- Total memory in use by Lua: %.2f Kbytes", self.getCurrentMemoryUsed());
    self:traceEx("green", "-------------------------------------------------------------------------");
  end),
  -- chars
  chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
  -- hex
  hex = "0123456789abcdef",
  -- now(), now("*t", 906000490)
  -- system date shortcut
  now = os.date,
  -- toUnixTimestamp(t)
  -- t (table)		- {year=2013, month=12, day=20, hour=12, min=00, sec=00}
  -- return Unix timestamp
  toUnixTimestamp = (function(t) return os.time(t) end),
  -- fromUnixTimestamp(ts)
  -- ts (string/integer)	- the timestamp
  -- Example : fromUnixTimestamp(1297694343) -> 02/14/11 15:39:03
  fromUnixTimestamp = (function(s) return os.date("%c", ts) end),
  -- currentTime()
  -- return current time
  currentTime = (function() return tonumber(os.date("%H%M%S")) end),
  -- comparableTime(hour, min, sec)
  -- hour (string/integer)
  -- min (string/integer)
  -- sec (string/integer)
  comparableTime = (function(hour, min) return tonumber(string.format("%02d%02d%02d", hour, min, sec)) end),
  -- isTraceEnabled
  -- (boolean)	get or set to enable or disable trace
  isTraceEnabled = true,
  -- isAutostartTrigger()
  isAutostartTrigger = (function() local t = fibaro:getSourceTrigger();return (t["type"]=="autostart") end),
  -- isOtherTrigger()
  isOtherTrigger = (function() local t = fibaro:getSourceTrigger();return (t["type"]=="other") end),
  -- raiseError(message, level)
  -- message (string)	- message
  -- level (integer)	- level
  raiseError = (function(message, level) error(message, level); end),
  -- colorSetToRgbwTable(colorSet)
  -- colorSet (string) - colorSet string
  -- Example: local r, g, b, w = colorSetToRgbwTable(fibaro:getValue(354, "lastColorSet"));
  colorSetToRgbw = (function(self, colorSet)
    self.assertArg("colorSet", colorSet, "string");
    local t, i = {}, 1;
    for v in string.gmatch(colorSet,"(%d+)") do t[i] = v; i = i + 1; end
    return t[1], t[2], t[3], t[4];
  end),
  -- isValidJson(data, raise)
  -- data (string)	- data
  -- raise (boolean)- true if must raise error
  -- check if json data is valid
  isValidJson = (function(self, data, raise)
    self.assertArg("data", data, "string");
    self.assertArg("raise", raise, "boolean");
    if (string.len(data)>0) then
      if (pcall(function () return json.decode(data) end)) then
        return true;
      else
        if (raise) then self.raiseError("invalid json", 2) end;
      end
    end
    return false;
  end),
  -- assert_arg(name, value, typeOf)
  -- (string)	name: name of argument
  -- (various)	value: value to check
  -- (type)		typeOf: type used to check argument
  assertArg = (function(name, value, typeOf)
    if type(value) ~= typeOf then
      Tk.raiseError("argument "..name.." must be "..typeOf, 2);
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
    Tk.assertArg("value", s, "string");
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
  end),
  -- filterByPredicate(table, predicate)
  -- table (table)		- table to filter
  -- predicate (function)	- function for predicate
  -- Description: filter a table using a predicate
  -- Usage:
  -- local t = {1,2,3,4,5};
  -- local out, n = filterByPredicate(t,function(v) return v.item == true end);
  -- return out -> {2,4}, n -> 2;
  filterByPredicate = (function(table, predicate)
    Tk.assertArg("table", table, "table");
    Tk.assertArg("predicate", predicate, "function");
    local n, out = 1, {};
    for i = 1,#table do
      local v = table[i];
      if (v~=nil) then
        if predicate(v) then
            out[n] = v;
            n = n + 1;    
        end
      end
    end  
    return out, #out;
  end)
};Toolkit:__frameworkHeader();Tk=Toolkit;
end;
