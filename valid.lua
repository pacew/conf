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
   parts = string.gmatch(room_name, "[^_]+")
   name = string.lower(parts(1))
   sig_hex = parts(2)

   status, received = pcall (function () return fromhex(sig_hex) end);
   print(tohex(received))
   if status then
      computed = sha1.hmac(secret, name);
      computed = string.sub(computed, 1, 8)

      if computed ~= sig_hex then
	 return false
      end
   end

   print(name)
   yy, mm, dd, duration = name:match("(..)(..)(..)-([^-]+)")
   start = os.time{year=2000+yy, month=mm, day=dd}
   delta = os.time() - start
   if delta > duration * 86400 then
      print("expired")
      return false
   end

   return true
end

val = valid_room("xyzzy", "Hello200608-10_4fbc3d3b")
print(val)

val = valid_room("xyzzy", "Hello200526-10_df6594ed")
print(val)


