local lib = {}

lib.namespace = 'random'

math.randomseed(os.time())

local charset = {}
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function lib.getRandomString(length)
  if (type(length) == 'number' and length > 0) then
    return lib.randomString(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

return lib
