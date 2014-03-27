var through = require('through2');
var gulp = require('gulp');
var ejsLib = require('ejs');

/* Returns a gulp handler that compiles the given EJS files.
 *
 * Arguments:
 * variables -- variable name-value pairs that will be accessible in EJS
 */
function ejs(variables) {
  variables = variables || {};

  return through.obj(function(file, enc, callback) {
    // ignore null files
    if (file.isNull()) {
      this.push(file);
      return callback();
    }

    // ignore streams
    if (file.isStream()) {
      this.emit('error', new gutil.PluginError('gulp-ejs', 'Streaming not supported'));
      return callback();
    }

    // set filename for EJS caching
    variables.filename = variables.filename || file.path;
    try {
      file.contents = new Buffer(ejsLib.render(file.contents.toString(), variables));
    } catch (err) {
      this.emit('error', new gutil.PluginError('gulp-ejs', err.toString()));
    }

    this.push(file);
    return callback();
  });
}

/* Compile files and scripts, passing in the given EJS variables. */
function compileFilesAndScripts(variables) {
  gulp.src('./files-templates/**/*')
    .pipe(ejs(variables))
    .pipe(gulp.dest('./files'));

  gulp.src('./scripts-templates/**/*')
    .pipe(ejs(variables))
    .pipe(gulp.dest('./scripts'));
}

/* Compile files and scripts to create a dev server. */
gulp.task('dev', function() {
  compileFilesAndScripts({ production: false });
});


/* Compile files and scripts to create prod server. */
gulp.task('prod', function() {
  compileFilesAndScripts({ production: true });
});
