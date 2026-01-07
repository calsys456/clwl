(in-package "WLR")

(define-wlr-struct dmabuf-attributes
  (:width :int32)
  (:height :int32)
  (:format :uint32)
  (:modifier :uint64)

  (:n-planes :int)
  (:offset :uint32 :count 4)
  (:stride :uint32 :count 4)
  (:fd :int :count 4))

(export 'dmabuf-attributes)

(define-wlr-func dmabuf-attributes finish :void)

(define-wlr-func dmabuf-attributes copy :bool
  (source (:pointer (:struct dmabuf-attributes))))
