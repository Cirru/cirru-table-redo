
var
  stir $ require :stir-template
  (object~ html head title meta script body div link) stir

= module.exports $ \ (data)
  return $ stir.render
    stir.doctype
    html null
      head null
        title null ":Cirru Table Redo"
        meta $ object (:charset :utf-8)
        link $ object (:rel :icon) (:href :./images/cirru-32x32.png)
        script $ object (:src data.main) (:defer true)
      body null
