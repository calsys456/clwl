(in-package "WLR")

(define-wlr-events-struct pointer
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
  hold-end)

(define-wlr-struct pointer
  (:base (:struct input-device))
  (:impl :pointer)
  (:output-name :string)
  (:buttons (:array :uint32 16))
  (:button-count :size)
  (:events (:struct pointer-events))
  (:data :pointer))

(define-wlr-struct pointer-motion-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:delta-x :double)
  (:delta-y :double)
  (:unaccel-dx :double)
  (:unaccel-dy :double))

(define-wlr-struct pointer-motion-absolute-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:x :double)
  (:y :double))

(define-wlr-struct pointer-button-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:button :uint32)
  (:state :int))

(define-wlr-struct pointer-axis-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:source :int)
  (:orientation :int)
  (:relative-direction :int)
  (:delta :double)
  (:delta-discrete :int32))

(define-wlr-struct pointer-swipe-begin-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:fingers :uint32))

(define-wlr-struct pointer-swipe-update-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:fingers :uint32)
  (:dx :double)
  (:dy :double))

(define-wlr-struct pointer-swipe-end-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:cancelled :bool))

(define-wlr-struct pointer-pinch-begin-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:fingers :uint32))

(define-wlr-struct pointer-pinch-update-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:fingers :uint32)
  (:dx :double)
  (:dy :double)
  (:scale :double)
  (:rotation :double))

(define-wlr-struct pointer-pinch-end-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:cancelled :bool))

(define-wlr-struct pointer-hold-begin-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:fingers :uint32))

(define-wlr-struct pointer-hold-end-event
  (:pointer (:pointer (:struct pointer)))
  (:time-msec :uint32)
  (:cancelled :bool))

(defcfun ("wlr_pointer_from_input_device" pointer-from-input-device) (:pointer (:struct pointer))
  (input-device (:pointer (:struct input-device))))
(export 'pointer-from-input-device)

(export '(pointer pointer-motion-event pointer-motion-absolute-event pointer-button-event pointer-axis-event pointer-swipe-begin-event pointer-swipe-update-event pointer-swipe-end-event pointer-pinch-begin-event pointer-pinch-update-event pointer-pinch-end-event pointer-hold-begin-event pointer-hold-end-event))
