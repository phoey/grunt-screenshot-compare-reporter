(function() {
  var iocExtra;

  iocExtra = require("simple-ioc-extra");

  module.exports = function() {
    var ioc;
    ioc = iocExtra();
    ioc.registerLibraries({
      "Promise": "bluebird",
      "resemble": "resemble",
      "mkdirp": "mkdirp",
      "_": "underscore",
      "path": "path"
    });
    ioc.registerDirectories(__dirname, ["/runtime", "/util"]);
    return ioc;
  };

}).call(this);
