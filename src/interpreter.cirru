
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
  if (firstChar.match /\w) $ do $ return (. scope expr)
  throw $ new Error $ + ":can not parse " expr

var readExpr $ \ (scope expr)
  if (_.isString expr) $ do
    var result $ readToken scope expr
    return result

  var
    head $ _.first expr
    args $ _.rest expr

  var buitlinFunc $ . builtins head
  if (? buitlinFunc) $ do
    return $ buitlinFunc scope args

  var params $ args.map $ \ (item)
    return $ readExpr scope item
  var func $ . scope head
  if (? func) $ do
    return $ func params

  throw $ new Error $ + ":can not run expr" (JSON.stringify expr)

var builtins $ object
  :define $ \ (scope args)
    var callExpr $ _.first args
    var funcName $ _.first callExpr
    var params $ _.rest callExpr
    var expression $ . args 1
    var func $ \ (passedIn)
      var newPairs $ object
      params.forEach $ \ (alias index)
        = (. newPairs alias) (. passedIn index)
      var newScope $ _.assign (object) scope newPairs
      return $ readExpr newScope expression
    = (. scope funcName) func

  :+ $ \ (scope args)
    return $ ... args
      map $ \ (item) $ return $ readExpr scope item
      reduce $ \ (a b) $ return $ + a b

  :- $ \ (scope args)
    return $ ... args
      map $ \ (item) $ return $ readExpr scope item
      reduce $ \ (a b) $ return $ - a b

  :* $ \ (scope args)
    return $ ... args
      map $ \ (item) $ return $ readExpr scope item
      reduce $ \ (a b) $ return $ * a b

  :print $ \ (scope args)
    var results $ args.map $ \ (expr)
      return $ readExpr scope expr
    console.log (... results)
    return undefined

  :\ $ \ (scope args)
    var params $ _.first args
    var expression $ . args 1
    return $ \ ((passedIn))
      var newPairs $ object
      params.forEach $ \ (alias index)
        = (. newPairs alias) (. passedIn index)
      var newScope $ _.assign (object) scope newPairs
      return $ readExpr newScope expression

  :suppose $ \ (scope args)
    console.log :suppose args

  :bind $ \ (scope args)
    var value $ readExpr scope (_.first args)
    var func $ readExpr scope (. args 1)
    return $ func value

= exports.load $ \ (program)
  var scope $ object
  program.forEach $ \ (line)
    readExpr scope line
  return scope

= exports.builtins builtins
