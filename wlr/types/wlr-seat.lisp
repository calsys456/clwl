(in-package "WLR")

(define-wlr-struct serial-range
  (:min-incl :uint32)
  (:max-incl :uint32))

(define-wlr-struct serial-ringset
  (:data (:array (:struct serial-range) 128))
  (:end :int)
  (:count :int))

(define-wlr-struct primary-selection-source)
(define-wlr-struct seat)
(define-wlr-struct data-source)
(define-wlr-struct drag)

(define-wlr-events-struct seat-client destroy)

(define-wlr-struct seat-client-value120
  (:acc-discrete (:array :int32 2))
  (:last-discrete (:array :int32 2))
  (:acc-axis (:array :double 2)))

(define-wlr-struct seat-client
  (:client (:pointer (:struct wl:client)))
  (:seat (:pointer (:struct seat)))
  (:link (:struct wl:list))
  (:resources (:struct wl:list))
  (:pointers (:struct wl:list))
  (:keyboards (:struct wl:list))
  (:touches (:struct wl:list))
  (:data-devices (:struct wl:list))
  (:events (:struct seat-client-events))
  (:serials (:struct serial-ringset))
  (:needs-touch-frame :bool)
  (:value120 (:struct seat-client-value120)))

(define-wlr-events-struct touch-point destroy)

(define-wlr-private-listener touch-point surface-destroy focus-surface-destroy client-destroy)

(define-wlr-struct touch-point
  (:touch-id :int32)
  (:surface (:pointer (:struct surface)))
  (:client (:pointer (:struct seat-client)))
  (:focus-surface (:pointer (:struct surface)))
  (:focus-client (:pointer (:struct seat-client)))
  (:sx :double)
  (:sy :double)
  (:events (:struct touch-point-events))
  (:link (:struct wl:list))
  (:private (:struct touch-point-private)))

(define-wlr-struct pointer-grab-interface
  (:enter :pointer)
  (:clear-focus :pointer)
  (:motion :pointer)
  (:button :pointer)
  (:axis :pointer)
  (:frame :pointer)
  (:cancel :pointer))

(define-wlr-struct keyboard-grab-interface
  (:enter :pointer)
  (:clear-focus :pointer)
  (:key :pointer)
  (:modifiers :pointer)
  (:cancel :pointer))

(define-wlr-struct touch-grab-interface
  (:down :pointer)
  (:up :pointer)
  (:motion :pointer)
  (:enter :pointer)
  (:frame :pointer)
  (:cancel :pointer)
  (:wl-cancel :pointer))

(define-wlr-struct seat-touch-grab
  (:interface (:pointer (:struct touch-grab-interface)))
  (:seat (:pointer (:struct seat)))
  (:data (:pointer :void)))

(define-wlr-struct seat-keyboard-grab
  (:interface (:pointer (:struct keyboard-grab-interface)))
  (:seat (:pointer (:struct seat)))
  (:data (:pointer :void)))

(define-wlr-struct seat-pointer-grab
  (:interface (:pointer (:struct pointer-grab-interface)))
  (:seat (:pointer (:struct seat)))
  (:data (:pointer :void)))

(define-wlr-struct seat-pointer-button
  (:button :uint32)
  (:n-pressed :size))

(define-wlr-events-struct seat-pointer-state focus-change)

(define-wlr-private-listener seat-pointer-state surface-destroy)

(define-wlr-struct seat-pointer-state
  (:seat (:pointer (:struct seat)))
  (:focused-client (:pointer (:struct seat-client)))
  (:focused-surface (:pointer (:struct surface)))
  (:sx :double)
  (:sy :double)
  (:grab (:pointer (:struct seat-pointer-grab)))
  (:default-grab (:pointer (:struct seat-pointer-grab)))
  (:sent-axis-source :bool)
  (:cached-axis-source :int)
  (:buttons (:array (:struct seat-pointer-button) 16))
  (:button-count :size)
  (:grab-button :uint32)
  (:grab-serial :uint32)
  (:grab-time :uint32)
  (:events (:struct seat-pointer-state-events))
  (:private (:struct seat-pointer-state-private)))

(define-wlr-events-struct seat-keyboard-state focus-change)

(define-wlr-private-listener seat-keyboard-state keyboard-destroy keyboard-keymap keyboard-repeat-info surface-destroy)

(define-wlr-struct seat-keyboard-state
  (:seat (:pointer (:struct seat)))
  (:keyboard (:pointer (:struct keyboard)))
  (:focused-client (:pointer (:struct seat-client)))
  (:focused-surface (:pointer (:struct surface)))
  (:grab (:pointer (:struct seat-keyboard-grab)))
  (:default-grab (:pointer (:struct seat-keyboard-grab)))
  (:events (:struct seat-keyboard-state-events))
  (:private (:struct seat-keyboard-state-private)))

(define-wlr-struct seat-touch-state
  (:seat (:pointer (:struct seat)))
  (:touch-points (:struct wl:list))
  (:grab-serial :uint32)
  (:grab-id :uint32)
  (:grab (:pointer (:struct seat-touch-grab)))
  (:default-grab (:pointer (:struct seat-touch-grab))))

