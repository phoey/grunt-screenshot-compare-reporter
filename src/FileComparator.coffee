resembleApi = require 'resemble'
Q           = require 'q'
fs          = require 'fs'
Utils       = require './Utils'

class FileComparator

  @THRESHOLD: 4

  constructor:(@name, @resultsDir, @srcFiles) ->
    @name = @name.replace(".png", "")

    @baselineName = "#{@name}-baseline.png"
    @sampleName = "#{@name}-sample.png"
    @diffName = "#{@name}-diff.png"

    @baseline = "#{@resultsDir}/#{@baselineName}"
    @sample = "#{@resultsDir}/#{@sampleName}"
    @diff = "#{@resultsDir}/#{@diffName}"

    @result = {}

  storeScreenshot: (rawData, file) ->
    deferred = Q.defer()
    data = rawData.replace(/^data:image\/png;base64,/,"")
    fs.writeFile(file, data, encoding:'base64', deferred.resolve)
    deferred.promise

  _copyImages: ->
    Q.all [
      Utils.copyFile(@srcFiles.baseline, @baseline)
      Utils.copyFile(@srcFiles.sample, @sample)
    ]

  _compareImages: =>
    deferred = Q.defer()
    resembleApi.resemble(@sample).compareTo(@baseline).onComplete deferred.resolve
    return deferred.promise

  _differenceData: (difference) =>
    deferred = Q.defer()
    hasDifference = parseInt(difference.misMatchPercentage) >= FileComparator.THRESHOLD

    @result = {
      @name
      failed: hasDifference
      difference
      paths: {
        @sampleName
        @baselineName
        @diffName
      }
    }

    @storeScreenshot(difference.getImageDataUrl(), @diff).then =>
      deferred.resolve @result

    return deferred.promise

  compare: ->
    @_copyImages()
      .then(@_compareImages)
      .then(@_differenceData)

module.exports = FileComparator