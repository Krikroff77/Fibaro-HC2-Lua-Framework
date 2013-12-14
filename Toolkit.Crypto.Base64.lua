-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Toolkit.Crypto.Base64 library extention part of Toolkit.Crypto
-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2
--
-- Version 1.0.0 [12-01-2013]
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
if not Toolkit.Crypto then error("You must add Toolkit.Crypto", 2) end
if not Toolkit.Crypto.Base64 then Toolkit.Crypto.Base64 = {  
  __header = "Toolkit.Crypto.Base64",
  __version = "1.0.0",
  __c = Toolkit.chars,
  -- encoding
  encode = (function(self, data)
      Toolkit.assertArg("data", data, "string");
      return ((data:gsub('.', function(x) 
         local r,b='',x:byte();
         for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
         return r;
       end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
         if (#x < 6) then return '' end
         local c=0;
         for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
         return self.__c:sub(c+1,c+1)
       end)..({ '', '==', '=' })[#data%3+1]);
  end),
  -- decoding
  decode = (function(self, data)
      Toolkit.assertArg("data", data, "string");
      data = string.gsub(data, '[^'..b..'=]', '')
      return (data:gsub('.', function(x)
         if (x == '=') then return '' end
         local r,f='',(self.__c:find(x)-1);
         for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
         return r;
       end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
         if (#x ~= 8) then return '' end
         local c=0;
         for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
         return string.char(c);
       end))
    end)
};
Toolkit:traceEx("red", Toolkit.Crypto.Base64.__header.." loaded in memory...");
  -- benchmark code
if (Toolkit.Debug) then Toolkit.Debug:benchmark(Toolkit.Crypto.Base64.__header.." lib", "elapsed time: %.3f cpu secs\n", "fragment", true); end;
end;
