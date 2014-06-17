require('source-map-support').install()
express = require("express")
http = require("http")
path = require("path")
util = require('util')
exphbs  = require('express3-handlebars')
_ = require("underscore")
glob = require("glob")
fs = require('fs')

app = express()

loadFilesFromDir = (dir, pattern, completed)->
  here = process.cwd()
  results = {}
  console.log 'loading',pattern,'from',dir
  process.chdir(dir)
  await glob pattern, {}, defer(error, files) 
  throw Error(error) if error
  for file in files
    await fs.readFile file, {encoding: 'utf-8'}, defer(error, data)
    throw Error(error) if error
    results[file] = data
  process.chdir(here)
  completed(results)

await loadFilesFromDir 'backend/views', '**/*.handlebars', defer(templates)
await loadFilesFromDir 'frontend/', '**/*.csv', defer(csvs)

#console.log(templates)

func = (req, res)->
  res.render "template", {

  }

handlebars = exphbs.create({
    defaultLayout: path.join(__dirname, "views/main")
    helpers      : {}
    partialsDir: [
        path.join(__dirname, 'views/partials/'),
        path.join(__dirname, 'views/shared/')
    ]
})

app.set('env','development')

# all environments
app.set "port", process.env.PORT or 3001
app.set "views", path.join(__dirname, "views")
#app.set "view engine", "jade"
app.engine 'handlebars', handlebars.engine
app.set 'view engine', 'handlebars';
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session({secret: '1234567890QWERTY'})
app.use app.router
app.use express.static(path.join(__dirname, "../public"))

# For source maps
app.use '/frontend', express.static(path.join(__dirname, "../frontend"))

app.use '/views/shared', express.static(path.join(__dirname, "views/shared"))

# development only
app.use express.errorHandler() if "development" is app.get("env")
app.locals.pretty = true if "development" is app.get("env")

# routes
app.get "/", func

http.createServer(app).listen app.get('port'), ()->
  console.log "Express server listening on port " + app.get('port')
