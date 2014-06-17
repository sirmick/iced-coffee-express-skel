(function() {
  var chai, child_process, expect, path, sys;

  require('source-map-support').install();

  child_process = require('child_process');

  sys = require('sys');

  chai = require('chai');

  path = require('path');

  expect = chai.expect;

  suite('Logic layer', function() {
    return test('stuff', function(done) {
      return done();
    });
  });

}).call(this);

/*
//@ sourceMappingURL=test-stuff.js.map
*/