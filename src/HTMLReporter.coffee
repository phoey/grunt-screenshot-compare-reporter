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

      html, body {
        margin: 0;
        padding: 0;
        height: 100%;
        color: #403E3E;
        background: #FFF2F2;
        font-family: sans-serif;
        line-height: 1.5;
        vertical-align: baseline;
      }

      body {
        padding: 1.5rem;
      }

      img {
        max-width: 100%;
        height: auto;
      }

      section, figure, menu {
        display: block;
        margin: 0;
        padding: 0;
      }

      h1, h2, h3, h4, h5, h6 {
        margin: 0;
        padding: 0;
        color: inherit;
        font-weight: inherit;
        font-style: inherit;
        font-size: 100%;
        line-height: inherit;
      }

      i, b {
        font-weight: inherit;
        font-style: inherit;
      }

      a {
        color: #606B7D;
        font-weight: bold;
        text-decoration: underline solid;
      }
      a:focus,
      a:active,
      a:hover {
        color: #54709C;
        text-decoration: underline double;
      }

      button {
        -webkit-appearance: none;
        -moz-appearance:    none;
        appearance:         none;
        -webkit-user-select: none;
        -moz-user-select:    none;
        user-select:         none;
        margin: 0;
        padding: 0.33rem 0.66rem;
        border: 1px solid #72403F;
        color: #FFF;
        background: #A57D7C;
        font: inherit;
        font-size: 14px;
        line-height: 1.5;
        text-transform: uppercase;
        white-space: nowrap;
        vertical-align: center;
        overflow: visible;
        cursor: pointer;
      }

      button::-moz-focus-inner {
        border: 0;
        padding: 0;
      }

      a, button {
        -webkit-transition: all 0.25s ease-out;
        -moz-transition:    all 0.25s ease-out;
        transition:         all 0.25s ease-out;
      }

      button:focus,
      button:hover {
        box-shadow: inset 0 0 0 2px #72403F;
        outline: 0;
      }

      button:active {
        outline: 0;
      }

      button.active,
      button.active:focus {
        -webkit-pointer-events: none;
        -moz-pointer-events: none;
        pointer-events: none;
        color: #FFF0F0;
        background: #755453;
        outline: 0;
      }

      .button-group {
        display: -webkit-box;
        display: -moz-box;
        display: -ms-flexbox;
        display: -webkit-flex;
        display: flex;
        -webkit-box-direction: normal;
        -moz-box-direction: normal;
        -webkit-box-orient: horizontal;
        -moz-box-orient: horizontal;
        -webkit-flex-direction: row;
        -ms-flex-direction: row;
        flex-direction: row;
        -webkit-flex-wrap: nowrap;
        -ms-flex-wrap: nowrap;
        flex-wrap: nowrap;
        -webkit-box-pack: start;
        -moz-box-pack: start;
        -webkit-justify-content: flex-start;
        -ms-flex-pack: start;
        justify-content: flex-start;
        -webkit-align-content: center;
        -ms-flex-line-pack: center;
        align-content: center;
        -webkit-box-align: center;
        -moz-box-align: center;
        -webkit-align-items: center;
        -ms-flex-align: center;
        align-items: center;
      }
        .button-group button + button {
          border-left: 0;
        }

      .icon {
       display: inline-block;
       vertical-align: middle;
      }

      .icon + .icon--text {
        margin-left: 0.33rem;
      }

      .square {
       width: 5px;
       height: 5px;
       margin-top: -2px;
       background: #FFF;
      }

      .platform {}
        .platform--name {
          color: #72403F;
          font-weight: bold;
          font-size: 1.5rem;
        }

      .screenshot,
        .screenshot--img {
          display: block;
        }

      .comparison {
        margin: 1.00rem 0;
        padding: 0.50rem;
        background: #FFF8F7;
        box-shadow: 0 1px 2px 0 #DED3D3;
      }
      .comparison:hover {
      }
      .comparison.error {
        position: relative;
        z-index: 0;
      }
      .comparison.error::before {
        content: "";
        position: absolute;
        top: -0.25rem;
        right: -0.25rem;
        bottom: -0.25rem;
        left: -0.25rem;
        border: 0.25rem solid #FFB5AA;
        box-shadow: 0 1px 2px 0 #DED3D3;
        z-index: -1;
      }
        .comparison--name {
          margin-bottom: 0.50rem;
          color: #8C573F;
          font-weight: bold;
        }
        .comparison--name.error {
          position: relative;
          color: #7A4B36;
        }
        .comparison--name.error::after {
          content: "";
          position: absolute;
          top: -0.50rem;
          right: -0.50rem;
          bottom: -0.50rem;
          left: 10em;
        }
        .comparison--images {
          margin: 0.50rem 0;
          background: #F5EBE9;
          box-shadow: inset -1px -1px 1px 1px #F5EBE9,
                      inset 1px 1px 1px 1px #EBDBD8;
          display: -webkit-box;
          display: -moz-box;
          display: -ms-flexbox;
          display: -webkit-flex;
          display: flex;
          -webkit-box-direction: normal;
          -moz-box-direction: normal;
          -webkit-box-orient: horizontal;
          -moz-box-orient: horizontal;
          -webkit-flex-direction: row;
          -ms-flex-direction: row;
          flex-direction: row;
          -webkit-flex-wrap: nowrap;
          -ms-flex-wrap: nowrap;
          flex-wrap: nowrap;
          -webkit-box-pack: center;
          -moz-box-pack: center;
          -webkit-justify-content: center;
          -ms-flex-pack: center;
          justify-content: center;
          -webkit-align-content: center;
          -ms-flex-line-pack: center;
          align-content: center;
          -webkit-box-align: center;
          -moz-box-align: center;
          -webkit-align-itrems: center;
          -ms-flex-align: center;
          align-itrems: center;
        }
          .comparison--shot {
            position: relative;
          }
          .comparison--shot__3up {
            max-width: 33.33333%;
          }
          .comparison--shot__2up {
            max-width: 50%;
          }
          .comparison--shot__1up {
            max-width: 100%;
          }
          .comparison--shot::after {
            position: absolute;
            top: -0.25rem;
            right: -0.25rem;
            bottom: -0.25rem;
            left: -0.25rem;
            content: "";
            opacity: 0;
            border: 0.25rem solid #99A9C2;
            -webkit-transition: opacity 0.25s ease-out;
            -moz-transition:    opacity 0.25s ease-out;
            transition:         opacity 0.25s ease-out;
            z-index: 1;
          }
          .comparison--shot:focus::after,
          .comparison--shot:active::after,
          .comparison--shot:hover::after {
            opacity: 1;
          }
          .comparison--sample {}
          .comparison--diff {}
          .comparison--diff.hide {
            display: none;
          }
          .comparison--base {}
            .comparison--img {}
            .comparison--img__overlay {
              position: absolute;
              top: 0;
              right: 0;
              bottom: 0;
              left: 0;
              opacity: 0.5;
            }
            .comparison--label {
              position: absolute;
              top: 0;
              right: 0;
              padding: 0 0.33rem;
              color: #606B7D;
              background: #FFF2F2;
              font-size: 11px;
              font-weight: normal;
              text-decoration: none;
              text-transform: uppercase;
              border-radius: 0 0 0 0.25rem;
            }
        .comparison--menu {
          display: -webkit-box;
          display: -moz-box;
          display: -ms-flexbox;
          display: -webkit-flex;
          display: flex;
          -webkit-box-direction: normal;
          -moz-box-direction: normal;
          -webkit-box-orient: horizontal;
          -moz-box-orient: horizontal;
          -webkit-flex-direction: row;
          -ms-flex-direction: row;
          flex-direction: row;
          -webkit-flex-wrap: nowrap;
          -ms-flex-wrap: nowrap;
          flex-wrap: nowrap;
          -webkit-box-pack: justify;
          -moz-box-pack: justify;
          -webkit-justify-content: space-between;
          -ms-flex-pack: justify;
          justify-content: space-between;
          -webkit-align-content: stretch;
          -ms-flex-line-pack: stretch;
          align-content: stretch;
          -webkit-box-align: center;
          -moz-box-align: center;
          -webkit-align-items: center;
          -ms-flex-align: center;
          align-items: center;
        }
          .comparison--view {
            margin-right: auto;
          }
          .comparison--opts {
            margin-left: auto;
          }
    </style>

    <script type="text/javascript">
      function ReportController($scope) {
        var viewModel, extendWithViewModel;
        viewModel = {
          screens: 3,
          overlay: false,
          labels: true
        };
        extendWithViewModel = function (collection) {
          return _.object(_.map(collection, extendWithViewModel.format));
        };
        extendWithViewModel.format = function (list, key) {
          return [key, extendWithViewModel.each(list)]
        };
        extendWithViewModel.each = function ( item ) {
          return _.map(item, extendWithViewModel.extend);
        };
        extendWithViewModel.extend = function ( obj ) {
          return _.extend(obj, { view: _.clone(viewModel) });
        };
        $scope.results = extendWithViewModel(window.results);
      }
    </script>
