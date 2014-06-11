(function() {
  var HTMLReporter;

  HTMLReporter = (function() {
    function HTMLReporter() {
      this.report = {};
    }

    HTMLReporter.prototype.addTestResult = function(platform, result) {
      var _base;
      if ((_base = this.report)[platform] == null) {
        _base[platform] = [];
      }
      return this.report[platform].push;
    };

    HTMLReporter.prototype.createReport = function() {
      return console.log(this.report);
    };

    return HTMLReporter;

  })();

  module.exports = HTMLReporter;

}).call(this);
