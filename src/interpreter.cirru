
var
  _ $ require :lodash

var readToken $ \ (scope expr)
  var
    firstChar $ expr.substr 0 1
    laterContent $ expr.substr 1
  if (is firstChar ::) $ do $ return laterContent
  if (is expr :true) $ do $ return true
  if (is expr :false) $ do $ return false
  if (expr.match "/-?\\d+(\\.\\d+)?") $ do $ return (Number expr)
  if (firstChar.match /\w) $ do $ return (scope.get expr)
  throw $ new Error $ + ":can not parse " expr

var readExpr $ \ (scope expr)
  if (_.isString expr) $ do
    return $ readToken scope expr

  var
    head $ _.first expr
    args $ _.rest args
    buitlinFunc $ . builtins head
  if (? buitlinFunc) $ do
    return $ buitlinFunc scope args
  var func $ . scope head
  if (? func) $ do
    if (_.isFunction func.value)
      do
        return $ func.value scope args
      do
        throw $ new Error $ + ":can not run expr" (JSON.stringify expr)
  throw $ new Error $ + ":can not run expr" (JSON.stringify expr)

var builtins $ object
  :define $ \ (scope args)
    var callExpr $ _.first args
    var funcName $ _.first callExpr
    var params $ _.rest callExpr
    var expression $ . args 1
    var func $ \ (inScope passedIn)
      var newPairs $ object
      params.forEach $ \ (alias index)
        = (. newPairs alias) (. inScope (. passedIn index))
      var newScope $ _.assign (object) scope newPairs
      return $ readExpr scope statement
    = (. scope funcName) func

  :+ $ \ (scope args)
    return $ ... args
      map $ \ (item) $ return $ readExpr scope item
      reduce $ \ (a b) $ return $ + a b

  :- $ \ (scope args)
    return $ ... args
      map $ \ (item) $ return $ readExpr scope item
      reduce $ \ (a b) $ return $ - a b

  :\ $ \ (scope args)
    var params $ _.first args
    var expression $ . args 1
    return $ \ (inScope (passedIn))
      var newPairs $ object
      params.forEach $ \ (alias index)
        = (. newPairs alias) (. inScope (. passedIn index))
      var newScope $ _.assign (object) scope newPairs
      return $ readExpr newScope expression

  :suppose $ \ (scope args)
    console.log :suppose args

= exports.load $ \ (program)
  var scope $ object
  program.forEach $ \ (line)
    readExpr scope line
  return scope