</head>
<body ng-controller="ReportController">

  <div class="platform" ng-repeat="(platformName,platform) in results">

    <h1 class="platform--name">{{platformName}}</h1>

    <section class="result comparison" ng-repeat="result in platform | orderBy:'failed':true" ng-class="{'error':result.failed}">
      <h2 class="comparison--name" ng-class="{'error':result.failed}">{{result.name}}</h2>
      <figure class="comparison--images">
        <a target="_blank" ng-href="{{platformName+'/'+result.paths.baselineName}}" class="comparison--shot comparison--shot__{{result.view.screens}}up comparison--sample" ng-class="{'comparison--shot__2up': !result.failed}">
          <img class="comparison--img" ng-src="{{platformName+'/'+result.paths.baselineName}}" />
          <img class="comparison--img__overlay" ng-src="{{platformName+'/'+result.paths.diffName}}" ng-if="result.failed && result.view.overlay" />
          <figcaption class="comparison--label" ng-if="result.view.labels">Sample</figcaption>
        </a>
        <a target="_blank" ng-href="{{platformName+'/'+result.paths.diffName}}" class="comparison--shot comparison--shot__{{result.view.screens}}up comparison--diff" ng-if="result.failed && result.view.screens === 3">
          <img class="comparison--img" ng-src="{{platformName+'/'+result.paths.diffName}}" />
          <figcaption class="comparison--label" ng-if="result.view.labels">Difference</figcaption>
        </a>
        <a target="_blank" ng-href="{{platformName+'/'+result.paths.sampleName}}" class="comparison--shot comparison--shot__{{result.view.screens}}up comparison--base" ng-class="{'comparison--shot__2up': !result.failed}" ng-if="result.view.screens === 2 || result.view.screens === 3">
          <img class="comparison--img" ng-src="{{platformName+'/'+result.paths.sampleName}}" />
          <img class="comparison--img__overlay" ng-src="{{platformName+'/'+result.paths.diffName}}" ng-if="result.failed && result.view.overlay" />
          <figcaption class="comparison--label" ng-if="result.view.labels">Baseline</figcaption>
        </a>
      </figure>
      <div class="comparison--menu">
        <menu class="button-group comparison--view">
          <button type="button" title="Sample only" ng-click="result.view.screens = 1" ng-class="{'active': result.view.screens === 1}">
            <i class="icon square"></i>
            <b class="icon--text">1 up</b>
          </button>
          <button type="button" title="Sample vs. Baseline" ng-click="result.view.screens = 2" ng-class="{'active': result.view.screens === 2 || (!result.failed && result.view.screens === 3)}">
            <i class="icon square"></i>
            <i class="icon square"></i>
            <b class="icon--text">2 up</b>
          </button>
          <button type="button" title="Sample, Difference, and Baseline" ng-if="result.failed" ng-click="result.view.screens = 3" ng-class="{'active': result.view.screens === 3}">
            <i class="icon square"></i>
            <i class="icon square"></i>
            <i class="icon square"></i>
            <b class="icon--text">3 up</b>
          </button>
        </menu>
        <menu class="comparison--opts">
          <button type="button" ng-if="result.failed" ng-click="result.view.overlay = !result.view.overlay">
            <b ng-if="!result.view.overlay">Show</b>
            <b ng-if="result.view.overlay">Hide</b>
            Overlay
          </button>
          <button type="button" ng-click="result.view.labels = !result.view.labels">
            <b ng-if="!result.view.labels">Show</b>
            <b ng-if="result.view.labels">Hide</b>
            Labels
          </button>
        </menu>
      </div>
    </section>

  </div>

  <div ng-hide="true">
    <pre>{{results}}</pre>
  </div>

</body>
</html>
  """

  constructor: (@resultsDir) ->
    @report = {}
    @failed = false

  addTestResult: (platform, results) ->
    @report[platform] = results
    @failed = true if results.filter((result) -> result.failed ).length > 0

  addHtmlReportViewer: =>
    Utils.writeFile("#{@resultsDir}/reporter.html", @htmlReport)

  saveReport: =>
    Utils.writeFile("#{@resultsDir}/results.js", "window.results = #{JSON.stringify(@report)}")
      .then(@addHtmlReportViewer)

module.exports = HTMLReporter