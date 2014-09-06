local uv = require('luv')
local fs = require('file')
local fiber = require('wait')
local p = require('lib/utils').prettyPrint

local filename = "test.lua"
local input = filename
local output = filename .. ".out"

local fibered = fiber.new(function (wait, await)
  local rfd = await(fs.open(input, "r"))
  local wfd = await(fs.open(output, "w"))
  local roff = 0
  repeat
    local chunk = await(fs.read(rfd, 4096, roff))
    roff = roff + #chunk
    await(fs.write(wfd, chunk, 0))
  until #chunk == 0
  return "done"
end)

fibered(function (err, message)
  p{name="fibered", err=err, message=message}
end)

repeat
until uv.run("once") == 0
