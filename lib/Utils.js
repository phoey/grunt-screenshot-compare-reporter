(function() {
  var fs;

  fs = require('fs');

  module.exports = {
    fileExists: function(filePath) {
      return fs.existsSync(filePath);
    }
  };

}).call(this);
