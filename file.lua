-- This is a partial port of the built-in fs module as continuable format

local uv = require('luv')

local fs = {}

fs.umask = "0644"

local function noop() end

function fs.open(path, flag, mode)
  if type(path) ~= "string" then
    error("open(path, flag, [mode]): path must be a string")
  end
  if type(flag) ~= "string" then
    error("open(path, flag, [mode]): flag must be a string")
  end
  if not mode then mode = tonumber(fs.umask, 8) end
  if type(mode) ~= "number" then
    error("open(path, flag, [mode]): mode must be a number")
  end
  return function (callback)
    return uv.fs_open(path, flag, mode, callback or noop)
  end
end

function fs.read(fd, length, offset)
  if type(fd) ~= "number" then
    error("read(fd, length, offset): fd must be a number")
  end
  if type(length) ~= "number" then
    error("read(fd, length, offset): length must be a number")
  end
  if type(offset) ~= "number" then
    error("read(fd, length, offset): offset must be a number")
  end
  return function (callback)
    return uv.fs_read(fd, length, offset, callback or noop)
  end
end

function fs.write(fd, chunk, offset)
  if type(fd) ~= "number" then
    error("write(fd, chunk, offset): fd must be a number")
  end
  if type(chunk) ~= "string" then
    error("write(fd, chunk, offset): chunk must be a string")
  end
  if type(offset) ~= "number" then
    error("write(fd, chunk, offset): offset must be a number")
  end
  return function (callback)
    return uv.fs_write(fd, chunk, offset, callback or noop)
  end
end

function fs.close(fd)
  if type(fd) ~= "number" then
    error("close(fd): fd must be a number")
  end
  return function (callback)
    return uv.fs_close(fd, callback or noop)
  end
end

return fs
