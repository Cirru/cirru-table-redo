
var
  React $ require :react
  Expr $ React.createFactory $ require :./expr

var
  div $ React.createFactory :div

var T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :app-tree

  :propTypes $ object
    :ast T.node.isRequired

  :render $ \ ()
    return $ div (object (:className :app-tree))
      this.props.ast.map $ \\ (node index)
        return $ Expr (object (:expr node) (:key index))
