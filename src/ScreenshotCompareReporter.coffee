
fs             = require 'fs'
async          = require 'async'
path           = require 'path'
Q              = require 'q'
mkdirp         = require 'mkdirp'
resembleApi    = require 'resemble'
HTMLReporter   = require './HTMLReporter'
FileComparator = require './FileComparator'
_              = require 'underscore'
Utils          = require './Utils'

class ScreenshotCompareReporter

  constructor:(@grunt, @options) ->
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
    reportDir = @options.reportDirectory

    # get files from baseline and compare with sample
    for testFile in @getSubFilesByType("#{baselineDir}/#{platformDir}", "file")

      baselineFile = "#{baselineDir}/#{platformDir}/#{testFile}"
      sampleFile = "#{sampleDir}/#{platformDir}/#{testFile}"

      if Utils.fileExists(baselineFile) and Utils.fileExists(sampleFile)
        comparison = new FileComparator(testFile, reportDir, {baseline: baselineFile, sample:sampleFile})
        resultPromises.push comparison.compare()

    # add results
    Q.all(resultPromises).then @saveReport

  saveReport: (results) => 
    fs.writeFileSync("#{@options.reportDirectory}/results.json", JSON.stringify(results))
    results

  run: ->
    platformRuns = []

    for platformDir in @getSubFilesByType(@options.baselineDirectory, "directory")
      platformRuns.push @runReporterForPlatform(platformDir)

    return Q.all(platformRuns)
    

module.exports = ScreenshotCompareReporter
