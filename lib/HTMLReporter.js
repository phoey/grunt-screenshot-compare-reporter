(function() {
  var HTMLReporter, Q, Utils, fs,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Q = require('q');

  fs = require('fs');

  Utils = require('./Utils');

  HTMLReporter = (function() {
    function HTMLReporter(resultsDir) {
      this.resultsDir = resultsDir;
      this.saveReport = __bind(this.saveReport, this);
      this.report = {};
    }

    HTMLReporter.prototype.addTestResult = function(platform, result) {
      return this.report[platform] = result;
    };

    HTMLReporter.prototype.copyHtmlReportViewer = function() {
      return Utils.copyFile("./resources/reporter.html", "" + this.resultsDir + "/reporter.html");
    };

    HTMLReporter.prototype.saveReport = function() {
      var deferred,
        _this = this;
      deferred = Q.defer();
      fs.writeFile("" + this.resultsDir + "/results.js", "window.results = " + (JSON.stringify(this.report)), function() {
        return _this.copyHtmlReportViewer().then(deferred.resolve);
      });
      return deferred.promise;
    };

    return HTMLReporter;

  })();

  module.exports = HTMLReporter;

}).call(this);
