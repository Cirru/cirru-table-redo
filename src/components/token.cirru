
var
  React $ require :react

var
  div $ React.createFactory :div

var T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :app-token

  :propTypes $ object
    :token T.string.isRequired
    :value T.any

  :render $ \ ()
    return $ div (object (:className :app-token))
      , this.props.token
      , this.props.value
