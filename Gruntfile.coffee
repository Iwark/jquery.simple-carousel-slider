module.exports = (grunt)->

  grunt.initConfig

    # Import package manifest
    pkg: grunt.file.readJSON("package.json")

    # Bower Installation
    bower:
      install:
        options:
          install: true
          cleanTargetDir: true
          cleanBowerDir: false

    # CoffeeScript compilation
    coffee:
      compile:
        options:
          join: true
        files:
          'src/js/jquery.simple-carousel-slider.js': ['src/**/*.coffee']

    # Banner definitions
    meta:
      banner:
        """
        /*
         *  <%= pkg.title || pkg.name %> - v<%= pkg.version %>
         *  <%= pkg.description %>
         *  <%= pkg.homepage %>
         *
         *  Made by <%= pkg.author %>
         *  Under <%= pkg.license %> License
         */

        """

    # Concat definitions
    concat:
      options:
        banner: "<%= meta.banner %>"
      dist:
        src: ['src/js/jquery.simple-carousel-slider.js'],
        dest: 'dist/js/jquery.simple-carousel-slider.js'

    # Minify definitions
    uglify:
      target:
        files: [
          'dist/js/jquery.simple-carousel-slider.min.js': ['dist/js/jquery.simple-carousel-slider.js']
        ]
      options:
        banner: "<%= meta.banner %>"

    # Generate Codo documentation for CoffeeScript
    codo:
      src: [
        'src'
      ]

    # Sass compilation
    sass:
      src:
        options:
          sourcemap: 'none'
        files:
          'src/css/jquery.simple-carousel-slider.css'  : 'src/css/jquery.simple-carousel-slider.scss'
      dist:
        options:
          sourcemap: 'none',
          style: 'compressed'
        files:
          'dist/css/jquery.simple-carousel-slider.css'  : 'src/css/jquery.simple-carousel-slider.scss'

    # Watch for changes to source
    watch:
      coffee:
        files: ['src/**/*.coffee']
        tasks: ['coffee', 'concat', 'uglify', 'codo']
      sass:
        files: ['src/**/*.scss']
        tasks: ['sass']

    grunt.loadNpmTasks('grunt-bower-task')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks("grunt-contrib-concat")
    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-codo')
    grunt.loadNpmTasks('grunt-contrib-sass')
    grunt.loadNpmTasks('grunt-contrib-watch')

    grunt.registerTask('default', ['bower:install','watch'])
