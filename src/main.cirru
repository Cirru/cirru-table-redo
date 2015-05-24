
var React $ require :react
var Editor $ React.createFactory $ require :cirru-editor

var
  div $ React.createFactory :div

var Layout $ React.createFactory $ require :./components/layout

React.render (Layout) document.body
