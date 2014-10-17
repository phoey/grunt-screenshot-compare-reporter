module.exports = (options, _, Util, Promise, FileUtils, path, ImageComparison, mkdirpAsync)->


  class PlatformReporter

    constructor:(@platform)->

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
      Promise.all([
        FileUtils.getFiles(path.join(options.baselineDirectory,@platform))
        FileUtils.getFiles(path.join(options.sampleDirectory,@platform))
      ]).then (@results)=>
        @filenames = _.uniq(_.flatten(@results))

    compareFiles:()=>
      Promise.all(_.map @filenames, @compareFile)
        .then (@results)=>

    compareFile:(filename)=>
      ImageComparison.compare(filename, @platform)
