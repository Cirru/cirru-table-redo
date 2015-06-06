
suppose (guess 1 2)
define (guess x y)
  bind 10 $ \ (size)
    bind 20 $ \ (weight)
      + (* x size) (* y weight)

define (main)
  print $ guess 1 2
