(in-package "WLR")

(define-wlr-struct data-source)
(define-wlr-struct drag)

(define-wlr-events-struct data-device-manager destroy)

(define-wlr-private-listener data-device-manager display-destroy)

(define-wlr-struct data-device-manager
  (:global :pointer)
  (:data-sources (:struct wl:list))
  (:events (:struct data-device-manager-events))
  (:data :pointer)
  (:private (:struct data-device-manager-private)))

(defcenum data-offer-type
  :selection
  :drag)

(define-wlr-private-listener data-offer source-destroy)

(define-wlr-struct data-offer
  (:resource (:pointer (:struct wl:resource)))
  (:source (:pointer (:struct data-source)))
  (:type :int)
  (:link (:struct wl:list))
  (:actions :uint32)
  (:preferred-action :int)
  (:in-ask :bool)
  (:private (:struct data-offer-private)))

(define-wlr-struct data-source-impl
  (:send :pointer)
  (:accept :pointer)
  (:destroy :pointer)
  (:dnd-drop :pointer)
  (:dnd-finish :pointer)
  (:dnd-action :pointer))

(define-wlr-events-struct data-source destroy)

(define-wlr-struct data-source
  (:impl (:pointer (:struct data-source-impl)))
  (:mime-types (:struct wl:array))
  (:actions :int32)
  (:accepted :bool)
  (:current-dnd-action :int)
  (:compositor-action :uint32)
  (:events (:struct data-source-events)))

(define-wlr-events-struct drag-icon destroy)

(define-wlr-private-listener drag-icon surface-destroy)

(define-wlr-struct drag-icon
  (:drag (:pointer (:struct drag)))
  (:surface (:pointer (:struct surface)))
  (:events (:struct drag-icon-events))
  (:data :pointer)
  (:private (:struct drag-icon-private)))

(defcenum drag-grab-type
  :keyboard
  :keyboard-pointer
  :keyboard-touch)

(define-wlr-events-struct drag
  focus
  motion
  drop
  destroy)

(define-wlr-private-listener drag source-destroy seat-client-destroy focus-destroy icon-destroy)

(define-wlr-struct drag
  (:grab-type :int)
  (:keyboard-grab (:struct seat-keyboard-grab))
  (:pointer-grab (:struct seat-pointer-grab))
  (:touch-grab (:struct seat-touch-grab))
  (:seat (:pointer (:struct seat)))
  (:seat-client (:pointer (:struct seat-client)))
  (:focus-client (:pointer (:struct seat-client)))
  (:icon (:pointer (:struct drag-icon)))
  (:focus (:pointer (:struct surface)))
  (:source (:pointer (:struct data-source)))
  (:started :bool)
  (:dropped :bool)
  (:cancelling :bool)
  (:grab-touch-id :int32)
  (:touch-id :int32)
  (:events (:struct drag-events))
  (:data :pointer)
  (:private (:struct drag-private)))

(define-wlr-struct drag-motion-event
  (:drag (:pointer (:struct drag)))
  (:time :uint32)
  (:sx :double)
  (:sy :double))

(define-wlr-struct drag-drop-event
  (:drag (:pointer (:struct drag)))
  (:time :uint32))

(export '(data-device-manager
          data-offer
          data-source-impl
          data-source
          drag-icon
          drag
          drag-motion-event
          drag-drop-event))

(defcfun ("wlr_data_device_manager_create" data-device-manager-create) (:pointer (:struct data-device-manager))
  (display (:pointer (:struct wl:display))))
(export 'data-device-manager-create)

(define-wlr-func seat request-set-selection :void
  (seat-client (:pointer (:struct seat-client)))
  (source (:pointer (:struct data-source)))
  (serial :uint32))

(define-wlr-func seat set-selection :void
  (source (:pointer (:struct data-source)))
  (serial :uint32))

(defcfun ("wlr_drag_create" drag-create) (:pointer (:struct drag))
  (seat-client (:pointer (:struct seat-client)))
  (source (:pointer (:struct data-source)))
  (icon-surface (:pointer (:struct surface))))
(export 'drag-create)

(define-wlr-func seat request-start-drag :void
  (drag (:pointer (:struct drag)))
  (origin (:pointer (:struct surface)))
  (serial :uint32))

(define-wlr-func seat start-drag :void
  (drag (:pointer (:struct drag)))
  (serial :uint32))

(define-wlr-func seat start-pointer-drag :void
  (drag (:pointer (:struct drag)))
  (serial :uint32))

(define-wlr-func seat start-touch-drag :void
  (drag (:pointer (:struct drag)))
  (serial :uint32)
  (point (:pointer (:struct touch-point))))

(define-wlr-func data-source init :void
  (impl (:pointer (:struct data-source-impl))))

(define-wlr-func data-source send :void
  (mime-type :string)
  (fd :int32))

(define-wlr-func data-source accept :void
  (serial :uint32)
  (mime-type :string))

(define-wlr-func data-source destroy :void)

(define-wlr-func data-source dnd-drop :void)

(define-wlr-func data-source dnd-finish :void)

(define-wlr-func data-source dnd-action :void
  (action :int))
