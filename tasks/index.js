var reporter = require("../lib/ScreenshotCompareReporter");

module.exports = function (grunt) {

  grunt.registerMultiTask('screenshot_compare_reporter', 'compares and reports', function() {
    var options = this.options(this.data)
    var cb = this.async();
    new reporter(grunt, options).then(function(report) {

      if (options.teamcityReporter) {

        grunt.log.writeln('##teamcity[testStarted name=\'screenshot compare\']');
        if (report.failed && options.failTeamcity) {
          grunt.log.writeln('##teamcity[testFailed name=\'screenshot compare\' message=\'FAILED\']');
        }
        grunt.log.writeln('##teamcity[testFinished name=\'screenshot compare\']');

      }

      cb()
    })
  })

}