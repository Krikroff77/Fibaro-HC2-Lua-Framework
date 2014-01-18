-------------------------------------------------------------------------------------------
-- Toolkit.Collections.Queue
-- Test
-- Copyright 2014 Jean-christophe Vermandé
-------------------------------------------------------------------------------------------

local Q = Tk.Collections.Queue.new();
Q:enqueue(10);
Q:enqueue(20);
Q:enqueue(30);
Q:enqueue(40);

--local results = Q:clone();

Tk:trace("loop Queue");
for n=1, Q:count() do
  Tk:trace(tostring(Q[n]));
end

Tk:trace("Dequeue %s", tostring(Q:dequeue()));

Tk:trace("Loop after dequeue");
for n=1, Q:count() do
  Tk:trace(tostring(Q[n]));
end

Tk:trace("Check if queue contains 30: %s", tostring(Q:contains(30)));

Tk:trace("Peek Queue");

Tk:trace(tostring(Q:peek()));

Tk:trace("Clear Queue");
Q:clear();

Tk:trace("Length after clear is %s", tostring(Q:count()));
Tk:trace("loop Queue");
for n=1, Q:count() do
  Tk:trace(tostring(Q[n]));
end