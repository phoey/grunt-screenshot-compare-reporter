(function() {
  var FileComparator, HTMLReporter, Q, ScreenshotCompareReporter, Utils, async, fs, mkdirp, path, resembleApi, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  fs = require('fs');

  async = require('async');

  path = require('path');

  Q = require('q');

  mkdirp = require('mkdirp');

  resembleApi = require('resemble');

  HTMLReporter = require('./HTMLReporter');

  FileComparator = require('./FileComparator');

  _ = require('underscore');

  Utils = require('./Utils');

  ScreenshotCompareReporter = (function() {
    function ScreenshotCompareReporter(grunt, options) {
      this.grunt = grunt;
      this.options = options;
      this.saveReport = __bind(this.saveReport, this);
      return this.run();
    }

    ScreenshotCompareReporter.prototype.getSubFilesByType = function(base, type) {
      var file, filePath, files, objects, stat, _i, _len;
      files = fs.readdirSync(base);
      objects = [];
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        if (file[0] !== '.') {
          filePath = "" + base + "/" + file;
          stat = fs.statSync(filePath);
          if (stat.isDirectory() && type === "directory") {
            objects.push(file);
          }
          if (stat.isFile() && type === "file") {
            objects.push(file);
          }
        }
      }
      return objects;
    };

    ScreenshotCompareReporter.prototype.runReporterForPlatform = function(platformDir) {
      var baselineDir, baselineFile, comparison, deferred, reportDir, resultPromises, sampleDir, sampleFile, testFile, _i, _len, _ref;
      deferred = Q.defer();
      resultPromises = [];
      baselineDir = this.options.baselineDirectory;
      sampleDir = this.options.sampleDirectory;
      reportDir = this.options.reportDirectory;
      _ref = this.getSubFilesByType("" + baselineDir + "/" + platformDir, "file");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        testFile = _ref[_i];
        baselineFile = "" + baselineDir + "/" + platformDir + "/" + testFile;
        sampleFile = "" + sampleDir + "/" + platformDir + "/" + testFile;
        if (Utils.fileExists(baselineFile) && Utils.fileExists(sampleFile)) {
          comparison = new FileComparator(testFile, reportDir, {
            baseline: baselineFile,
            sample: sampleFile
          });
          resultPromises.push(comparison.compare());
        }
      }
      return Q.all(resultPromises).then(this.saveReport);
    };

    ScreenshotCompareReporter.prototype.saveReport = function(results) {
      fs.writeFileSync("" + this.options.reportDirectory + "/results.json", JSON.stringify(results));
      return results;
    };

    ScreenshotCompareReporter.prototype.run = function() {
      var platformDir, platformRuns, _i, _len, _ref;
      platformRuns = [];
      _ref = this.getSubFilesByType(this.options.baselineDirectory, "directory");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        platformDir = _ref[_i];
        platformRuns.push(this.runReporterForPlatform(platformDir));
      }
      return Q.all(platformRuns);
    };

    return ScreenshotCompareReporter;

  })();

  module.exports = ScreenshotCompareReporter;

}).call(this);
