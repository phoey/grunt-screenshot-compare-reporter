(function() {
  var Q, fs, mkdirp;

  fs = require('fs');

  Q = require('q');

  mkdirp = require('mkdirp');

  module.exports = {
    fileExists: function(filePath) {
      return fs.existsSync(filePath);
    },
    copyFile: function(file, dest) {
      var deferred, rs, ws;
      deferred = Q.defer();
      rs = fs.createReadStream(file);
      ws = fs.createWriteStream(dest);
      rs.on("close", deferred.resolve);
      rs.on("error", deferred.reject);
      ws.on("error", deferred.reject);
      rs.pipe(ws);
      return deferred.promise;
    },
    mkDirP: function(dir) {
      var deferred;
      deferred = Q.defer();
      mkdirp(dir, function(err) {
        if (err) {
          return deferred.reject(err);
        } else {
          return deferred.resolve();
        }
      });
      return deferred.promise;
    }
  };

}).call(this);
