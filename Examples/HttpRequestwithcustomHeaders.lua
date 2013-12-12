-------------------------------------------------------------------------------------------
-- Make http request with custom headers
-- Required library: Toolkit.Net 
-- Copyright 2013 Jean-christophe Vermandé
-------------------------------------------------------------------------------------------

-- set Toolkit.Net.* trace enabled
Toolkit.Net.isTraceEnabled = true;
-- create new client object
local httpClient = Toolkit.Net.HttpRequest("mafreebox.freebox.fr", 80);
-- set timeout to 1 second
httpClient:setReadTimeout(1000);
-- make the request
local response, status, errorCode = httpClient:request("GET", "/api/v1/call/log/", {
    "User-Agent: FibaroHC2/1.0",
    "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3",
    "Accept-Encoding: deflate",
    "Accept-Charset: utf-8",
    "X-Fbx-App-Auth: lkjsDfs544Z5SDFdfklsjdf234345ZFskljdfµ345fs+==",
    "X-Fbx-App-Id: plugin.freebox.fibaro"
  });
-- disconnect socket and release memory...
httpClient:disconnect();
httpClient:dispose();
-- check for error
if errorCode == 0 then
  -- if no error and if status is ok...
  if tonumber(status) == 200 then
    -- decode json with builtin fibaro method.
    local jsonTable = json.decode(response);
    if (jsonTable.success == true ) then
      Toolkit:trace("Call - List every calls with success");*
      -- play with the results...
      for k, v in ipairs(jsonTable.result) do
        Toolkit:trace("datetime: %s - call number: %s", os.date("%c", v.datetime), v.number);
      end
    else
      Toolkit:trace("Call - List every calls failled");
    end
  else
    Toolkit:trace("status: "..status);
  end
else
  Toolkit:trace("Communication error");
end
