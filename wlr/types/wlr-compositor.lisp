(in-package "WLR")

(defcenum surface-state-field
  (:buffer 1)
  (:surface-damage 2)
  (:buffer-damage 4)
  (:opaque-region 8)
  (:input-region 16)
  (:transform 32)
  (:scale 64)
  (:frame-callback-list 128)
  (:viewport 256)
  (:offset 512))

(define-wlr-struct surface-state-viewport
  (:has-src :bool)
  (:has-dst :bool)
  (:src (:struct fbox))
  (:dst-width :int)
  (:dst-height :int))

(define-wlr-struct surface-state
  (:committed :uint32)
  (:seq :uint32)
  (:buffer :pointer)
  (:dx :int32)
  (:dy :int32)
  (:surface-damage (:struct wl-util:pixman-region32))
  (:buffer-damage (:struct wl-util:pixman-region32))
  (:opaque (:struct wl-util:pixman-region32))
  (:input (:struct wl-util:pixman-region32))
  (:transform :int)
  (:scale :int32)
  (:frame-callback-list (:struct wl:list))
  (:width :int)
  (:height :int)
  (:buffer-width :int)
  (:buffer-height :int)
  (:subsurfaces-below (:struct wl:list))
  (:subsurfaces-above (:struct wl:list))
  (:viewport (:struct surface-state-viewport))
  (:cached-state-locks :size)
  (:cached-state-link (:struct wl:list))
  (:synced (:struct wl:array)))

(define-wlr-struct surface-role
  (:name :string)
  (:no-object :bool)
  (:client-commit :pointer)
  (:commit :pointer)
  (:map :pointer)
  (:unmap :pointer)
  (:destroy :pointer))

(define-wlr-private-listener surface-output bind destroy)

(define-wlr-struct surface-output
  (:surface :pointer)
  (:output :pointer)
  (:link (:struct wl:list))
  (:private (:struct surface-output-private)))

(define-wlr-events-struct surface
  client-commit
  commit
  map
  unmap
  new-subsurface
  destroy)

(define-wlr-struct surface-private-previous
  (:scale :int32)
  (:transform :int)
  (:width :int)
  (:height :int)
  (:buffer-width :int)
  (:buffer-height :int))

(define-wlr-struct surface-private
  (:role-resource-destroy (:struct wl:listener))
  (:previous (:struct surface-private-previous))
  (:unmap-commit :bool)
  (:opaque :bool)
  (:handling-commit :bool)
  (:pending-rejected :bool)
  (:preferred-buffer-scale :int32)
  (:preferred-buffer-transform-sent :bool)
  (:preferred-buffer-transform :int)
  (:synced (:struct wl:list))
  (:synced-len :size)
  (:pending-buffer-resource :pointer)
  (:pending-buffer-resource-destroy (:struct wl:listener)))

(define-wlr-struct surface
  (:resource :pointer)
  (:compositor :pointer)
  (:buffer :pointer)
  (:buffer-damage (:struct wl-util:pixman-region32))
  (:opaque-region (:struct wl-util:pixman-region32))
  (:input-region (:struct wl-util:pixman-region32))
  (:current (:struct surface-state))
  (:pending (:struct surface-state))
  (:cached (:struct wl:list))
  (:mapped :bool)
  (:role :pointer)
  (:role-resource :pointer)
  (:events (:struct surface-events))
  (:current-outputs (:struct wl:list))
  (:addons (:struct addon-set))
  (:data :pointer)
  (:private (:struct surface-private)))

(define-wlr-struct surface-synced-impl
  (:state-size :size)
  (:init-state :pointer)
  (:finish-state :pointer)
  (:move-state :pointer)
  (:commit :pointer))

(define-wlr-struct surface-synced
  (:surface :pointer)
  (:impl :pointer)
  (:link (:struct wl:list))
  (:index :size))

(define-wlr-events-struct compositor
  new-surface
  destroy)

(define-wlr-private-listener compositor display-destroy renderer-destroy)

(define-wlr-struct compositor
  (:global :pointer)
  (:renderer :pointer)
  (:events (:struct compositor-events))
  (:private (:struct compositor-private)))

(export '(surface-state-viewport
          surface-state
          surface-role
          surface-output
          surface-private-previous
          surface-private
          surface
          surface-synced-impl
          surface-synced
          compositor))

(defctype surface-iterator-func :pointer)

(define-wlr-func surface set-role :bool
  (role :pointer)
  (error-resource :pointer)
  (error-code :uint32))

(define-wlr-func surface set-role-object :void
  (role-resource :pointer))

(define-wlr-func surface map :void)

(define-wlr-func surface unmap :void)

(define-wlr-func surface reject-pending :void
  (resource :pointer)
  (code :uint32)
  (msg :string)
  cl:&rest)

(define-wlr-func surface has-buffer :bool)

(define-wlr-func surface-state has-buffer :bool)

(define-wlr-func surface get-texture (:pointer (:struct texture)))

(define-wlr-func surface get-root-surface (:pointer (:struct surface)))

(define-wlr-func surface point-accepts-input :bool
  (sx :double)
  (sy :double))

(define-wlr-func surface surface-at (:pointer (:struct surface))
  (sx :double)
  (sy :double)
  (sub-x (:pointer :double))
  (sub-y (:pointer :double)))

(define-wlr-func surface send-enter :void
  (output (:pointer (:struct output))))

(define-wlr-func surface send-leave :void
  (output (:pointer (:struct output))))

(define-wlr-func surface send-frame-done :void
  (when (:pointer (:struct timespec))))

(define-wlr-func surface get-extents :void
  (box (:pointer (:struct box))))

(define-wlr-func surface from-resource (:pointer (:struct surface))
  (resource (:pointer (:struct wl:resource))))

(define-wlr-func surface for-each-surface :void
  (iterator :pointer)
  (user-data :pointer))

(define-wlr-func surface get-effective-damage :void
  (damage (:pointer (:struct wl-util:pixman-region32))))

(define-wlr-func surface get-buffer-source-box :void
  (box (:pointer (:struct fbox))))

(define-wlr-func surface lock-pending :uint32)

(define-wlr-func surface unlock-cached :void
  (seq :uint32))

(define-wlr-func surface set-preferred-buffer-scale :void
  (scale :int32))

(define-wlr-func surface set-preferred-buffer-transform :void
  (transform :int))

(define-wlr-func surface-synced init :bool
  (surface (:pointer (:struct surface)))
  (impl (:pointer (:struct surface-synced-impl)))
  (pending (:pointer (:struct surface-state)))
  (current (:pointer (:struct surface-state))))

(define-wlr-func surface-synced finish :void)

(define-wlr-func surface-synced get-state (:pointer (:struct surface-state))
  (state (:pointer (:struct surface-state))))

(defcfun ("wlr_region_from_resource" region-from-resource) (:pointer (:struct wl-util:pixman-region32))
  (resource (:pointer (:struct wl:resource))))
(export 'region-from-resource)

(defcfun ("wlr_compositor_create" compositor-create) (:pointer (:struct compositor))
  (display (:pointer (:struct wl:display)))
  (version :uint32)
  (renderer (:pointer (:struct renderer))))
(export 'compositor-create)

(define-wlr-func compositor set-renderer :void
  (renderer (:pointer (:struct renderer))))
