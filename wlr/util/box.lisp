(in-package "WLR")

(define-wlr-struct box
  (:x :int)
  (:y :int)
  (:width :int)
  (:height :int))

(define-wlr-struct fbox
  (:x :double)
  (:y :double)
  (:width :double)
  (:height :double))

(export '(box fbox))

(define-wlr-func box closest-point :void
  (x :double)
  (y :double)
  (dest-x (:pointer :double))
  (dest-y (:pointer :double)))

(define-wlr-func box intersection :bool
  (box-a (:pointer (:struct box)))
  (box-b (:pointer (:struct box))))

(define-wlr-func box contains-point :bool
  (x :double)
  (y :double))

(define-wlr-func box contains-box :bool
  (smaller (:pointer (:struct box))))

(define-wlr-func box empty :bool)

(define-wlr-func box transform :void
  (source-box (:pointer (:struct box)))
  (transform :int) ;; output-transform
  (width :int)
  (height :int))

(define-wlr-func fbox empty :bool)

(define-wlr-func fbox transform :void
  (source-box (:pointer (:struct fbox)))
  (transform :int) ;; output-transform
  (width :double)
  (height :double))

(define-wlr-func box equal :bool
  (another-box (:pointer (:struct box))))

(define-wlr-func fbox equal :bool
  (another-fbox (:pointer (:struct fbox))))
