gulp = require('gulp')
$ = require('gulp-load-plugins')();
del = require('del')
runSequence = require('run-sequence')

gulp.task 'styles', ->
  gulp.src('src/*.css')
  .pipe(gulp.dest('dist'))

gulp.task 'scripts', ->
  coffeeStream = $.coffee(bare: yes)
  coffeeStream.on 'error', (error) ->
    $.util.log(error)
    coffeeStream.end()
  gulp.src('src/**/*.coffee')
  .pipe(coffeeStream)
  .pipe($.angularFilesort())
  .pipe($.ngAnnotate())
  .pipe($.concat('ng-form-errors.js'))
  .pipe(gulp.dest('dist'))
  .pipe($.uglify())
  .pipe($.concat('ng-form-errors.min.js'))
  .pipe(gulp.dest('dist'))

gulp.task 'build-tests', ->
  gulp.src('test/**/*.coffee')
  .pipe($.coffee(bare: yes))
  .pipe(gulp.dest("test/.compiled"))

gulp.task 'run-tests', ['build-tests'], ->
  browsers = ['PhantomJS']
  reporters = ['mocha']
  # foobar explanation: http://stackoverflow.com/a/22417732/878514
  # TL;DR when gulp.src fails to find specified file, gulp-karma uses the files specified in karma.conf.js
  gulp.src('./foobar')
  .pipe $.karma
    configFile: 'test/karma.conf.js'
    action: 'run'
    browsers: browsers
    reporters: reporters

gulp.task 'clean', (done) ->
  del(['dist/**', 'test/.compiled'], done)

gulp.task 'test', (done) ->
  runSequence 'default', 'run-tests', done

gulp.task 'default', (done) ->
  runSequence 'clean', 'styles', 'scripts', done
