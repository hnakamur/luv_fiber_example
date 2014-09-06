local uv = require('luv')

local process = {}

function process.spawn(command, args, options)
  if type(command) ~= "string" then
    error("spawn(command, [args], [options]): command must be a string")
  end
  if args and type(args) ~= "table" then
    error("spawn(command, [args], [options]): args must be an array")
  end
  if options and type(options) ~= "table" then
    error("spawn(command, [args], [options]): options must be a table")
  end
  return function(callback)
    local child, pid = uv.spawn(command, args, options)
    function child:onexit(code, signal)
      uv.close(child)
      if callback then
        callback(nil, code, signal)
      end
    end
    return child
  end
end

return process
