local uv = require('luv')
local fiber = require('wait')
local process = require('process')
local p = require('lib/utils').prettyPrint

local fibered = fiber.new(function (wait, await)
  local options = {
    stdio = {nil, 1, 2}
  }
  local code, signal = await(process.spawn("pwd", {}, options))
  p{cmd="pwd", code=code, signal=signal}

  code, signal = await(process.spawn("ls", {"-l"}, options))
  return {code=code, signal=signal}
end)

fibered(function (err, message)
  p{name="fibered", err=err, message=message}
end)

repeat
until uv.run("once") == 0
