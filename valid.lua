local sha1 = require "sha1"

function fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

function tohex(buf)
   ret = ""
   for i = 1,string.len(buf) do
      ret = ret .. string.format("%02x ", buf:byte(i))
   end
   return ret
end


function valid_room(room_name, secret)
   parts = string.gmatch(room_name, "[^_]+")
   name = string.lower(parts(1))
   sig_hex = parts(2)

   status, received = pcall (function () return fromhex(sig_hex) end);
   print(tohex(received))
   if status then
      computed = sha1.hmac(secret, name);
      computed = string.sub(computed, 1, 8)

      if computed == sig_hex then
	 return true
      end
   end
   return false
end

val = valid_room("Hello200608_085f738c", "xyzzy")
print(val)

