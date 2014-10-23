module.exports = (options, _, Util, Promise, FileUtils, path, ImageComparison, mkdirpAsync)->


  class PlatformReporter

    constructor:(@platform)->
      @baselinePlatform = path.join(options.baselineDirectory,@platform)
      @samplePlatform = path.join(options.sampleDirectory,@platform)

    @run:(platform)->
      new PlatformReporter(platform).run()


    run:()->
      Util.promiseQueue([
        @getAllFiles
        @createReportDir
        @compareFiles
      ]).then ()=> @

    createReportDir:()=>
      mkdirpAsync path.join(options.reportDirectory, @platform)

    getAllFiles:()=>
      FileUtils.flatFilenames([@baselinePlatform, @samplePlatform])
        .then (@filenames)=>


    compareFiles:()=>
      Promise.all(_.map @filenames, @compareFile)
        .then (@results)=>

    compareFile:(filename)=>
      ImageComparison.compare(filename, @platform)
