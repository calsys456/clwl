(in-package "WLR")

(defcenum keyboard-led
  (:num-lock 1)
  (:caps-lock 2)
  (:scroll-lock 4))

(defcenum keyboard-modifier
  (:shift 1)
  (:caps 2)
  (:ctrl 4)
  (:alt 8)
  (:mod2 16)
  (:mod3 32)
  (:logo 64)
  (:mod5 128))

(define-wlr-struct keyboard-modifiers
  (:depressed :uint32)
  (:latched :uint32)
  (:locked :uint32)
  (:group :uint32))

(define-wlr-events-struct keyboard
  key
  modifiers
  keymap
  repeat-info)

(define-wlr-struct keyboard
  (:base (:struct input-device))
  (:impl :pointer)
  (:group :pointer)
  (:keymap-string :string)
  (:keymap-size :size)
  (:keymap-fd :int)
  (:keymap :pointer)
  (:xkb-state :pointer)
  (:led-indexes (:array :uint32 3))
  (:mod-indexes (:array :uint32 8))
  (:leds :uint32)
  (:keycodes (:array :uint32 32))
  (:num-keycodes :size)
  (:modifiers (:struct keyboard-modifiers))
  (:repeat-info-rate :int32)
  (:repeat-info-delay :int32)
  (:events (:struct keyboard-events))
  (:data :pointer))

(define-wlr-struct keyboard-key-event
  (:time-msec :uint32)
  (:keycode :uint32)
  (:update-state :bool)
  (:state :int))

(defcfun ("wlr_keyboard_from_input_device" keyboard-from-input-device) (:pointer (:struct keyboard))
  (input-device (:pointer (:struct input-device))))
(export 'keyboard-from-input-device)

(define-wlr-func keyboard set-keymap :bool
  (keymap :pointer))

(defcfun ("wlr_keyboard_keymaps_match" keyboard-keymaps-match) :bool
  (first :pointer)
  (second :pointer))
(export 'keyboard-keymaps-match)

(defcfun ("wlr_keyboard_keysym_to_pointer_button" keyboard-keysym-to-pointer-button) :uint32
  (keysym :uint32))
(export 'keyboard-keysym-to-pointer-button)

(defcfun ("wlr_keyboard_keysym_to_pointer_motion" keyboard-keysym-to-pointer-motion) :void
  (keysym :uint32)
  (dx (:pointer :int))
  (dy (:pointer :int)))
(export 'keyboard-keysym-to-pointer-motion)

(define-wlr-func keyboard set-repeat-info :void
  (rate-hz :int32)
  (delay-ms :int32))

(define-wlr-func keyboard led-update :void
  (leds :uint32))

(define-wlr-func keyboard get-modifiers :uint32)

(export '(keyboard-led keyboard-modifier keyboard-modifiers keyboard keyboard-key-event))
