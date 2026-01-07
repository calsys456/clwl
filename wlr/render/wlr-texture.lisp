(in-package "WLR")

(define-wlr-struct buffer)
(define-wlr-struct renderer)

(define-wlr-struct texture
  (:impl :pointer)
  (:width :uint32)
  (:height :uint32)
  (:renderer (:pointer (:struct renderer))))

(define-wlr-struct texture-read-pixels-options
  (:data :pointer)
  (:format :uint32)
  (:stride :uint32)
  (:dst-x :uint32)
  (:dst-y :uint32)
  (:src-box (:struct box)))

(export '(texture texture-read-pixels-options))

(define-wlr-func texture read-pixels :bool
  (options (:pointer (:struct texture-read-pixels-options))))

(define-wlr-func texture preferred-read-format :uint32)

(defcfun ("wlr_texture_from_pixels" texture-from-pixels) (:pointer (:struct texture))
  (renderer (:pointer (:struct renderer)))
  (fmt :uint32)
  (stride :uint32)
  (width :uint32)
  (height :uint32)
  (data :pointer))

(defcfun ("wlr_texture_from_dmabuf" texture-from-dmabuf) (:pointer (:struct texture))
  (renderer (:pointer (:struct renderer)))
  (attributes (:pointer (:struct dmabuf-attributes))))

(export '(texture-from-pixels texture-from-dmabuf))

(define-wlr-func texture update-from-buffer :bool
  (buffer (:pointer (:struct buffer)))
  (damage (:pointer (:struct wl-util:pixman-region32))))

(define-wlr-func texture destroy :void)

(defcfun ("wlr_texture_from_buffer" texture-from-buffer) (:pointer (:struct texture))
  (renderer (:pointer (:struct renderer)))
  (buffer (:pointer (:struct buffer))))

(export 'texture-from-buffer)
