
var
  React $ require :react
  keycode $ require :keycode
  parser $ require :cirru-parser
  indent $ require :../util/indent
  demo $ require :../demo.cr
  interpreter $ require :../interpreter

var
  Tree $ React.createFactory $ require :./tree

var
  div $ React.createFactory :div
  textarea $ React.createFactory :textarea

= module.exports $ React.createClass $ object
  :displayName :app-layout

  :getInitialState $ \ ()
    var ast $ parser.pare demo
    = window.scope $ interpreter.load ast
    return $ object
      :code demo
      :ast ast

  :updateAST $ \ ()
    this.setState $ object
      :ast $ parser.pare this.state.code

  :onChange $ \ (event)
    this.setState $ object
      :code event.target.value

  :onKeyDown $ \ (event)
    if
      is (keycode event.keyCode) :enter
      do $ if (or event.metaKey event.ctrlKey)
        do
          this.updateAST
        do
          event.preventDefault
          indent.manualBreaks event.target

  :render $ \ ()
    return $ div
      object (:className :app-layout)
      textarea
        object (:className :text) (:value this.state.code)
          :onChange this.onChange
          :onKeyDown this.onKeyDown
      div (object (:className :monitor))
        Tree $ object (:ast this.state.ast)
