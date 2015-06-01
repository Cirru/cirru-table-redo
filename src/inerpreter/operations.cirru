
var
  type $ require :type
  immutable $ require :immutable

var readToken $ \ (scope errored expr)
  var firstChar $ expr.slice 0 1
  var laterContent $ expr.slice 1
  -- "try string"
  if (is firstChar ::) $ do
    return $ object (:scope scope) (:value laterContent) (:errored false)
  -- "try bool"
  if (is expr :true) $ do
    return $ object (:scope scope) (:value true) (:errored false)
  if (is expr :false) $ do
    return $ object (:scope scope) (:value false) (:errored false)
  if (expr.match "/-?\\d+(\\.\\d+)?") $ do
    return $ object (:scope scope) (:value (Number expr)) (:errored false)
  -- "try alias"
  if (firstChar.match /\w) $ do
    return $ object (:scope scope) (:value (scope.get expr)) (:errored false)
  -- "return error"
  result $ object (:scope scope) (:value null) (:errored true)

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
        return $ object (:scope scope) (:value null) (:errored true)
  return $ object (:scope scope) (:value null) (:errored true)

var mapArgs $ \ (scope start args)
  if (is args.size 0) $ do
    return $ object (:scope scope) (:value start) (:errored false)
  var head $ args.first
  var rest $ args.rest
  var result $ readExpr scope head
  var newStart $ start.concat $ array
    readExpr scope start
  return $ mapArgs scope newStart rest

var reduceArgs $ \ (scope start args method)
  if (is args.size 0) $ do
    return $ object (:scope scope) (:value start) (:errored false)
  var head $ args.first
  if head.errored $ do
    return $ object (:scope scope) (:value null) (:errored true)
  var newStart $ method start head.value
  return $ object (:scope scope) (:value newStart) (:errored false)

= builtins $ object
  :define $ \ (contextScope params)
    var contextArgs $ params.first
    if (not $ ? contextArgs) $ do
      return $ object (:scope scope) (:value null) (:errored false)
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
    return $ reduceArgs scope 0 args $ \ (a b)
      return $ + a b

  :minus $ \ (scope args)
    return $ reduceArgs scope 0 args $ \ (a b)
      return $ - a b
