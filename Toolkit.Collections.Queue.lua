-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Toolkit.Collections library extention
-- Toolkit.Collections.Queue provide implementation for queue process
-- Tested on Lua 5.1 with HC2 3.580
--
-- Copyright 2014 Jean-christophe Vermandé
-- Inspired by http://www.lua.org/pil/11.4.html
--
-- Version 1.0.0 [01-12-2014]
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
if not Toolkit then error("You must add Toolkit", 2) end
if not Toolkit.Collections then Toolkit.Collections = {} end
if not Toolkit.Collections.Queue then Toolkit.Collections.Queue = {
  -- private properties
  __header = "Toolkit.Collections.Queue",
  __version = "1.0.0",
  __base = {
    __first = 0,
    __count = 0,
    toArray = (function(self)
      local r = {};
      for i=1, self:count() do
        --Tk:trace("add %s in table at pos # %d", tostring(self[i]), i);
        r[i] = self[i];
      end
      return r;
    end),
    clear = (function(self)
      for i=1, self:count() do
        self[i] = nil;        
      end
      self.__first = 0;
      self.__count = 0;
    end),
    enqueue = (function(self, value)
      assert(value ~= nil);
      local n = self.__first + 1;          
      self.__count = self.__count + 1;
      self.__first = n;
      self[n] = value;
      Tk:trace("add at pos %d value with %s type", n, tostring(self[n]));
    end),
    dequeue = (function(self)
       local o = self:peek();
       self[1] = nil;
       self.__first = self.__first - 1;
       self.__count = self.__count -1;
       for i=1, self:count() do
         self[i] = self[i+1];
       end
       return o;
    end),
    contains = (function(self, value)
      assert(value ~= nil);
      for i=1, self:count() do
        if (self[i] == value) then
           return true;
        end
      end
      return false;
    end),
    peek = (function(self)
      return self[1]; 
    end),
    count = (function(self)
      return tonumber(self.__count);
    end),
    clone = (function(self)
      return self;
    end)
  },
  new = (function()
    -- make sure all free-able memory is freed to help process
    collectgarbage("collect");
    return Toolkit.Collections.Queue.__base;
  end),
  -- version()
  version = (function()
    return Toolkit.Collections.Queue.__version;
  end)
};
Toolkit:traceEx("red", Toolkit.Collections.Queue.__header.." loaded in memory...");
-- benchmark code
if (Toolkit.Debug) then Toolkit.Debug:benchmark(Toolkit.Collections.Queue.__header.." lib", "elapsed time: %.3f cpu secs\n", "fragment", true); end;
end;