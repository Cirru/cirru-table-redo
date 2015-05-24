
var
  React $ require :react
  type $ require :component-type

var
  div $ React.createFactory :div

var T React.PropTypes

var Expr $ React.createClass $ object
  :displayName :app-expr

  :propTypes $ object
    :expr T.array.isRequired

  :render $ \ ()
    return $ div (object (:className :app-expr))
      this.props.expr.map $ \\ (node)
        return $ cond
          is (type node) :array
          React.createElement Expr $ object (:expr node)
          React.createElement Token $ object (:token node)

var Token $ React.createClass $ object
  :displayName :app-token

  :propTypes $ object
    :token T.string.isRequired

  :render $ \ ()
    return $ div (object (:className :app-token))
      , this.props.token

= module.exports $ React.createClass $ object
  :displayName :app-tree

  :propTypes $ object
    :ast T.node.isRequired

  :render $ \ ()
    return $ div (object (:className :app-tree))
      this.props.ast.map $ \\ (node)
        return $ React.createElement Expr (object (:expr node))
