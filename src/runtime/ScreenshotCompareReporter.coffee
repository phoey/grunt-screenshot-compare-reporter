module.exports = (Util, Promise, _, FileUtils, PlatformReporter, options, HTMLReporter)->

  class ScreenshotCompareReporter


    constructor:()->
      console.log options
      @baselineDir = options.baselineDirectory
      @sampleDir = options.sampleDirectory
      @reportDir = options.reportDirectory


    run:()->
      Util.promiseQueue([
        @getPlatforms
        @testPlaforms
        @writeHtmlReport
      ]).then ()=> @

    testPlaforms:()=>
      Promise.all(
        _.map(@platforms, PlatformReporter.run)
      ).then (results)=>
        @results = _.indexBy(results, "platform")


    getPlatforms:()=>
      Promise.all([
        FileUtils.getDirectories(@baselineDir)
        FileUtils.getDirectories(@sampleDir)
      ]).then (results)=>
        @platforms = _.uniq(_.flatten(results))

    writeHtmlReport:()=>
      HTMLReporter.write(@results)
