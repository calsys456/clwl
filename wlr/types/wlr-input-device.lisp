(in-package "WLR")

(defcenum button-state
  :released
  :pressed)

(defcenum input-device-type
  :keyboard
  :pointer
  :touch
  :tablet
  :tablet-pad
  :switch)

(define-wlr-events-struct input-device destroy)

(define-wlr-struct input-device
  (:type :int)
  (:name :string)
  (:events (:struct input-device-events))
  (:data :pointer))

(export '(button-state input-device-type input-device))
