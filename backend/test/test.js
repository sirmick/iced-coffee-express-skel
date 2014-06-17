(function() {
  var chai, extras;

  chai = require('chai');

  extras = require('chai-extras');

  chai.use(extras);

  chai.expect();

  require('./test-stuff');

}).call(this);

/*
//@ sourceMappingURL=test.js.map
*/