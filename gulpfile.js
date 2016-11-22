'use strict';

// Load plugins
var gulp = require('gulp'),
    sass = require('gulp-sass'),
    jade = require('gulp-jade'),
    autoprefixer = require('gulp-autoprefixer'),
    cssnano = require('gulp-cssnano'),
    uglify = require('gulp-uglify'),
    imagemin = require('gulp-imagemin'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),
    cache = require('gulp-cache'),
    livereload = require('gulp-livereload'),
    del = require('del');

// Styles
gulp.task('styles', function() {
    return gulp.src('./src/sass/**/*.sass')
        .pipe(sass.sync().on('error', sass.logError))
        .pipe(autoprefixer('last 2 version'))
        .pipe(gulp.dest('./dist/css'))
        .pipe(rename({
            suffix: '.min'
        }))
        .pipe(cssnano())
        .pipe(gulp.dest('dist/css'));
});

// Jade
gulp.task('jade', function() {
    return gulp.src('./src/tmpl/**/*.jade')
        .pipe(jade())
        .pipe(gulp.dest('./dist/'));
});

// Scripts
gulp.task('scripts', function() {
    return gulp.src('src/js/**/*.js')
        .pipe(rename({
            suffix: '.min'
        }))
        .pipe(uglify())
        .pipe(gulp.dest('./dist/js'));
});

// Images
gulp.task('images', function() {
    return gulp.src('./src/img/**/*')
        .pipe(cache(imagemin({
            optimizationLevel: 3,
            progressive: true,
            interlaced: true
        })))
        .pipe(gulp.dest('./dist/img'));
});

// Clean
gulp.task('clean', function() {
    return del(['dist/css', 'dist/js', 'dist/img']);
});

gulp.task('all', function() {
    gulp.src('./dist/**')
        .pipe(livereload());
});

// Default task
gulp.task('default', ['watch']);

// Watch
gulp.task('watch', function() {

    // Watch .scss files
    gulp.watch('./src/sass/**/*.sass', ['styles']);

    // Watch .jade files
    gulp.watch('./src/tmpl/**/*.jade', ['jade']);

    // Watch .js files
    gulp.watch('./src/js/**/*.js', ['scripts']);

    // Watch image files
    gulp.watch('./src/img/**/*', ['images']);

    // Create LiveReload server
    livereload.listen();

    // Watch any files in dist/, reload on change
    gulp.watch(['dist/**'], ['all']);

});
