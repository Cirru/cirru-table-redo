
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
    return $ func scope args
  return $ object (:scope scope) (:value null) (:errored true)

var mapArgs $ \ (scope start args)
  if (is args.size 0) $ do
    return $ object (:scope scope) (:value start) (:errored false)
  var head $ args.first
  var rest $ args.rest
  var result $ readExpr scope head
  var newStart $ start.concat $ array
    start
  return $ mapArgs scope newStart rest

var reduce $ \ (scope state args method)
  var head $ args.first
  if head.errored $ do
    return $ object (:scope scope) (:value null) (:errored true)
  if (is args.size 0)

  var newStart $ method start

= builtins $ object
  :define $ (scope args)
    var value b
    return $ object
      :errored false
      :scope scope.set a b
      :result b

  :add $ \ (scope args)
    var head $ args.first
    var rest $ args.rest

    return $ + a b
