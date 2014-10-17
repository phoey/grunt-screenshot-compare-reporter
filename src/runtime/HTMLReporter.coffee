module.exports = (options, fsPromise, path)->
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

        .screenshot-baseline, .screenshot-sample, .screenshot-diff, .platform {
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

    <div class="platform" ng-repeat="(platformName,platform) in results">

    <h1>{{platformName}}</h1>
    <div class="result screenshot" ng-repeat="result in platform.results | orderBy:'failed':true">
      <h2 ng-class="{'error':result.failed}">{{result.name}}</h2>
      <div class="screenshot-baseline">
        <img class="screenshot-img" ng-src="{{result.files.sample.url || 'http://dummyimage.com/600x400/fff/000000&text=sample+missing'}}"/>
      </div>
      <div class="screenshot-sample">
        <img class="screenshot-img" ng-src="{{result.files.base.url || 'http://dummyimage.com/600x400/fff/000000&text=baseline+missing'}}"/>
      </div>
      <div class="screenshot-diff">
        <img class="screenshot-img" ng-src="{{result.files.diff.url}}"/>
      </div>
    </div>

    </div>

    <div ng-hide="true">
    <pre>{{results}}</pre>
  </div>


  </body>

  </html>
    """

    constructor: (@report) ->
      @resultsDir = options.reportDirectory
      @failed = false

    @write:(report)->
      new HTMLReporter(report).saveReport()

    addTestResult: (platform, results) ->
      @report[platform] = results
      @failed = true if results.filter((result) -> result.failed ).length > 0

    addHtmlReportViewer: =>
      fsPromise.writeFileAsync(path.join(@resultsDir, "reporter.html"), @htmlReport)

    saveReport: =>
      fsPromise.writeFileAsync(path.join(@resultsDir, "results.js"), "window.results = #{JSON.stringify(@report)}")
        .then(@addHtmlReportViewer)

