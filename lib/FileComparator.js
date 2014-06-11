(function() {
  var FileComparator, Q, fs, resembleApi,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  resembleApi = require('resemble');

  Q = require('q');

  fs = require('fs');

  FileComparator = (function() {
    FileComparator.THRESHOLD = 5;

    function FileComparator(name, resultsDir, srcFiles) {
      this.name = name;
      this.resultsDir = resultsDir;
      this.srcFiles = srcFiles;
      this._differenceData = __bind(this._differenceData, this);
      this._compareImages = __bind(this._compareImages, this);
      this.name = this.name.replace(".png", "");
      this.baseline = "" + this.resultsDir + "/" + this.name + "-baseline.png";
      this.sample = "" + this.resultsDir + "/" + this.name + "-sample.png";
      this.diff = "" + this.resultsDir + "/" + this.name + "-diff.png";
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

    FileComparator.prototype._copyImage = function(file, dest) {
      var deferred, rs, ws;
      deferred = Q.defer();
      rs = fs.createReadStream(file);
      ws = fs.createWriteStream(dest);
      rs.on("close", deferred.resolve);
      rs.on("error", deferred.reject);
      ws.on("error", deferred.reject);
      rs.pipe(ws);
      return deferred.promise;
    };

    FileComparator.prototype._copyImages = function() {
      return Q.all([this._copyImage(this.srcFiles.baseline, this.baseline), this._copyImage(this.srcFiles.sample, this.sample)]);
    };

    FileComparator.prototype._compareImages = function() {
      var deferred;
      deferred = Q.defer();
      resembleApi.resemble(this.sample).compareTo(this.baseline).onComplete(deferred.resolve);
      return deferred.promise;
    };

    FileComparator.prototype._differenceData = function(difference) {
      var deferred, hasDifference,
        _this = this;
      deferred = Q.defer();
      hasDifference = parseInt(difference.misMatchPercentage) >= this.THRESHOLD;
      this.result = {
        name: this.name,
        failed: hasDifference,
        difference: difference,
        paths: {
          sample: this.sample,
          baseline: this.baseline,
          diff: this.diff
        }
      };
      this.storeScreenshot(difference.getImageDataUrl(), this.diff).then(function() {
        return deferred.resolve(_this.result);
      });
      return deferred.promise;
    };

    FileComparator.prototype.compare = function() {
      return this._copyImages().then(this._compareImages).then(this._differenceData);
    };

    return FileComparator;

  })();

  module.exports = FileComparator;

}).call(this);
