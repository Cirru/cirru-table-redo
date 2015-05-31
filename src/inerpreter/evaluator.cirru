
var
  operations $ require :./operations
  immutable $ require :immutable

= exports.run $ \ (ast)
  var scope $ immutable.Map

