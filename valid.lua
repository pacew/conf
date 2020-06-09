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


function valid_room(secret, room_name)
   print("valid_room?", room_name)
   msg = string.lower(string.sub(room_name, 1, -9))
   sig_hex = string.sub(room_name, -8);
   print(msg, sig_hex)

   status, received = pcall (function () return fromhex(sig_hex) end);
   print(tohex(received))
   if status then
      computed = sha1.hmac(secret, msg);
      computed = string.sub(computed, 1, 8)

      if computed ~= sig_hex then
	 return false
      end
   end

   print("sig ok")

   yyyy, mm, dd, duration = msg:match(".*(....)(..)(..)x(..)x")
   print(yyyy, mm, dd, duration)
   start = os.time{year=yyyy, month=mm, day=dd}
   delta = os.time() - start
   if delta > duration * 86400 then
      print("expired")
      return false
   end

   return true
end

val = valid_room("xyzzy", "Hello20200608x10x455425f7")
print(val)
print("")

val = valid_room("xyzzy", "Hello20200526x10x90f103d6")
print(val)



