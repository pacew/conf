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

local function pace_block(room)
   return nil;
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
	local room = jid.split(stanza.attr.to);
        if not room then return; end

        module:log("error", "** stanza.attr.from %s", stanza.attr.from);
        module:log("error", "** stanza.attr.to %s", stanza.attr.to);

	if pace_block(room) then
                event.allowed = false;
                event.stanza.attr.type = 'error';
	        return event.origin.send(
		   st.error_reply(event.stanza, 
				  "cancel", 
				  "forbidden", 
				  "invalid room name"));
        end
end, 10);

module:log("error", "** hello");
local hashes = require "util.hashes";
local base64_encode = require "util.encodings".base64.encode;
local base64_decode = require "util.encodings".base64.decode;

key = "xyzzy";
msg = "hello"

h = base64_encode (hashes.hmac_sha256(key, msg));

module:log("error", "** hash %s", h);
