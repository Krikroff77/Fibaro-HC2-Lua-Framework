-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Toolkit.Crypto library extention
-- Provide methods to encrypt / decrypt data on Fibaro hc2
-- Tested on Lua 5.1 with HC2 3.572 beta
--
-- Copyright 2013 Jean-christophe Vermandé
--
-- Version 1.0.0 [12-01-2013]
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
if not Toolkit then error("You must add Toolkit", 2) end
if not Toolkit.Crypto then Toolkit.Crypto = {  
  __header = "Toolkit.Crypto",
  __version = "1.0.0",
  hexToBinary = (function(hex)
     Toolkit.assertArg("hex", hex, "string");
     return hex:gsub('..', function(hexval) return string.char(tonumber(hexval, 16)) end);
  end),
  binaryToHex = {
    ["0000"] = "0", ["0001"] = "1", ["0010"] = "2", ["0011"] = "3",
    ["0100"] = "4", ["0101"] = "5", ["0110"] = "6", ["0111"] = "7",
    ["1000"] = "8", ["1001"] = "9", ["1010"] = "a", ["1011"] = "b",
    ["1100"] = "c", ["1101"] = "d", ["1110"] = "e", ["1111"] = "f",
  },
  hexToBits = {
    ["0"] = { false, false, false, false },
    ["1"] = { false, false, false, true  },
    ["2"] = { false, false, true,  false },
    ["3"] = { false, false, true,  true  },
    ["4"] = { false, true,  false, false },
    ["5"] = { false, true,  false, true  },
    ["6"] = { false, true,  true,  false },
    ["7"] = { false, true,  true,  true  },
    ["8"] = { true,  false, false, false },
    ["9"] = { true,  false, false, true  },
    ["A"] = { true,  false, true,  false },
    ["B"] = { true,  false, true,  true  },
    ["C"] = { true,  true,  false, false },
    ["D"] = { true,  true,  false, true  },
    ["E"] = { true,  true,  true,  false },
    ["F"] = { true,  true,  true,  true  },
    ["a"] = { true,  false, true,  false },
    ["b"] = { true,  false, true,  true  },
    ["c"] = { true,  true,  false, false },
    ["d"] = { true,  true,  false, true  },
    ["e"] = { true,  true,  true,  false },
    ["f"] = { true,  true,  true,  true  },
  },
  -- Given a string of 8 hex digits, return a W32 object representing that number
  fromHex = (function(hex)        
    Toolkit.assertArg("hex", hex, "string");
    assert(string.lower(hex):match("^["..Toolkit.hex.."]+$"));
    assert(#hex == 8);
    local W32 = { };
    for letter in hex:gmatch('.') do
      local b = Toolkit.Crypto.hexToBits[letter];
      assert(b);
      table.insert(W32, 1, b[1]);
      table.insert(W32, 1, b[2]);
      table.insert(W32, 1, b[3]);
      table.insert(W32, 1, b[4]);
    end
    return W32;
  end),
  toHex = (function(num)
    local s = "";
    while num > 0 do
        local mod = math.fmod(num, 16);
        s = string.sub(Toolkit.__hex, mod+1, mod+1) .. s;
        num = math.floor(num / 16);
    end
    if s == '' then s = '0' end
    return s;
  end),
  asHEX = (function(table)
     local hex = "";
     local i = 1;
     while i < #table do
        local binary = (table[i + 3] and '1' or '0')..(table[i + 2] and '1' or '0')..
          (table[i + 1] and '1' or '0')..(table[i + 0] and '1' or '0');
        hex = Toolkit.Crypto.binaryToHex[binary] .. hex;
        i = i + 4;
     end
     return hex;
  end)
};
Toolkit:traceEx("red", Toolkit.Crypto.__header.." loaded in memory...");
-- benchmark code
if (Toolkit.Debug) then Toolkit.Debug:benchmark(Toolkit.Crypto.__header.." lib", "elapsed time: %.3f cpu secs\n", "fragment", true); end;
end;
