-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Toolkit.Net library extention
-- Toolkit.Net.HttpRequest provide http request with advanced functions
-- Tested on Lua 5.1 with HC2 3.572 beta
--
-- Copyright 2013 Jean-christophe Vermandé
-- Thanks to rafal.m for the decodeChunks function used when reponse body is "chunked"
-- http://en.wikipedia.org/wiki/Chunked_transfer_encoding
--
-- Version 1.0.2 [Dec 12, 2013]
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
if not Toolkit then error("You must add Toolkit", 2) end
if not Toolkit.Net then Toolkit.Net = {
  -- private properties
  __header = "Toolkit.Net",
  __version = "1.0.2",
  __cr = string.char(13),
  __lf = string.char(10),
  __crLf = string.char(13, 10),
  __host = nil,
  __port = nil,
  -- private methods
  __trace = (function(v, ...)
    if (Toolkit.Net.isTraceEnabled) then Toolkit:trace(v, ...) end
  end),
  __writeHeader = (function(socket, data)
    assert(tostring(data) or data==nil or data=="", "Invalid header found: "..data);
    local head = tostring(data);
    socket:write(head..Toolkit.Net.__crLf);
    Toolkit.Net.__trace("%s.%s::request > Add header [%s]", 
      Toolkit.Net.__header, Toolkit.Net.__Http.__header, head);
  end),
  __decodeChunks = (function(a)
    resp = "";
    line = "0";
    lenline = 0;
    len = string.len(a);
    i = 1;
    while i<=len do
      c = string.sub(a, i, i);
      if (lenline==0) then
        if (c==Toolkit.Net.__lf) then
          lenline = tonumber(line, 16);
          if (lenline==null) then
            lenline = 0;
          end
          line = 0;
        elseif (c==Toolkit.Net.__cr) then
          lenline = 0;
        else
          line = line .. c;
        end
      else
        resp = resp .. c;
        lenline = lenline - 1;
      end
      i = i + 1;
    end
    return resp;
  end),
  __readHeader = (function(data)
    if data == nil then
      error("Couldn't find header");
    end
    local buffer = "";
    local headers = {};
    local i, len = 1, string.len(data);
    while i<=len do
      local a = data:sub(i,i) or "";
      local b = data:sub(i+1,i+1) or "";
      if (a..b == Toolkit.Net.__crLf) then
        i = i + 1;
        table.insert(headers, buffer);
        buffer = "";
      else
        buffer = buffer..a;     
      end
      i = i + 1;
    end
    return headers;
  end),
  __readSocket = (function(socket)
    local err, len = 0, 1;
    local buffer, data = "", "";
    while (err==0 and len>0) do
      data, err = socket:read();
      len = string.len(data);
      buffer = buffer..data;
    end
    return buffer, err;
  end),
  __Http = {
    __header = "HttpRequest",
    __version = "1.0.2",    
    __tcpSocket = nil,
    __timeout = 0,
    __waitBeforeReadMs = 25,
    __isConnected = false,
    __isChunked = false,
    __url = nil,
    __method = "GET",  
    __headers = {},
    __body = nil,
    __authorization = nil,
    -- Toolkit.Net.HttpRequest:setBasicAuthentication(username, password)
    -- Sets basic credentials for all requests.
    -- username (string) – credentials username
    -- password (string) – credentials password
    setBasicAuthentication = (function(self, username, password)
      Toolkit.assertArg("username", username, "string");
      Toolkit.assertArg("password", password, "string");
      --see: http://en.wikipedia.org/wiki/Basic_access_authentication
      self.__authorization = Toolkit.Crypto.Base64:encode(tostring(username..":"..password));
    end),
    -- Toolkit.Net.HttpRequest:setBasicAuthenticationEncoded(base64String)
    -- Sets basic credentials already encoded. Avoid direct exposure for information.
    -- base64String (string)	- username and password encoded with base64
    setBasicAuthenticationEncoded = (function(self, base64String)
      Toolkit.assertArg("base64String", base64String, "string");
      self.__authorization = base64String;
    end),
    -- Toolkit.Net.HttpRequest:setWaitBeforeReadMs(ms)
    -- Sets ms
    -- ms (integer) – timeout value in milliseconds
    setWaitBeforeReadMs = (function(self, ms)
      Toolkit.assertArg("ms", ms, "integer");
      self.__waitBeforeReadMs = ms;
      Toolkit.Net.__trace("%s.%s::setWaitBeforeReadMs > set to %d ms", 
        Toolkit.Net.__header, Toolkit.Net.__Http.__header, ms);
    end),
    -- Toolkit.Net.HttpRequest.getWaitBeforeReadMs()
    -- Returns the value in milliseconds
    getWaitBeforeReadMs = (function(self)
      return self.__waitBeforeReadMs;
    end),
    -- Toolkit.Net.HttpRequest.setReadTimeout(ms)
    -- Sets timeout
    -- ms (integer) – timeout value in milliseconds
  	setReadTimeout = (function(self, ms)
      Toolkit.assertArg("ms", ms, "number");
      self.__timeout = ms;
      Toolkit.Net.__trace("%s.%s::setReadTimeout > Timeout set to %d ms", 
        Toolkit.Net.__header, Toolkit.Net.__Http.__header, ms);
    end),
    -- Toolkit.Net.HttpRequest.getReadTimeout()
    -- Returns the timeout value in milliseconds
    getReadTimeout = (function(self)
      return self.__timeout;
    end),
    -- Toolkit.Net.HttpRequest:disconnect()
    -- Disconnect the socket used by httpRequest
    disconnect = (function(self)
      self.__tcpSocket:disconnect();
      self.__isConnected = false;
      Toolkit.Net.__trace("%s.%s::disconnect > Connected: %s", 
        Toolkit.Net.__header, Toolkit.Net.__Http.__header, tostring(self.__isConnected));
    end),
    -- Toolkit.Net.HttpRequest:request(method, uri, headers, body)
    -- method (string)	- method used for the request
    -- uri (string)		- uri used for the request
    -- headers (table)	- headers used for the request (option)
    -- body (string)	- data sent with the request (option)
    request = (function(self, method, uri, headers, body)
      -- validation
      Toolkit.assertArg("method", method, "string");
      assert(method=="GET" or method=="POST" or method=="PUT" or method=="DELETE");
      assert(uri~=nil or uri=="");
      self.__isChunked = false;
      self.__tcpSocket:setReadTimeout(self.__timeout);
      self.__url = uri;
      self.__headers = headers or {};
      self.__body = body or nil;
      
      local r = method.." http://"..Toolkit.Net.__host..self.__url.." HTTP/1.1"..Toolkit.Net.__crLf;
      local p = "";
      if (Toolkit.Net.__port~=nil) then
        p = ":"..tostring(Toolkit.Net.__port);
      end
      local h = "Host: "..Toolkit.Net.__host..p..Toolkit.Net.__crLf;
      -- write to socket headers method a host!
      self.__tcpSocket:write(r);
      self.__tcpSocket:write(h);
      -- add headers if needed
      for i = 1, #self.__headers do
        Toolkit.Net.__writeHeader(self.__tcpSocket, self.__headers[i]);
      end
      if (self.__authorization~=nil) then
        Toolkit.Net.__writeHeader(self.__tcpSocket, "Authorization: Basic "..self.__authorization);
      end
      -- add data in body if needed
      if (self.__body~=nil) then
        Toolkit.Net.__writeHeader(self.__tcpSocket, "Content-Length: "..string.len(self.__body));
        Toolkit.Net.__trace("%s.%s::request > Body length is %d", 
          Toolkit.Net.__header, Toolkit.Net.__Http.__header, string.len(self.__body));
      end
      self.__tcpSocket:write(Toolkit.Net.__crLf..Toolkit.Net.__crLf);
      -- write body
      if (self.__body~=nil) then
        self.__tcpSocket:write(self.__body);
      end
      -- sleep to help process
      fibaro:sleep(self.__waitBeforeReadMs);
      -- wait socket reponse
      local result, err = Toolkit.Net.__readSocket(self.__tcpSocket);
      Toolkit.Net.__trace("%s.%s::receive > Length of result: %d", 
          Toolkit.Net.__header, Toolkit.Net.__Http.__header, string.len(result));
      -- parse data
      local response, status;
      if (string.len(result)>0) then
        local _flag = string.find(result, Toolkit.Net.__crLf..Toolkit.Net.__crLf);
        local _rawHeader = string.sub(result, 1, _flag + 2);
        if (string.len(_rawHeader)) then
          status = string.sub(_rawHeader, 10, 13);
          Toolkit.Net.__trace("%s.%s::receive > Status %s", Toolkit.Net.__header, 
            Toolkit.Net.__Http.__header, status);
          Toolkit.Net.__trace("%s.%s::receive > Length of headers reponse %d", Toolkit.Net.__header, 
            Toolkit.Net.__Http.__header, string.len(_rawHeader));
          __headers = Toolkit.Net.__readHeader(_rawHeader);
          for k, v in pairs(__headers) do
            --Toolkit.Net.__trace("raw #"..k..":"..v)
            if (string.find(string.lower( v or ""), "chunked")) then
              self.__isChunked = true;
              Toolkit.Net.__trace("%s.%s::receive > Transfer-Encoding: chunked", 
          		Toolkit.Net.__header, Toolkit.Net.__Http.__header, string.len(result));
            end
          end
        end
        local _rBody = string.sub(result, _flag + 4);
        --Toolkit.Net.__trace("Length of body reponse: " .. string.len(_rBody));
        if (self.__isChunked) then
          response = Toolkit.Net.__decodeChunks(_rBody);
          err = 0;
        else
          response = _rBody;
          err = 0;
        end
      end
      -- return budy response
      return response, status, err;
    end),
    -- Toolkit.Net.HttpRequest.version()
    -- Return the version
    version = (function()
      return Toolkit.Net.__Http.__version;
    end),
    -- Toolkit.Net.HttpRequest:dispose()
    -- Try to free memory and resources 
    dispose = (function(self)      
      if (self.__isConnected) then
      	self.__tcpSocket:disconnect();
      end
      self.__tcpSocket = nil;
      self.__url = nil;
      self.__headers = nil;
      self.__body = nil;
      if pcall(function () assert(self.__tcpSocket~=Net.FTcpSocket) end) then
        Toolkit.Net.__trace("%s.%s::dispose > Successfully disposed", 
          Toolkit.Net.__header, Toolkit.Net.__Http.__header);
      end
      -- make sure all free-able memory is freed
      collectgarbage("collect");
      Toolkit.Net.__trace("%s.%s::dispose > Total memory in use by Lua: %.2f Kbytes", 
        Toolkit.Net.__header, Toolkit.Net.__Http.__header, collectgarbage("count"));
    end)
  },
  -- Toolkit.Net.isTraceEnabled
  -- true for activate trace in HC2 debug window
  isTraceEnabled = false,
  -- Toolkit.Net.HttpRequest(host, port)
  -- Give object instance for make http request
  -- host (string)	- host
  -- port (intager)	- port
  -- Return HttpRequest object
  HttpRequest = (function(host, port)
    assert(host~=Toolkit.Net, "Cannot call HttpRequest like that!");
    assert(host~=nil, "host invalid input");
    assert(port==nil or tonumber(port), "port invalid input");
    -- make sure all free-able memory is freed to help process
    collectgarbage("collect");
    Toolkit.Net.__host = host;
    Toolkit.Net.__port = port;
    local _c = Toolkit.Net.__Http;
    _c.__tcpSocket = Net.FTcpSocket(host, port);
    _c.__isConnected = true;
    Toolkit.Net.__trace("%s.%s > Total memory in use by Lua: %.2f Kbytes", 
          Toolkit.Net.__header, Toolkit.Net.__Http.__header, collectgarbage("count"));
    Toolkit.Net.__trace("%s.%s > Create Session on port: %d, host: %s", 
          Toolkit.Net.__header, Toolkit.Net.__Http.__header, port, host);
    return _c;
  end),
  -- Toolkit.Net.version()
  version = (function()
    return Toolkit.Net.__version;
  end)
};
Toolkit:traceEx("red", Toolkit.Net.__header.." loaded in memory...");
-- benchmark code
if (Toolkit.Debug) then Toolkit.Debug:benchmark(Toolkit.Net.__header.." lib", "elapsed time: %.3f cpu secs\n", "fragment", true); end;
end;
