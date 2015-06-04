
var
  type $ require :type
  immutable $ require :immutable

var readToken $ \ (scope expr)
  var firstChar $ expr.slice 0 1
  var laterContent $ expr.slice 1
  -- "try string"
  if (is firstChar ::) $ do
    return laterContent
  -- "try bool"
  if (is expr :true) $ do
    return true
  if (is expr :false) $ do
    return false
  if (expr.match "/-?\\d+(\\.\\d+)?") $ do
    return (Number expr)
  -- "try alias"
  if (firstChar.match /\w) $ do
    return (scope.get expr)
  -- "return error"
  throw $ new Error $ + ":can not parse " expr

var readExpr $ \ (scope expr)
  if (is (type expr) :string) $ do
    return $ readToken scope expr

  var head $ expr.first
  var args $ args.rest
  var buitlinFunc $ . builtins head
  if (? buitlinFunc) $ do
    return $ buitlinFunc scope args
  var func $ scope.get head
  if (? func) $ do
    if (is (type func.value) :function)
      do
        return $ func.value scope args
      do
        throw $ new Error $ + ":can not run expr" (JSON.stringify expr)
  throw $ new Error $ + ":can not run expr" (JSON.stringify expr)

= builtins $ object
  :define $ \ (contextScope params)
    var contextArgs $ params.first
    if (not $ ? contextArgs) $ do
      throw $ new Error ":not contextArgs"
    var contextBody $ params.rest
    return $ object (:errored false) (:scope contextScope)
      :value $ \ (scope args)
        contextArgs.forEach $ \ (alias index)
          if (is (type alias) :string)
            do
              = scope $ scope.set alias $ scope.get (args.get index)
        var ret $ object (:scope scope) (:value null) (:errored false)
        contextBody.forEach $ \ (statement index)
          var ret $ readExpr ret.scope statement
          if ret.errored $ do $ return false
        return ret

  :add $ \ (scope args)
    return $ ... args
      map $ \ (item) $ return $ readExpr scope item
      reduce $ \ (a b) $ return $ + a b

  :minus $ \ (scope args)
    return $ ... args
      map $ \ (item) $ return $ readExpr scope item
      reduce $ \ (a b) $ return $ - a b
