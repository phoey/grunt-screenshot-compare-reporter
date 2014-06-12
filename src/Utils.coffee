fs = require 'fs'
Q = require 'q'
mkdirp = require('mkdirp')

module.exports = {

  fileExists: (filePath) ->
    fs.existsSync(filePath)

  writeFile: (path, data) ->
    deferred = Q.defer()
    fs.writeFile(path, data, deferred.resolve)
    return deferred.promise

  copyFile: (file, dest) ->
    deferred = Q.defer()
    rs = fs.createReadStream(file)
    ws = fs.createWriteStream(dest)
    rs.on "close", deferred.resolve
    rs.on "error", deferred.reject
    ws.on "error", deferred.reject
    rs.pipe(ws)
    return deferred.promise

  mkDirP: (dir) ->
    deferred = Q.defer()
    mkdirp dir, (err) ->
      if err
       deferred.reject(err)
      else
        deferred.resolve()

    return deferred.promise

}