
var
  fs $ require :fs
  webpack $ require :webpack

= module.exports $ object
  :entry $ object
    :main $ array :./src/main
    :vendor $ array
      , :webpack-dev-server/client?http://0.0.0.0:8080
      , :webpack/hot/dev-server
      , :react :keycode :cirru-parser :lodash

  :output $ object
    :path :build/
    :filename :[name].js
    :publicPath :http://localhost:8080/build/

  :resolve $ object
    :extensions $ array :.js :.cirru :

  :module $ object
    :loaders $ array
      object (:test /\.cr$) (:loader :raw-loader)
      object (:test /\.cirru$) (:loader :cirru-script) (:ignore /node_modules)
      object (:test /\.png$) (:loader :url-loader?mimetype=image/png)

  :plugins $ array
    new webpack.optimize.CommonsChunkPlugin :vendor :vendor.js
