
= exports.define $ \ (scope args)
  return $ scope.set a b

= exports.__call__ $ \ (scope name (... args))
  var func $ scope.get name
  return $ func (... args)

= exports.add $ \ (scope a b)
  return $ + a b
