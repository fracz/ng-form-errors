WEBAPP_DIR = 'src/main/webapp';
TEST_DIR = 'src/test/webapp';

module.exports = function (config) {
    config.set({
        basePath: '../',

        files: [
            'bower_components/angular/angular.min.js',
            'bower_components/angular-mocks/angular-mocks.js',
            'bower_components/jquery/dist/jquery.min.js',
            'dist/ng-form-errors.min.js',
            'test/.compiled/**/*.js',
            {pattern: 'test/**/*.html', include: true}
        ],

        autoWatch: true,

        frameworks: ['jasmine'],

        preprocessors: {
            '**/*.html': ['html2js']
        },

        browsers: ['PhantomJS'],

        reporters: ['dots'],

        plugins: [
            'karma-phantomjs-launcher',
            'karma-jasmine',
            'karma-mocha-reporter',
            'karma-html2js-preprocessor'
        ]
    })
};
