"use strict"
request = require("request")
module.exports = (grunt) ->
  require("time-grunt")(grunt)
  require("load-grunt-tasks")(grunt)
  reloadPort = 35729
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    develop:
      backend:
        file: "backend/app.js"
        
        #cmd: 'iced',
        #nodeArgs: ['--nodejs','--debug']//,'--nodejs','--debug-brk']*/
        #file: 'server/app.js',
        nodeArgs: ["--debug"]

    exec:
      node_inspector:
        command: "node-inspector --save-live-edit &"

    watch:
      options:
        nospawn: true
        livereload: reloadPort
      backend:
        files: [
          "backend/**/*.coffee"
          "backend/**/*.js"
        ]
        tasks: [
          "coffee:backend"
          "develop:backend"
          "delayed-livereload"
        ]
        options:
          livereload: reloadPort
      handlebars:
        files: [
          "backend/views/**/*.handlebars"
          "backend/views/**/*.html"
        ]
        tasks: [
          "coffee:backend"
          "coffee:frontend"
          "develop:backend"
          "delayed-livereload"
        ]
        options:
          livereload: reloadPort
      client:
        files: ["frontend/*.coffee"]
        tasks: ["coffee:frontend"]
        options:
          livereload: reloadPort
      sass:
        files: ["frontend/scss/*.scss"]
        tasks: ["sass:frontend"]
        options:
          livereload: reloadPort
      images:
        files: ["frontend/images/*.{png,jpg,gif}"]
        tasks: ["imagemin:frontend"]
        options:
          livereload: reloadPort

    open:
      frontend:
        path: "http://localhost:3001"
      node_inspector:
        path: "http://127.0.0.1:8080/debug?port=5858"

    coffee:
      frontend:
        options:
          sourceMap: true
          sourceRoot: "/frontend/"
          runtime: "window"
        files:
          "public/js/app.js": "frontend/app.coffee"
      backend:
        options:
          sourceMap: true
        files:
          "backend/app.js": "backend/app.coffee"
      test:
        options:
          sourceMap: true
        files:
          "backend/test/test-stuff.js": "backend/test/test-stuff.coffee"
          "backend/test/test.js": "backend/test/test.coffee"
    mochaTest:
      test:
        options:
          reporter: "spec"
          require: ["iced-coffee-script/register"]
          ui: "tdd"
        src: ["backend/test/test.js"]

    imagemin: # Task
      frontend: # Another target
        options: # Target options
          optimizationLevel: 3
        files: [
          expand: true # Enable dynamic expansion
          cwd: "frontend/" # Src matches are relative to this path
          src: ["**/*.{png,jpg,gif}"] # Actual patterns to match
          dest: "public/" # Destination path prefix
        ]

    replace:
      sass_sourcemap:
        src: ["public/**/*.css.map"]
        overwrite: true
        replacements: [
          from: "../../"
          to: "/"
        ]

    sass:
      frontend:
        options:
          sourcemap: true
        #debugInfo: true,
        files: [
          expand: true
          cwd: "frontend/scss"
          src: ["*.scss"]
          dest: "public/css"
          ext: ".css"
        ]

  grunt.config.requires "watch.backend.files"
  files = grunt.config("watch.backend.files")
  files = grunt.file.expand(files)
  grunt.registerTask "delayed-livereload", "Live reload after the node server has restarted.", ->
    done = @async()
    setTimeout (->
      request.get "http://localhost:" + reloadPort + "/changed?files=" + files.join(","), (err, res) ->
        reloaded = not err and res.statusCode is 200
        if reloaded
          grunt.log.ok "Delayed live reload successful."
        else
          grunt.log.error "Unable to make a delayed live reload."
        done reloaded
        return

      return
    ), 500
    return

  grunt.registerTask "build:backend", [
    "coffee:backend"
    "coffee:test"
  ]
  grunt.registerTask "build:frontend", [
    "coffee:frontend"
    "sass"
    "imagemin"
    "replace"
  ]
  grunt.registerTask "test:backend", [
    "build:backend"
    "mochaTest"
  ]
  grunt.registerTask "build:all", [
    "coffee:frontend"
    "coffee:backend"
    "sass:frontend"
    "replace:sass_sourcemap"
    "imagemin:frontend"
  ]
  grunt.registerTask "watch:develop", [
    "build:backend"
    "build:frontend"
    "develop:backend"
    "open:frontend"
    "watch"
  ]
  grunt.registerTask "default", ["watch:develop"]
  return  