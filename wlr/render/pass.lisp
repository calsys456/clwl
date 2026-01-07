(in-package "WLR")

(define-wlr-struct buffer)
(define-wlr-struct texture)
(define-wlr-struct renderer)
(define-wlr-struct render-pass)
(define-wlr-struct render-timer)

(define-wlr-struct buffer-pass-options
  (:timer (:pointer (:struct render-timer)))
  (:color-transform :pointer)
  (:signal-timeline :pointer)
  (:signal-point :uint64))

(define-wlr-func renderer begin-buffer-pass (:pointer (:struct render-pass))
  (buffer (:pointer (:struct buffer)))
  (options (:pointer (:struct buffer-pass-options))))

(define-wlr-func render-pass submit :bool)

(defcenum render-blend-mode
  :premultiplied
  :none)

(defcenum scale-filter-mode
  :bilinear
  :nearest)

(define-wlr-struct renderer-texture-options
  (:texture (:pointer (:struct texture)))
  (:src-box (:struct fbox))
  (:dst-box (:struct box))
  (:alpha :float)
  (:clip (:pointer (:struct wl-util:pixman-region32)))
  (:transform :int)
  (:filter-mode :int)
  (:blend-mode :int)
  (:wait-timeline :pointer)
  (:wait-point :uint64))

(define-wlr-func render-pass add-texture :void
  (options (:pointer (:struct renderer-texture-options))))

(define-wlr-struct render-color
  (:r :float)
  (:g :float)
  (:b :float)
  (:a :float))

(define-wlr-struct render-rect-options
  (:box (:struct box))
  (:color (:struct render-color))
  (:clip (:pointer (:struct wl-util:pixman-region32)))
  (:blend-mode :int))

(export '(buffer-pass-options renderer-texture-options render-color render-rect-options))

(define-wlr-func render-pass add-rect :void
  (options (:pointer (:struct render-rect-options))))
