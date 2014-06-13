Q              = require 'q'
fs             = require 'fs'
Utils       = require './Utils'

class HTMLReporter

  htmlReport:"""
<html data-ng-app>
<head>
    <meta charset="utf-8">

    <title>screenshot reporter</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.0-beta.11/angular.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min.js"></script>

    <script src="./results.js" type="text/javascript"></script>
    <style type="text/css">

      * { box-sizing: border-box; }

      .screenshot-baseline, .screenshot-sample, .screenshot-diff {
        float:left;
      }

      .screenshot-img {
        width:330px;
        padding:10px;
      }

      .error {
        color: red;
      }

      .screenshot {
        clear:both;
      }

    </style>

    <script type="text/javascript">
      function ReportController($scope) {
        $scope.results = window.results;


      }
    </script>
</head>

<body ng-controller="ReportController">
  
  <div ng-repeat="(platformName,platform) in results">

    <h1>{{platformName}}</h1>
    <div class="result screenshot" ng-repeat="result in platform | orderBy:'failed':true">
      <h2 ng-class="{'error':result.failed}">{{result.name}}</h2>
      <div class="screenshot-baseline">
        <img class="screenshot-img" ng-src="{{platformName+'/'+result.paths.sampleName}}"/>
      </div>
      <div class="screenshot-sample">
        <img class="screenshot-img" ng-src="{{platformName+'/'+result.paths.baselineName}}"/>
      </div>
      <div class="screenshot-diff">
        <img class="screenshot-img" ng-src="{{platformName+'/'+result.paths.diffName}}"/>
      </div>
    </div>

  </div>

  <div ng-hide="true">
  <pre>{{results}}</pre>
</div>
  

</body>

</html>
  """

  constructor: (@resultsDir) ->
    @report = {}

  addTestResult: (platform, result) ->
    @report[platform] = result

  addHtmlReportViewer: =>
    Utils.writeFile("#{@resultsDir}/reporter.html", @htmlReport)

  saveReport: =>
    Utils.writeFile("#{@resultsDir}/results.js", "window.results = #{JSON.stringify(@report)}")
      .then(@addHtmlReportViewer)

module.exports = HTMLReporter