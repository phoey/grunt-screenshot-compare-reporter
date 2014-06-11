resembleApi = require 'resemble'
Q           = require 'q'
fs          = require 'fs'

class FileComparator

  @THRESHOLD: 5

  constructor:(@name, @resultsDir, @srcFiles) ->
    @name = @name.replace(".png", "")
    @baseline = "#{@resultsDir}/#{@name}-baseline.png"
    @sample = "#{@resultsDir}/#{@name}-sample.png"
    @diff = "#{@resultsDir}/#{@name}-diff.png"

    @result = {}

  storeScreenshot: (rawData, file) ->
    deferred = Q.defer()
    data = rawData.replace(/^data:image\/png;base64,/,"")
    fs.writeFile(file, data, encoding:'base64', deferred.resolve)
    deferred.promise

  _copyImage: (file, dest) ->
    deferred = Q.defer()
    rs = fs.createReadStream(file)
    ws = fs.createWriteStream(dest)
    rs.on "close", deferred.resolve
    rs.on "error", deferred.reject
    ws.on "error", deferred.reject
    rs.pipe(ws)
    return deferred.promise

  _copyImages: ->
    Q.all [
      @_copyImage(@srcFiles.baseline, @baseline)
      @_copyImage(@srcFiles.sample, @sample)
    ]

  _compareImages: =>
    deferred = Q.defer()
    resembleApi.resemble(@sample).compareTo(@baseline).onComplete deferred.resolve
    return deferred.promise

  _differenceData: (difference) =>
    deferred = Q.defer()
    hasDifference = parseInt(difference.misMatchPercentage) >= @THRESHOLD

    @result = {
      @name
      failed: hasDifference
      difference
      paths: {
        @sample
        @baseline
        @diff
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