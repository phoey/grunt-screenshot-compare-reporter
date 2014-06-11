
fs             = require 'fs'
async          = require 'async'
path           = require 'path'
Q              = require 'q'
mkdirp         = require 'mkdirp'
resembleApi    = require 'resemble'
HTMLReporter   = require './HTMLReporter'
FileComparator = require './FileComparator'
Utils          = require './Utils'
HTMLReporter   = require './HTMLReporter'

class ScreenshotCompareReporter

  constructor:(@grunt, @options) ->
    @HTMLReporter = new HTMLReporter(@options.reportDirectory)
    return @run()

  getSubFilesByType: (base, type) ->    
    files = fs.readdirSync(base)
    objects = []

    for file in files
      if file[0] != '.'
        filePath = "#{base}/#{file}"
        stat = fs.statSync(filePath)

        objects.push(file) if stat.isDirectory() and type is "directory"
        objects.push(file) if stat.isFile() and type is "file"

    return objects

  runReporterForPlatform: (platformDir) ->
    deferred = Q.defer()
    resultPromises = []

    baselineDir = @options.baselineDirectory
    sampleDir = @options.sampleDirectory
    reportPlatformDir = "#{@options.reportDirectory}/#{platformDir}"

    Utils.mkDirP(reportPlatformDir).then =>

      # get files from baseline and compare with sample
      for testFile in @getSubFilesByType("#{baselineDir}/#{platformDir}", "file")

        baselineFile = "#{baselineDir}/#{platformDir}/#{testFile}"
        sampleFile = "#{sampleDir}/#{platformDir}/#{testFile}"

        if Utils.fileExists(baselineFile) and Utils.fileExists(sampleFile)
          comparison = new FileComparator(testFile, reportPlatformDir, {baseline: baselineFile, sample:sampleFile})
          resultPromises.push comparison.compare()

      # add results
      Q.all(resultPromises).then (results) =>
        @HTMLReporter.addTestResult(platformDir, results)

  run: ->
    platformRuns = []

    for platformDir in @getSubFilesByType(@options.baselineDirectory, "directory")
      platformRuns.push @runReporterForPlatform(platformDir)

    Q.all(platformRuns)
      .then(@HTMLReporter.saveReport)
    

module.exports = ScreenshotCompareReporter
