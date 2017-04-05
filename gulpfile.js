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
    del = require('del'),
    babel = require('gulp-babel');

//Libs
gulp.task('libscss', function() {
    return gulp.src([
            './node_modules/bootstrap/dist/css/bootstrap.min.css',
            './node_modules/components-font-awesome/css/font-awesome.min.css',
        ])
        .pipe(concat('libs.css'))
        .pipe(gulp.dest('./web/css'));
});

gulp.task('libsjs', function() {
    return gulp.src([
            './node_modules/jquery/dist/jquery.min.js',
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
        .pipe(gulp.dest('web/css'));
});

// Jade
gulp.task('jade', function() {
    return gulp.src('./src/tmpl/**/*.jade')
        .pipe(jade({
            pretty: true
        }))
        .pipe(gulp.dest('./web/'));
});

// Scripts
gulp.task('scripts', function() {
    return gulp.src('src/js/**/*.js')
        .pipe(babel({
            presets: ['es2015']
        }))
        .pipe(rename({
            suffix: '.min'
        }))
        .pipe(uglify())
        .pipe(gulp.dest('./web/js'));
});

// Images
gulp.task('images', function() {
    return gulp.src('./src/img/**/*')
        .pipe(cache(imagemin({
            optimizationLevel: 3,
            progressive: true,
            interlaced: true
        })))
        .pipe(gulp.dest('./web/img'));
});

// Clean
gulp.task('clean', function() {
    return del(['web/css', 'web/js', 'web/img']);
});

gulp.task('all', function() {
    gulp.src('./web/**')
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

    // Watch any files in web/, reload on change
    gulp.watch(['web/**'], ['all']);

    gulp.watch(['web/**'], ['libscss']);
    gulp.watch(['web/**'], ['libsjs']);
    gulp.watch(['web/**'], ['fonts']);
});
