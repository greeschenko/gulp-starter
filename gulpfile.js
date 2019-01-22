'use strict';

// Load plugins
var gulp = require('gulp'),
    sass = require('gulp-sass'),
    pug = require('gulp-pug'),
    autoprefixer = require('gulp-autoprefixer'),
    cssnano = require('gulp-cssnano'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    rename = require('gulp-rename'),
    livereload = require('gulp-livereload'),
    del = require('del'),
    babel = require('gulp-babel');

//Libs
gulp.task('libscss', function() {
    return gulp.src([
            './node_modules/components-font-awesome/css/font-awesome.min.css',
            './node_modules/bootstrap/dist/css/bootstrap.min.css',
        ])
        .pipe(concat('libs.css'))
        .pipe(gulp.dest('./web/css'));
});

gulp.task('libsjs', function() {
    return gulp.src([
            './node_modules/jquery/dist/jquery.min.js',
            './node_modules/hatajs/web/js/hatajs.min.js',
            './node_modules/bootstrap/dist/js/bootstrap.min.js',
        ])
        .pipe(concat('libs.js'))
        .pipe(gulp.dest('./web/js'));
});

// Fonts
gulp.task('fonts', function() {
    return gulp.src([
            './node_modules/components-font-awesome/fonts/fontawesome-webfont.*'
        ])
        .pipe(gulp.dest('./web/fonts'));
});


// Styles
gulp.task('styles', function() {
    return gulp.src('./src/sass/**/*.sass')
        .pipe(sass.sync().on('error', sass.logError))
        .pipe(autoprefixer('last 2 version'))
        .pipe(gulp.dest('./web/css'))
        .pipe(rename({
            suffix: '.min'
        }))
        .pipe(cssnano())
        .pipe(gulp.dest('./web/css'))
        .pipe(livereload());
});

//Pug
gulp.task('html', function() {
    return gulp.src('./src/tmpl/**/*.pug')
        .pipe(pug({
            pretty: true
        }))
        .pipe(gulp.dest('./web/'))
        .pipe(livereload());
});

// Scripts
gulp.task('scripts', function() {
    return gulp.src('src/js/**/*.js')
        .pipe(babel({
            presets: ['@babel/env']
        }))
        .pipe(rename({
            suffix: '.min'
        }))
        .pipe(uglify())
        .pipe(gulp.dest('./web/js'))
        .pipe(livereload());
});

gulp.task('libinit', ['libscss', 'libsjs', 'fonts']);

// Watch
gulp.task('watch', function() {
    // Create LiveReload server
    livereload.listen();

    // Watch .scss files
    gulp.watch('./src/sass/**/*.sass', ['styles']);

    // Watch .jade files
    gulp.watch('./src/tmpl/**/*.pug', ['html']);

    // Watch .js files
    gulp.watch('./src/js/**/*.js', ['scripts']);
});

// Default task
gulp.task('default', ['libinit', 'watch']);
