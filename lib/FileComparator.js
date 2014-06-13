(function() {
  var FileComparator, Q, Utils, fs, resembleApi,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  resembleApi = require('resemble');

  Q = require('q');

  fs = require('fs');

  Utils = require('./Utils');

  FileComparator = (function() {
    FileComparator.THRESHOLD = 4;

    function FileComparator(name, resultsDir, srcFiles) {
      this.name = name;
      this.resultsDir = resultsDir;
      this.srcFiles = srcFiles;
      this._differenceData = __bind(this._differenceData, this);
      this._compareImages = __bind(this._compareImages, this);
      this.name = this.name.replace(".png", "");
      this.baselineName = "" + this.name + "-baseline.png";
      this.sampleName = "" + this.name + "-sample.png";
      this.diffName = "" + this.name + "-diff.png";
      this.baseline = "" + this.resultsDir + "/" + this.baselineName;
      this.sample = "" + this.resultsDir + "/" + this.sampleName;
      this.diff = "" + this.resultsDir + "/" + this.diffName;
      this.result = {};
    }

    FileComparator.prototype.storeScreenshot = function(rawData, file) {
      var data, deferred;
      deferred = Q.defer();
      data = rawData.replace(/^data:image\/png;base64,/, "");
      fs.writeFile(file, data, {
        encoding: 'base64'
      }, deferred.resolve);
      return deferred.promise;
    };

    FileComparator.prototype._copyImages = function() {
      return Q.all([Utils.copyFile(this.srcFiles.baseline, this.baseline), Utils.copyFile(this.srcFiles.sample, this.sample)]);
    };

    FileComparator.prototype._compareImages = function() {
      var deferred;
      deferred = Q.defer();
      resembleApi.resemble(this.sample).compareTo(this.baseline).onComplete(deferred.resolve);
      return deferred.promise;
    };

    FileComparator.prototype._differenceData = function(difference) {
      var deferred, diffScreenshot, hasDifference,
        _this = this;
      deferred = Q.defer();
      hasDifference = parseInt(difference.misMatchPercentage) >= FileComparator.THRESHOLD;
      this.result = {
        name: this.name,
        failed: hasDifference,
        difference: difference,
        paths: {
          sampleName: this.sampleName,
          baselineName: this.baselineName,
          diffName: this.diffName
        }
      };
      diffScreenshot = difference.getImageDataUrl();
      if (diffScreenshot) {
        this.storeScreenshot(diffScreenshot, this.diff).then(function() {
          return deferred.resolve(_this.result);
        });
      } else {
        deferred.resolve(this.result);
      }
      return deferred.promise;
    };

    FileComparator.prototype.compare = function() {
      return this._copyImages().then(this._compareImages).then(this._differenceData);
    };

    return FileComparator;

  })();

  module.exports = FileComparator;

}).call(this);
