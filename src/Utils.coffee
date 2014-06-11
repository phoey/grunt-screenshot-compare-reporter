fs = require 'fs'
Q = require 'q'

module.exports = {

  fileExists: (filePath) ->
    fs.existsSync(filePath)

  copyFile: (file, dest) ->
    deferred = Q.defer()
    rs = fs.createReadStream(file)
    ws = fs.createWriteStream(dest)
    rs.on "close", deferred.resolve
    rs.on "error", deferred.reject
    ws.on "error", deferred.reject
    rs.pipe(ws)
    return deferred.promise

}