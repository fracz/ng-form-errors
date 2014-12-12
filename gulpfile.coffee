gulp = require('gulp')
$ = require('gulp-load-plugins')();
# bowerFiles = require("main-bower-files")
del = require('del')
runSequence = require('run-sequence')

gulp.task 'bowerdeps', ->
  gulp.src(bowerFiles(), base: 'bower_components')
  .pipe(gulp.dest('public/libs'))

gulp.task 'scripts', ->
  coffeeStream = $.coffee(bare: yes)
  coffeeStream.on 'error', (error) ->
    $.util.log(error)
    coffeeStream.end()
  gulp.src('src/**/*.coffee')
  .pipe(coffeeStream)
  .pipe($.angularFilesort())
  .pipe($.ngAnnotate())
  .pipe($.concat('ng-form-erros.js'))
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
#  if argv.chrome then browsers.push('Chrome')
#  if argv.firefox then browsers.push('Firefox')
#  if argv.ie then browsers.push('IE')
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
  runSequence 'clean', 'scripts', 'run-tests', done

gulp.task 'default', (done) ->
  runSequence 'clean', 'scripts', done

gulp.task 'watch', (done) ->
  runSequence 'clean', 'default', ->
    gulp.watch('src/**/*.coffee', ['scripts'])
    gulp.watch('views/**/*.html', ['views'])
    gulp.watch('src/styles.css', ['styles'])
    done()
