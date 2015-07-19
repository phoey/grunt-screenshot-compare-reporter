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
          color: inherit;
          font-weight: inherit;
          text-decoration: inherit;
        }

        a[href] {
          color: #606B7D;
          font-weight: bold;
          text-decoration: underline solid;
        }
        a[href]:focus,
        a[href]:active,
        a[href]:hover {
          color: #54709C;
          text-decoration: underline double;
          outline: 0;
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

        a, button,
        a::before, a::after,
        button::before, button::after {
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
          display: -webkit-inline-box;
          display: -moz-inline-box;
          display: -ms-inline-flexbox;
          display: -webkit-inline-flex;
          display: inline-flex;
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

          .button-group--label {
            display: inline-block;
            padding: 0.33rem 0.66rem;
            color: #5B4241;
            font: inherit;
            font-size: 14px;
            line-height: 1.5;
            font-weight: bold;
            text-transform: uppercase;
            white-space: nowrap;
            vertical-align: center;
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

        .check {
          width: 1em;
          height: auto;
          vertical-align: baseline;
        }
        .check polyline {
          stroke-width: 2px;
        }

        .missing {
          margin: 1.5rem 0;
        }
          .missing--text {
            margin: 0 auto;
            width: 4.5em;
            color: #FF725D;
            font-size: 2rem;
            text-align: center;
          }

        .report {}
          .report--toolbar {
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
            margin-bottom: 1.5rem;
          }
            .report--view {
              margin-right: auto;
            }
            .report--opts {
              margin-left: auto;
            }
        .platform {
          overflow: hidden;
        }
          .platform--name[href] {
            display: block;
            padding: 0.25rem;
            color: #7F5B55;
            /*background: #FFEDE5;*/
            border: 1px solid #E8D4D1;
            border-bottom-width: 3px;
            font-weight: bold;
            font-size: 1.25rem;
            text-decoration: none !important;
            text-transform: uppercase;
          }
          .platform--name.open {
            vertical-align: text-bottom;
          }
          .platform--name.closed {
            vertical-align: text-top;
          }
          .platform--name::before {
            display: inline-block;
            padding: 0 0.25rem 0 1rem;
            content: "";
            color: #ADC0CC;
            -webkit-transform: rotate(45deg);
            -moz-transform:    rotate(45deg);
            transform:         rotate(45deg);
          }
          .platform--name.open::before {
            margin-bottom: -0.34rem;
            content: "\\25F8";
            vertical-align: text-bottom;
          }
          .platform--name.closed::before {
            margin-top: -1rem;
            content: "\\25FF";
            vertical-align: text-top;
          }
          .platform--results {
            padding: 0.25rem;
            max-height: 0;
            opacity: 0;
            overflow: hidden;
            -webkit-transition: all 0.25s ease-in-out;
            -moz-transition:    all 0.25s ease-in-out;
            transition:         all 0.25s ease-in-out;
          }
          .platform--results.open {
            max-height: 600%;
            opacity: 0.99999;
            overflow: visible;
          }
          .platform--hide {
            margin-bottom: 4.00rem;
            float: right;
            text-transform: uppercase;
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
        .comparison.failed,
        .comparison.success {
          position: relative;
          z-index: 0;
        }
        .comparison.failed::before,
        .comparison.success::before {
          content: "";
          position: absolute;
          top: -0.25rem;
          right: -0.25rem;
          bottom: -0.25rem;
          left: -0.25rem;
          box-shadow: 0 1px 2px 0 #DED3D3;
          z-index: -1;
        }
        .comparison.failed::before {
          border: 0.25rem solid #FFB5AA;
        }
        .comparison.success::before {
          border: 0.25rem solid #B3CCB1;
        }
          .comparison--name {
            margin-bottom: 0.50rem;
            color: #997257;
            font-weight: bold;
            text-transform: lowercase;
          }
          .comparison--name.failed {
            color: #CC5B4A;
          }
          .comparison--name.success {
            color: #7C917A;
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
            -webkit-align-content: flex-start;
            -ms-flex-line-pack: start;
            align-content: flex-start;
            -webkit-box-align: start;
            -moz-box-align: start;
            -webkit-align-items: flex-start;
            -ms-flex-align: start;
            align-items: flex-start;
            min-height: 15%;
          }
            .comparison--shot {
              position: relative;
              overflow: hidden;
            }
            .comparison--shot__3up {
              max-width: 33.33333%;
            }
            .comparison--shot__3up.missing {
              width: 33.33333%;
            }
            .comparison--shot__2up {
              max-width: 50%;
            }
            .comparison--shot__2up.missing {
              width: 50%;
            }
            .comparison--shot__1up {
              max-width: 100%;
            }
            .comparison--shot__1up.missing {
              width: 100%;
            }
            .comparison--shot[href]::after {
              position: absolute;
              top: -0.25rem;
              right: -0.25rem;
              bottom: -0.25rem;
              left: -0.25rem;
              content: "";
              opacity: 0;
              border: 0.25rem solid #99A9C2;
              z-index: 1;
            }
            .comparison--shot[href]:focus::after,
            .comparison--shot[href]:active::after,
            .comparison--shot[href]:hover::after {
              opacity: 0.99999;
            }
            .comparison--sample {
              min-width: 5em;
              text-align: center;
            }
            .comparison--diff {}
            .comparison--diff.hide {
              display: none;
            }
            .comparison--base {}
              .comparison--img {}
              .comparison--img__overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: auto;
                height: auto;
                max-width: initial;
                opacity: 0;
                -webkit-transition: opacity 0.25s ease-in-out;
                -moz-transition:    opacity 0.25s ease-in-out;
                transition:         opacity 0.25s ease-in-out;
              }
              .comparison--img__overlay.show {
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
                opacity: 0.99999;
                -webkit-transition: opacity 0.25s ease-in-out;
                -moz-transition:    opacity 0.25s ease-in-out;
                transition:         opacity 0.25s ease-in-out;
              }
              .comparison--label.hide {
                opacity: 0;
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
          var platformViewModel, resultViewModel, addViewModels;
          platformViewModel = {
            open: true
          };
          resultViewModel = {
            screens: 3,
            overlay: false,
            labels: true
          };
          // _.extend(obj, { view: _.clone(resultViewModel) });
          addViewModels = function(results) {
            _.each(results, function(platform){
              _.extend(platform, { view: _.clone(platformViewModel) });
              _.each(platform.results, function(result){
                _.extend(result, { view: _.clone(resultViewModel) });
              });
            });
            return results;
          };
          $scope.results = addViewModels(window.results);
          $scope.view = _.extend({}, resultViewModel);
          $scope.setAllScreens = function(n) {
            if ( n !== $scope.view.screens ) {
              $scope.view.screens = n;
              _.each($scope.results, function(platform) {
                _.each(platform.results, function(result) {
                  result.view.screens = n;
                });
              });
            }
          };
          $scope.toggleAllOverlays = function(o) {
            $scope.view.overlay = !$scope.view.overlay;
            _.each($scope.results, function(platform) {
              _.each(platform.results, function(result) {
                result.view.overlay = $scope.view.overlay;
              });
            });
            return $scope.view.overlay;
          };
          $scope.toggleAllLabels = function(l) {
            $scope.view.labels = !$scope.view.labels;
            _.each($scope.results, function(platform) {
              _.each(platform.results, function(result) {
                result.view.labels = $scope.view.labels;
              });
            });
            return $scope.view.labels;
          };
        }
      </script>
  </head>

  <body class="report" ng-controller="ReportController">

    <menu class="report--toolbar">
      <menu class="button-group report--view">
        <button type="button" title="Sample only"
         ng-click="setAllScreens(1)"
         ng-class="{'active': view.screens === 1}">
          <i class="icon square"></i>
          <b class="icon--text">1 up</b>
        </button>
        <button type="button" title="Sample vs. Baseline"
         ng-click="setAllScreens(2)"
         ng-class="{'active': view.screens === 2}">
          <i class="icon square"></i>
          <i class="icon square"></i>
          <b class="icon--text">2 up</b>
        </button>
        <button type="button" title="Sample, Difference, and Baseline"
         ng-click="setAllScreens(3)"
         ng-class="{'active': view.screens === 3}">
          <i class="icon square"></i>
          <i class="icon square"></i>
          <i class="icon square"></i>
          <b class="icon--text">3 up</b>
        </button>
      </menu>
      <menu class="report--opts">
        <menu class="button-group">
          <span class="button-group--label">
            Overlays:
          </span>
          <button type="button"
           ng-click="toggleAllOverlays()"
           ng-class="{'active': view.overlay == true}">
            On
          </button>
          <button type="button"
           ng-click="toggleAllOverlays()"
           ng-class="{'active': view.overlay == false}">
            Off
          </button>
        </menu>
        <menu class="button-group">
          <span class="button-group--label">
            Labels:
          </span>
          <button type="button"
           ng-click="toggleAllLabels()"
           ng-class="{'active': view.labels == true}">
            On
          </button>
          <button type="button"
           ng-click="toggleAllLabels()"
           ng-class="{'active': view.labels == false}">
            Off
          </button>
        </menu>
      </menu>
    </menu>

    <div class="platform" ng-repeat="(platformName,platform) in results">

      <a class="platform--name close" id="{{platformName}}"
       ng-class="{'open': platform.view.open, 'closed': !platform.view.open}"
       ng-href="{{platform.view.open && '#close' || !platform.view.open && '#open'}}"
       ng-click="platform.view.open = !platform.view.open">
        {{platformName}}
      </a>

      <div class="platform--results open"
       ng-class="{'open': platform.view.open}">
        <section class="result comparison"
         ng-repeat="result in platform.results | orderBy:'failed':true"
         ng-class="{'failed':result.failed, 'success': !result.failed}">
          <h2 class="comparison--name"
           ng-class="{'failed':result.failed, 'success': !result.failed}">
            {{result.name}}
          </h2>
          <div class="comparison--images">
            <figure
             class="comparison--sample comparison--shot comparison--shot__{{result.view.screens}}up"
             ng-class="{'comparison--shot__2up': !result.failed, 'missing': !result.files.sample.exists}">
              <img class="comparison--img"
               ng-src="{{result.files.sample.url}}" />
              <img class="comparison--img__overlay"
               ng-class="{'show': result.view.overlay}"
               ng-src="{{result.files.diff.url}}"
               ng-if="result.failed && result.files.diff.exists" />
              <div class="missing--text" ng-if="!result.files.sample.exists">
                Sample Missing
              </div>
              <figcaption class="comparison--label"
               ng-class="{'hide': !result.view.labels}"
               ng-if="result.files.sample.exists">
                Sample
              </figcaption>
            </figure>
            <figure
             class="comparison--diff comparison--shot comparison--shot__{{result.view.screens}}up"
             ng-class="{'missing': !result.files.diff.exists}"
             ng-if="result.failed && result.view.screens === 3">
              <img class="comparison--img"
               ng-src="{{result.files.diff.url}}" />
              <div class="missing--text" ng-if="!result.files.diff.exists">
                Diff Missing
              </div>
              <figcaption class="comparison--label"
               ng-class="{'hide': !result.view.labels}"
               ng-if="result.files.diff.exists">
                Difference
              </figcaption>
            </figure>
            <figure
             class="comparison--shot comparison--shot__{{result.view.screens}}up comparison--base"
             ng-class="{'comparison--shot__2up': !result.failed, 'missing': !result.files.base.exists}"
             ng-if="result.view.screens === 2 || result.view.screens === 3">
              <img class="comparison--img"
               ng-src="{{result.files.base.url}}"
               ng-if="result.files.base.exists" />
              <figcaption class="missing--text" ng-if="!result.files.base.exists">
                Baseline Missing
              </figcaption>
              <img class="comparison--img__overlay"
               ng-class="{'show': result.view.overlay}"
               ng-src="{{result.files.diff.url}}"
               ng-if="result.failed && result.files.diff.exists" />
              <figcaption class="comparison--label"
               ng-class="{'hide': !result.view.labels}"
               ng-if="result.files.base.exists">
                Baseline
              </figcaption>
            </figure>
          </div>
          <div class="comparison--menu">
            <menu class="button-group comparison--view">
              <button type="button" title="Sample only"
               ng-click="result.view.screens = 1"
               ng-class="{'active': result.view.screens === 1}">
                <i class="icon square"></i>
                <b class="icon--text">1 up</b>
              </button>
              <button type="button" title="Sample vs. Baseline"
               ng-click="result.view.screens = 2"
               ng-class="{'active': result.view.screens === 2 || (!result.failed && result.view.screens === 3)}">
                <i class="icon square"></i>
                <i class="icon square"></i>
                <b class="icon--text">2 up</b>
              </button>
              <button type="button" title="Sample, Difference, and Baseline"
               ng-if="result.failed"
               ng-click="result.view.screens = 3"
               ng-class="{'active': result.view.screens === 3}">
                <i class="icon square"></i>
                <i class="icon square"></i>
                <i class="icon square"></i>
                <b class="icon--text">3 up</b>
              </button>
            </menu>
            <menu class="comparison--opts">
              <button type="button"
               ng-if="result.failed && result.files.diff.url"
               ng-click="result.view.overlay = !result.view.overlay">
                <b ng-if="!result.view.overlay">Show</b>
                <b ng-if="result.view.overlay">Hide</b>
                Overlay
              </button>
              <button type="button"
               ng-click="result.view.labels = !result.view.labels">
                <b ng-if="!result.view.labels">Show</b>
                <b ng-if="result.view.labels">Hide</b>
                Labels
              </button>
            </menu>
          </div>
        </section>

        <a class="platform--hide"
         ng-href="{{'#' + platformName}}"
         ng-click="platform.view.open = !platform.view.open">
          <i class="icon check">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 9">
              <polyline fill="none" stroke="currentColor" points="1,5 4,8 9,1" />
            </svg>
          </i>
          Hide {{platformName}}
        </a>

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
