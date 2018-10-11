module.exports = function(config) {
  config.set({
    browsers: ['PhantomJS'],
    client: {
      captureConsole: false
    },
    files: [
      APPLICATION_SPEC,
      'spec/javascripts/*/*.js',
    ],
    frameworks: ['jasmine'],
    logLevel: config.LOG_ERROR,
    singleRun: true,
    reporters: ['dots']
  });
};
