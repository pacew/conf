local st = require "util.stanza";
local jid = require "util.jid";
local nodeprep = require "util.encodings".stringprep.nodeprep;

local rooms = module:shared "muc/rooms";
if not rooms then
        module:log("error", "This module only works on MUC components!");
        return;
end

local function pace_block(room)
   return nil



module:hook("presence/full", function(event)
        local stanza = event.stanza;

        if stanza.name == "presence" and stanza.attr.type == "unavailable" then
                return;
        end

	-- Get the room
	local room = jid.split(stanza.attr.to);
        if not room then return; end

        module:log("error", "room %s", room);
	

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
