var reporter = require("../lib/ScreenshotCompareReporter");

module.exports = function (grunt) {

  grunt.registerMultiTask('screenshot_compare_reporter', 'compares and reports', function() {
    var options = this.options(this.data)
    var cb = this.async();
    new reporter(grunt, options).then(function() {
      cb()
    })
  })

}