(in-package "WLR")

(define-wlr-struct xcursor-manager)
(define-wlr-struct surface)
(define-wlr-struct output-layout)

(define-wlr-events-struct cursor
  motion
  motion-absolute
  button
  axis
  frame
  swipe-begin
  swipe-update
  swipe-end
  pinch-begin
  pinch-update
  pinch-end
  hold-begin
  hold-end

  touch-up
  touch-down
  touch-motion
  touch-cancel
  touch-frame

  tablet-tool-axis
  tablet-tool-proximity
  tablet-tool-tip
  tablet-tool-button)

(define-wlr-struct cursor
  (:state :pointer)
  (:x :double)
  (:y :double)
  (:events (:struct cursor-events))
  (:data :pointer))
(export 'cursor)

(defcfun ("wlr_cursor_create" cursor-create) (:pointer (:struct cursor)))
(export 'cursor-create)

(define-wlr-func cursor destroy :void)

(define-wlr-func cursor warp :bool
  (device (:pointer (:struct input-device)))
  (lx :double)
  (ly :double))

(define-wlr-func cursor absolute-to-layout-coords :void
  (device (:pointer (:struct input-device)))
  (x :double)
  (y :double)
  (lx (:pointer :double))
  (ly (:pointer :double)))

(define-wlr-func cursor warp-closest :void
  (device (:pointer (:struct input-device)))
  (x :double)
  (y :double))

(define-wlr-func cursor warp-absolute :void
  (device (:pointer (:struct input-device)))
  (x :double)
  (y :double))

(define-wlr-func cursor move :void
  (device (:pointer (:struct input-device)))
  (delta-x :double)
  (delta-y :double))

(define-wlr-func cursor set-buffer :void
  (buffer (:pointer (:struct buffer)))
  (hotspot-x :int32)
  (hotspot-y :int32)
  (scale :float))

(define-wlr-func cursor unset-image :void)

(define-wlr-func cursor set-xcursor :void
  (manager (:pointer (:struct xcursor-manager)))
  (name :string))

(define-wlr-func cursor set-surface :void
  (surface (:pointer (:struct surface)))
  (hotspot-x :int32)
  (hotspot-y :int32))

(define-wlr-func cursor attach-input-device :void
  (device (:pointer (:struct input-device))))

(define-wlr-func cursor detach-input-device :void
  (device (:pointer (:struct input-device))))

(define-wlr-func cursor attach-output-layout :void
  (output-layout (:pointer (:struct output-layout))))

(define-wlr-func cursor map-to-output :void
  (output (:pointer (:struct output))))

(define-wlr-func cursor map-input-to-output :void
  (device (:pointer (:struct input-device)))
  (output (:pointer (:struct output))))

(define-wlr-func cursor map-to-region :void
  (box (:pointer (:struct box))))

(define-wlr-func cursor map-input-to-region :void
  (device (:pointer (:struct input-device)))
  (box (:pointer (:struct box))))
