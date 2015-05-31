
var
  React $ require :react
  type $ require :component-type
  Token $ React.createFactory $ require :./token

var
  div $ React.createFactory :div

var T React.PropTypes

var Expr $ React.createClass $ object
  :displayName :app-expr

  :propTypes $ object
    :expr T.array.isRequired

  :render $ \ ()
    return $ div (object (:className :app-expr))
      this.props.expr.map $ \\ (node index)
        return $ cond
          is (type node) :array
          React.createElement Expr $ object (:expr node)
            :key index
          Token $ object (:token node) (:key index)

= module.exports Expr
