(function() {
  var HTMLReporter, Q, Utils, fs,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Q = require('q');

  fs = require('fs');

  Utils = require('./Utils');

  HTMLReporter = (function() {
    HTMLReporter.prototype.htmlReport = "<html data-ng-app>\n<head>\n    <meta charset=\"utf-8\">\n\n    <title>screenshot reporter</title>\n\n    <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js\"></script>\n    <script src=\"https://ajax.googleapis.com/ajax/libs/angularjs/1.3.0-beta.11/angular.min.js\"></script>\n    <script src=\"https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min.js\"></script>\n\n    <script src=\"./results.js\" type=\"text/javascript\"></script>\n    <style type=\"text/css\">\n\n      * { box-sizing: border-box; }\n\n      .screenshot-baseline, .screenshot-sample, .screenshot-diff {\n        float:left;\n      }\n\n      .screenshot-img {\n        width:330px;\n        padding:10px;\n      }\n\n      .error {\n        color: red;\n      }\n\n      .screenshot {\n        clear:both;\n      }\n\n    </style>\n\n    <script type=\"text/javascript\">\n      function ReportController($scope) {\n        $scope.results = window.results;\n      }\n    </script>\n</head>\n\n<body ng-controller=\"ReportController\">\n  \n  <div ng-repeat=\"(platformName,platform) in results\">\n\n    <h1>{{platformName}}</h1>\n    <div class=\"result screenshot\" ng-repeat=\"result in platform\">\n      <h2 ng-class=\"{'error':result.failed}\">{{result.name}}</h2>\n      <div class=\"screenshot-baseline\">\n        <img class=\"screenshot-img\" ng-src=\"{{platformName+'/'+result.paths.sampleName}}\"/>\n      </div>\n      <div class=\"screenshot-sample\">\n        <img class=\"screenshot-img\" ng-src=\"{{platformName+'/'+result.paths.baselineName}}\"/>\n      </div>\n      <div class=\"screenshot-diff\">\n        <img class=\"screenshot-img\" ng-src=\"{{platformName+'/'+result.paths.diffName}}\"/>\n      </div>\n    </div>\n\n  </div>\n\n  <div ng-hide=\"true\">\n  <pre>{{results}}</pre>\n</div>\n  \n\n</body>\n\n</html>";

    function HTMLReporter(resultsDir) {
      this.resultsDir = resultsDir;
      this.saveReport = __bind(this.saveReport, this);
      this.addHtmlReportViewer = __bind(this.addHtmlReportViewer, this);
      this.report = {};
    }

    HTMLReporter.prototype.addTestResult = function(platform, result) {
      return this.report[platform] = result;
    };

    HTMLReporter.prototype.addHtmlReportViewer = function() {
      return Utils.writeFile("" + this.resultsDir + "/reporter.html", this.htmlReport);
    };

    HTMLReporter.prototype.saveReport = function() {
      return Utils.writeFile("" + this.resultsDir + "/results.js", "window.results = " + (JSON.stringify(this.report))).then(this.addHtmlReportViewer);
    };

    return HTMLReporter;

  })();

  module.exports = HTMLReporter;

}).call(this);
