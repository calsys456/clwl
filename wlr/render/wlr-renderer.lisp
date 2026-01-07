(in-package "WLR")

(define-wlr-events-struct renderer destroy lost)

(define-wlr-struct renderer-features
  (:output-color-transform :bool)
  (:timeline :bool))

(define-wlr-struct renderer-private
  (:impl :pointer))

(define-wlr-struct renderer
  (:render-buffer-caps :uint32)
  (:events (:struct renderer-events))
  (:features (:struct renderer-features))
  (:private (:struct renderer-private)))

(define-wlr-struct render-timer)

(export '(renderer-features renderer-private renderer))

(defcfun ("wlr_renderer_autocreate" renderer-autocreate) (:pointer (:struct renderer))
  (backend (:pointer (:struct backend))))
(export 'renderer-autocreate)

(define-wlr-func renderer get-texture-formats :pointer
  (buffer-caps :uint32))

(define-wlr-func renderer init-wl-display :bool
  (wl-display (:pointer (:struct wl:display))))

(define-wlr-func renderer init-wl-shm :bool
  (wl-display (:pointer (:struct wl:display))))

(define-wlr-func renderer get-drm-fd :int)

(define-wlr-func renderer destroy :void)

(defcfun ("wlr_render_timer_create" render-timer-create) (:pointer (:struct render-timer))
  (renderer (:pointer (:struct renderer))))
(export 'render-timer-create)

(define-wlr-func render-timer get-duration-ns :int)

(define-wlr-func render-timer destroy :void)
