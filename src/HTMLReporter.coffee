class HTMLReporter

  constructor: ->
    @report = {}

  addTestResult: (platform, result) ->
    @report[platform] ?= []
    @report[platform].push

  createReport: ->
    console.log @report 

module.exports = HTMLReporter