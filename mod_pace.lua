local st = require "util.stanza";
local jid = require "util.jid";
local nodeprep = require "util.encodings".stringprep.nodeprep;

-- local get_room_from_jid = module:require "util".get_room_from_jid;

local all_rooms = module:shared "muc/all-rooms";
local live_rooms = module:shared "muc/live_rooms";

local rooms = module:shared "muc/rooms";
if not rooms then
        module:log("error", "This module only works on MUC components!");
        return;
end

local hashes = require "util.hashes";

local function dbg(str)
      module:log("error", "** " .. str)
end

local function fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

local function tohex(buf)
   ret = ""
   for i = 1,string.len(buf) do
      ret = ret .. string.format("%02x", buf:byte(i))
   end
   return ret
end


local function valid_room(secret, room_name)
   parts = string.gmatch(room_name, "[^_]+")
   name = string.lower(parts(1))
   sig_hex = parts(2)

   dbg(string.format("name %s  sig %s", name, sig_hex));

   computed = hashes.hmac_sha1(secret, name);
   computed = tohex(string.sub(computed, 1, 4))

   dbg(string.format("computed %s", computed));

   if computed ~= sig_hex then
      return false
   end

   yy, mm, dd, duration = name:match("(..)(..)(..)-([^-]+)")
   start = os.time{year=2000+yy, month=mm, day=dd}
   delta = os.time() - start
   if delta > duration * 86400 then
      dbg("expired")
      return false
   end

   return true
end


function indent(level)
   local s = "";
   local i;
   for i = 1,level do
      s = s .. '  ';
   end
   return s;
end

tbl_seen = {}

function dump(o, level)
   if level > 3 then
      return indent(level) .. "...\n"
   end

   if type(o) == 'table' then
      if tbl_seen[o] then
	 return indent(level) .. "LOOP\n"
      end
      tbl_seen[o] = true
      s = ""
      for k,v in pairs(o) do
	 idx = k
         if type(k) ~= 'number' then idx = '"'..k..'"' end
	 s = s .. indent(level) .. '[' .. idx .. ']\n'
	 s = s .. dump(v, level+1)
      end
      return s
   else
      s = indent(level) .. tostring(o) .. "\n"
      return s
   end
end

module:hook("presence/full", function(event)
        local stanza = event.stanza;

        if stanza.name == "presence" and stanza.attr.type == "unavailable" then
                return;
        end

	-- Get the room
	local rname = jid.split(stanza.attr.from);
        if not rname then return; end

        dbg(string.format("error", "** room %s", rname));

	if valid_room(rname, "xyzzy") then
	   dbg(string.format("error", "** good room %s", rname));
	   return
	end
	   
	dbg(string.format("error", "** bad room %s", rname));

	event.allowed = false;
	event.stanza.attr.type = 'error';
	return event.origin.send(
	   st.error_reply(event.stanza, 
			  "cancel", 
			  "forbidden", 
			  "invalid room name"));
end, 10);

dbg("hello");

x = valid_room("xyzzy", "Hello200608-10_4fbc3d3b");
dbg(string.format("valid? %s", x));

x = valid_room("xyzzy", "Hello200526-10_df6594ed");
dbg(string.format("valid? %s", x));
