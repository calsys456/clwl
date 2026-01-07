(in-package "WLR")

(define-wlr-struct backend-impl
  (:start :pointer)
  (:destroy :pointer)
  (:get-drm-fd :pointer)
  (:test :pointer)
  (:commit :pointer))
(export 'backend-impl)

(define-wlr-func backend init :void
  (impl (:pointer (:struct backend-impl))))

(define-wlr-func backend finish :void)
