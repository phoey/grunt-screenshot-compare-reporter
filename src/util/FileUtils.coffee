module.exports = (fsPromise, path, Promise)->
  fs = fsPromise

  new class FileUtils

    directoryFilter:(dir)-> (file)->
      return false if file[0] is "."
      fsPromise.statAsync(path.join(dir,file))
        .then (stat)-> stat.isDirectory()

    fileFilter:(dir)-> (file)->
      return false if file[0] is "."
      fsPromise.statAsync(path.join(dir,file))
        .then (stat)-> stat.isFile()

    getDirectories:(dir)->
      fsPromise.readdirAsync(dir)
        .filter(@directoryFilter(dir))
        .catch ()-> []
    getFiles:(dir)->
      fsPromise.readdirAsync(dir)
        .filter(@fileFilter(dir))
        .catch ()-> []

    copyFile: (file, dest) -> new Promise (resolve, reject)->
      rs = fs.createReadStream(file)
      ws = fs.createWriteStream(dest)
      rs.on "close", resolve
      rs.on "error", reject
      ws.on "error", reject
      rs.pipe(ws)