(define-wlr-events-struct seat pointer-grab-begin pointer-grab-end keyboard-grab-begin keyboard-grab-end touch-grab-begin touch-grab-end request-set-cursor request-set-selection set-selection request-set-primary-selection set-primary-selection request-start-drag start-drag destroy)

(define-wlr-private-listener seat display-destroy selection-source-destroy primary-selection-source-destroy drag-source-destroy)

(define-wlr-struct seat
  (:global (:pointer (:struct wl:global)))
  (:display (:pointer (:struct wl:display)))
  (:clients (:struct wl:list))
  (:name :string)
  (:capabilities :uint32)
  (:accumulated-capabilities :uint32)
  (:selection-source (:pointer (:struct data-source)))
  (:selection-serial :uint32)
  (:selection-offers (:struct wl:list))
  (:primary-selection-source (:pointer (:struct primary-selection-source)))
  (:primary-selection-serial :uint32)
  (:drag (:pointer (:struct drag)))
  (:drag-source (:pointer (:struct data-source)))
  (:drag-serial :uint32)
  (:drag-offers (:struct wl:list))
  (:pointer-state (:struct seat-pointer-state))
  (:keyboard-state (:struct seat-keyboard-state))
  (:touch-state (:struct seat-touch-state))
  (:events (:struct seat-events))
  (:data (:pointer :void))
  (:private (:struct seat-private)))

(define-wlr-struct seat-pointer-request-set-cursor-event
  (:seat-client (:pointer (:struct seat-client)))
  (:surface (:pointer (:struct surface)))
  (:serial :uint32)
  (:hotspot-x :int32)
  (:hotspot-y :int32))

(define-wlr-struct seat-request-set-selection-event
  (:source (:pointer (:struct data-source)))
  (:serial :uint32))

(define-wlr-struct seat-request-set-primary-selection-event
  (:source (:pointer (:struct primary-selection-source)))
  (:serial :uint32))

(define-wlr-struct seat-request-start-drag-event
  (:drag (:pointer (:struct drag)))
  (:origin (:pointer (:struct surface)))
  (:serial :uint32))

(define-wlr-struct seat-pointer-focus-change-event
  (:seat (:pointer (:struct seat)))
  (:old-surface (:pointer (:struct surface)))
  (:new-surface (:pointer (:struct surface)))
  (:sx :double)
  (:sy :double))

(define-wlr-struct seat-keyboard-focus-change-event
  (:seat (:pointer (:struct seat)))
  (:old-surface (:pointer (:struct surface)))
  (:new-surface (:pointer (:struct surface))))

(export '(serial-range
          serial-ringset
          seat-client-value120
          seat-client
          touch-point
          pointer-grab-interface
          keyboard-grab-interface
          touch-grab-interface
          seat-touch-grab
          seat-keyboard-grab
          seat-pointer-grab
          seat-pointer-button
          seat-pointer-state
          seat-keyboard-state
          seat-touch-state
          seat
          seat-pointer-request-set-cursor-event
          seat-request-set-selection-event
          seat-request-set-primary-selection-event
          seat-request-start-drag-event
          seat-pointer-focus-change-event
          seat-keyboard-focus-change-event))

(defcfun ("wlr_seat_create" seat-create) (:pointer (:struct seat))
  (display (:pointer (:struct wl:display)))
  (name :string))
