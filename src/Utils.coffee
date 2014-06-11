fs = require 'fs'

module.exports = {

  fileExists: (filePath) ->
    fs.existsSync(filePath)

}