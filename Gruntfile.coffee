module.exports = (grunt) ->

  grunt.initConfig

    coffee:
      compile:
        expand: true,
        flatten: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib/'
        ext: '.js'

    
    screenshot_compare_reporter:
      dev:
        baselineDirectory: "./test/resources/baseline"
        sampleDirectory: "./test/resources/sample"
        reportDirectory: "./test-results"


  grunt.loadTasks('tasks')
  grunt.loadNpmTasks('grunt-contrib-coffee')

  grunt.registerTask "default", [
    'coffee',  
    'screenshot_compare_reporter'
  ]


