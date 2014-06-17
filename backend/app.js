(function() {
  var app, csvs, exphbs, express, fs, func, glob, handlebars, http, iced, loadFilesFromDir, path, templates, util, _, __iced_deferrals, __iced_k, __iced_k_noop;

  iced = require('iced-coffee-script').iced;
  __iced_k = __iced_k_noop = function() {};

  require('source-map-support').install();

  express = require("express");

  http = require("http");

  path = require("path");

  util = require('util');

  exphbs = require('express3-handlebars');

  _ = require("underscore");

  glob = require("glob");

  fs = require('fs');

  app = express();

  loadFilesFromDir = function(dir, pattern, completed) {
    var data, error, file, files, here, results, ___iced_passed_deferral, __iced_deferrals, __iced_k;
    __iced_k = __iced_k_noop;
    ___iced_passed_deferral = iced.findDeferral(arguments);
    here = process.cwd();
    results = {};
    console.log('loading', pattern, 'from', dir);
    process.chdir(dir);
    (function(_this) {
      return (function(__iced_k) {
        __iced_deferrals = new iced.Deferrals(__iced_k, {
          parent: ___iced_passed_deferral,
          filename: "backend/app.coffee"
        });
        glob(pattern, {}, __iced_deferrals.defer({
          assign_fn: (function() {
            return function() {
              error = arguments[0];
              return files = arguments[1];
            };
          })(),
          lineno: 17
        }));
        __iced_deferrals._fulfill();
      });
    })(this)((function(_this) {
      return function() {
        if (error) {
          throw Error(error);
        }
        (function(__iced_k) {
          var _i, _len, _ref, _results, _while;
          _ref = files;
          _len = _ref.length;
          _i = 0;
          _results = [];
          _while = function(__iced_k) {
            var _break, _continue, _next;
            _break = function() {
              return __iced_k(_results);
            };
            _continue = function() {
              return iced.trampoline(function() {
                ++_i;
                return _while(__iced_k);
              });
            };
            _next = function(__iced_next_arg) {
              _results.push(__iced_next_arg);
              return _continue();
            };
            if (!(_i < _len)) {
              return _break();
            } else {
              file = _ref[_i];
              (function(__iced_k) {
                __iced_deferrals = new iced.Deferrals(__iced_k, {
                  parent: ___iced_passed_deferral,
                  filename: "backend/app.coffee"
                });
                fs.readFile(file, {
                  encoding: 'utf-8'
                }, __iced_deferrals.defer({
                  assign_fn: (function() {
                    return function() {
                      error = arguments[0];
                      return data = arguments[1];
                    };
                  })(),
                  lineno: 20
                }));
                __iced_deferrals._fulfill();
              })(function() {
                if (error) {
                  throw Error(error);
                }
                return _next(results[file] = data);
              });
            }
          };
          _while(__iced_k);
        })(function() {
          process.chdir(here);
          return completed(results);
        });
      };
    })(this));
  };

  (function(_this) {
    return (function(__iced_k) {
      __iced_deferrals = new iced.Deferrals(__iced_k, {
        filename: "backend/app.coffee"
      });
      loadFilesFromDir('backend/views', '**/*.handlebars', __iced_deferrals.defer({
        assign_fn: (function() {
          return function() {
            return templates = arguments[0];
          };
        })(),
        lineno: 26
      }));
      __iced_deferrals._fulfill();
    });
  })(this)((function(_this) {
    return function() {
      (function(__iced_k) {
        __iced_deferrals = new iced.Deferrals(__iced_k, {
          filename: "backend/app.coffee"
        });
        loadFilesFromDir('frontend/', '**/*.csv', __iced_deferrals.defer({
          assign_fn: (function() {
            return function() {
              return csvs = arguments[0];
            };
          })(),
          lineno: 27
        }));
        __iced_deferrals._fulfill();
      })(function() {
        func = function(req, res) {
          return res.render("template", {});
        };
        handlebars = exphbs.create({
          defaultLayout: path.join(__dirname, "views/main"),
          helpers: {},
          partialsDir: [path.join(__dirname, 'views/partials/'), path.join(__dirname, 'views/shared/')]
        });
        app.set('env', 'development');
        app.set("port", process.env.PORT || 3001);
        app.set("views", path.join(__dirname, "views"));
        app.engine('handlebars', handlebars.engine);
        app.set('view engine', 'handlebars');
        app.use(express.favicon());
        app.use(express.logger("dev"));
        app.use(express.json());
        app.use(express.urlencoded());
        app.use(express.methodOverride());
        app.use(express.cookieParser());
        app.use(express.session({
          secret: '1234567890QWERTY'
        }));
        app.use(app.router);
        app.use(express["static"](path.join(__dirname, "../public")));
        app.use('/frontend', express["static"](path.join(__dirname, "../frontend")));
        app.use('/views/shared', express["static"](path.join(__dirname, "views/shared")));
        if ("development" === app.get("env")) {
          app.use(express.errorHandler());
        }
        if ("development" === app.get("env")) {
          app.locals.pretty = true;
        }
        app.get("/", func);
        return http.createServer(app).listen(app.get('port'), function() {
          return console.log("Express server listening on port " + app.get('port'));
        });
      });
    };
  })(this));

}).call(this);

/*
//@ sourceMappingURL=app.js.map
*/