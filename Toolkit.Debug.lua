-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Toolkit.Debug library extention
-- Provide help to trace and debug lua code on Fibaro HC2
-- Tested on Lua 5.1 with HC2 3.572 beta
--
-- Copyright 2013 Jean-christophe Vermandé
--
-- Version 1.0.1 [12-12-2013]
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
if not Toolkit.Debug then Toolkit.Debug = { 
  __header = "Toolkit.Debug",
  __version = "1.0.1",
  -- The os.clock function returns the number of seconds of CPU time for the program.
  __clocks = {["fragment"]=os.clock(), ["all"]=os.clock()},
  -- benchmarkPoint(name)
  -- (string)	name: name of benchmark point
  benchmarkPoint = (function(self, name)
    __clocks[name] = os.clock();
  end),
  -- benchmark(message, template, name, reset)
  -- (string) 	message: value to display, used by template
  -- (string) 	template: template used to diqplay message
  -- (string) 	name: name of benchmark point
  -- (boolean) 	reset: true to force reset clock
  benchmark = (function(self, message, template, name, reset)
    Toolkit.assertArg("message", message, "string");
    Toolkit.assertArg("template", message, "string");
    if (reset~=nil) then Toolkit.assertArg("reset", reset, type(true)); end
    Toolkit:traceEx("yellow", "Benchmark ["..message.."]: "..
      string.format(template, os.clock() - self.__clocks[name]));
    if (reset==true) then self.__clocks[name] = os.clock(); end
  end)
};
Toolkit:traceEx("red", Toolkit.Debug.__header.." loaded in memory...");
-- benchmark code
if (Toolkit.Debug) then Toolkit.Debug:benchmark(Toolkit.Debug.__header.." lib", "elapsed time: %.3f cpu secs\n", "fragment", true); end ;
end;
