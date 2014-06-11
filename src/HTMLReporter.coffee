Q              = require 'q'
fs             = require 'fs'
Utils       = require './Utils'

class HTMLReporter

  constructor: (@resultsDir) ->
    @report = {}

  addTestResult: (platform, result) ->
    @report[platform] = result

  copyHtmlReportViewer: ->
    Utils.copyFile("./resources/reporter.html", "#{@resultsDir}/reporter.html")

  saveReport: =>
    deferred = Q.defer()
    fs.writeFile "#{@resultsDir}/results.js", "window.results = #{JSON.stringify(@report)}", =>
      @copyHtmlReportViewer().then deferred.resolve

    return deferred.promise

module.exports = HTMLReporter