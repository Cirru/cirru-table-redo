
var React $ require :react
var Editor $ React.createFactory $ require :cirru-editor

var div $ React.createFactory :div

var App $ React.createClass $ object
  :displayName :app

  :render $ \ ()
    return $ div (object (:className :app)) :nothing


React.render (React.createElement App) document.body