(export 'seat-create)

(define-wlr-func seat destroy :void)

(define-wlr-func seat client-for-wl-client (:pointer (:struct seat-client))
  (wl-client (:pointer (:struct wl:client))))

(define-wlr-func seat set-capabilities :void
  (capabilities :uint32))

(define-wlr-func seat set-name :void
  (name :string))

(define-wlr-func seat pointer-surface-has-focus :bool
  (surface (:pointer (:struct surface))))

(define-wlr-func seat pointer-enter :void
  (surface (:pointer (:struct surface)))
  (sx :double)
  (sy :double))

(define-wlr-func seat pointer-clear-focus :void)

(define-wlr-func seat pointer-send-motion :void
  (time-msec :uint32)
  (sx :double)
  (sy :double))

(define-wlr-func seat pointer-send-button :uint32
  (time-msec :uint32)
  (button :uint32)
  (state :uint32))

(define-wlr-func seat pointer-send-axis :void
  (time-msec :uint32)
  (orientation :int)
  (value :double)
  (value-discrete :int32)
  (source :int)
  (relative-direction :int))

(define-wlr-func seat pointer-send-frame :void)

(define-wlr-func seat pointer-notify-enter :void
  (surface (:pointer (:struct surface)))
  (sx :double)
  (sy :double))

(define-wlr-func seat pointer-notify-clear-focus :void)

(define-wlr-func seat pointer-warp :void
  (sx :double)
  (sy :double))

(define-wlr-func seat pointer-notify-motion :void
  (time-msec :uint32)
  (sx :double)
  (sy :double))

(define-wlr-func seat pointer-notify-button :uint32
  (time-msec :uint32)
  (button :uint32)
  (state :uint32))

(define-wlr-func seat pointer-notify-axis :void
  (time-msec :uint32)
  (orientation :int)
  (value :double)
  (value-discrete :int32)
  (source :int)
  (relative-direction :int))

(define-wlr-func seat pointer-notify-frame :void)

(define-wlr-func seat pointer-start-grab :void
  (grab (:pointer (:struct seat-pointer-grab))))

(define-wlr-func seat pointer-end-grab :void)

(define-wlr-func seat pointer-has-grab :bool)


(define-wlr-func seat set-keyboard :void
  (keyboard (:pointer (:struct keyboard))))

(define-wlr-func seat get-keyboard (:pointer (:struct keyboard)))

(define-wlr-func seat keyboard-send-key :void
  (time-msec :uint32)
  (key :uint32)
  (state :uint32))

(define-wlr-func seat keyboard-send-modifiers :void
  (modifiers (:pointer (:struct keyboard-modifiers))))

(define-wlr-func seat keyboard-enter :void
  (surface (:pointer (:struct surface)))
  (keycodes (:pointer :uint32))
  (num-keycodes :size)
  (modifiers (:pointer (:struct keyboard-modifiers))))

(define-wlr-func seat keyboard-clear-focus :void)

(define-wlr-func seat keyboard-notify-key :void
  (time-msec :uint32)
  (key :uint32)
  (state :uint32))

(define-wlr-func seat keyboard-notify-modifiers :void
  (modifiers (:pointer (:struct keyboard-modifiers))))

(define-wlr-func seat keyboard-notify-enter :void
  (surface (:pointer (:struct surface)))
  (keycodes (:pointer :uint32))
  (num-keycodes :size)
  (modifiers (:pointer (:struct keyboard-modifiers))))

(define-wlr-func seat keyboard-notify-clear-focus :void)

(define-wlr-func seat keyboard-start-grab :void
  (grab (:pointer (:struct seat-keyboard-grab))))

(define-wlr-func seat keyboard-end-grab :void)

(define-wlr-func seat keyboard-has-grab :bool)

(define-wlr-func seat touch-get-point (:pointer (:struct touch-point))
  (touch-id :int32))

(define-wlr-func seat touch-point-focus :void
  (surface (:pointer (:struct surface)))
  (time-msec :uint32)
  (touch-id :int32)
  (sx :double)
  (sy :double))

(define-wlr-func seat touch-point-clear-focus :void
  (time-msec :uint32)
  (touch-id :int32))

(define-wlr-func seat touch-send-down :uint32
  (surface (:pointer (:struct surface)))
  (time-msec :uint32)
  (touch-id :int32)
  (sx :double)
  (sy :double))

(define-wlr-func seat touch-send-up :uint32
  (time-msec :uint32)
  (touch-id :int32))

(define-wlr-func seat touch-send-motion :void
  (time-msec :uint32)
  (touch-id :int32)
  (sx :double)
  (sy :double))

(define-wlr-func seat touch-send-cancel :void
  (seat-client (:pointer (:struct seat-client))))

(define-wlr-func seat touch-send-frame :void)

(define-wlr-func seat touch-notify-down :uint32
  (surface (:pointer (:struct surface)))
  (time-msec :uint32)
  (touch-id :int32)
  (sx :double)
  (sy :double))

(define-wlr-func seat touch-notify-up :uint32
  (time-msec :uint32)
  (touch-id :int32))

(define-wlr-func seat touch-notify-motion :void
  (time-msec :uint32)
  (touch-id :int32)
  (sx :double)
  (sy :double))

(define-wlr-func seat touch-notify-cancel :void
  (seat-client (:pointer (:struct seat-client))))

(define-wlr-func seat touch-notify-frame :void)

(define-wlr-func seat touch-num-points :int)

(define-wlr-func seat touch-start-grab :void
  (grab (:pointer (:struct seat-touch-grab))))

(define-wlr-func seat touch-end-grab :void)

(define-wlr-func seat touch-has-grab :bool)

(define-wlr-func seat validate-pointer-grab-serial :bool
  (origin (:pointer (:struct seat-pointer-grab)))
  (serial :uint32))

(define-wlr-func seat validate-touch-grab-serial :bool
  (origin (:pointer (:struct seat-touch-grab)))
  (serial :uint32)
  (point-ptr (:pointer (:pointer (:struct touch-point)))))

(define-wlr-func seat-client next-serial :uint32)

(define-wlr-func seat-client validate-event-serial :bool
  (serial :uint32))

(defcfun ("wlr_seat_client_from_resource" seat-client-from-resource) (:pointer (:struct seat-client))
  (resource (:pointer (:struct wl:resource))))
(export 'seat-client-from-resource)

(defcfun ("wlr_seat_client_from_pointer_resource" seat-client-from-pointer-resource) (:pointer (:struct seat-client))
  (resource (:pointer (:struct wl:resource))))
(export 'seat-client-from-pointer-resource)

(define-wlr-func surface accepts-touch :bool
  (seat (:pointer (:struct seat))))
