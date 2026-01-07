(in-package "WLR")

(define-wlr-events-struct xdg-shell
  new-surface
  new-toplevel
  new-popup
  destroy)

(define-wlr-private-listener xdg-shell display-destroy)

(define-wlr-struct xdg-shell
  (:global (:pointer (:struct wl:global)))
  (:version :uint32)
  (:clients (:struct wl:list))
  (:popup-grabs (:struct wl:list))
  (:ping-timeout :uint32)
  (:events (:struct xdg-shell-events))
  (:data (:pointer :void))
  (:private (:struct xdg-shell-private)))

(define-wlr-struct xdg-client
  (:shell (:pointer (:struct xdg-shell)))
  (:resource (:pointer (:struct wl:resource)))
  (:client (:pointer (:struct wl:client)))
  (:surfaces (:struct wl:list))
  (:link (:struct wl:list))
  (:ping-serial :uint32)
  (:ping-timer (:pointer (:struct wl:event-source))))

(define-wlr-struct xdg-positioner-size
  (:width :int32)
  (:height :int32))

(define-wlr-struct xdg-positioner-offset
  (:x :int32)
  (:y :int32))

(define-wlr-struct xdg-positioner-rules
  (:anchor-rect (:struct box))
  (:anchor :int)
  (:gravity :int)
  (:constraint-adjustment :int)
  (:reactive :bool)
  (:has-parent-configure-serial :bool)
  (:parent-configure-serial :uint32)
  (:size (:struct xdg-positioner-size))
  (:parent-size (:struct xdg-positioner-size))
  (:offset (:struct xdg-positioner-offset)))

(define-wlr-struct xdg-positioner
  (:resource (:pointer (:struct wl:resource)))
  (:rules (:struct xdg-positioner-rules)))

(define-wlr-struct xdg-popup-state
  (:geometry (:struct box))
  (:reactive :bool))

(defcenum xdg-popup-configure-field
  (:reposition-token 1))

(define-wlr-struct xdg-popup-configure
  (:fields :uint32)
  (:geometry (:struct box))
  (:rules (:struct xdg-positioner-rules))
  (:reposition-token :uint32))

(define-wlr-events-struct xdg-popup
  destroy
  reposition)

(define-wlr-struct xdg-popup-private
  (:synced (:struct surface-synced)))

(define-wlr-struct xdg-popup
  (:base (:pointer (:struct xdg-surface)))
  (:link (:struct wl:list))
  (:resource (:pointer (:struct wl:resource)))
  (:parent (:pointer (:struct surface)))
  (:seat (:pointer (:struct seat)))
  (:scheduled (:struct xdg-popup-configure))
  (:current (:struct xdg-popup-state))
  (:pending (:struct xdg-popup-state))
  (:events (:struct xdg-popup-events))
  (:grab-link (:struct wl:list))
  (:private (:struct xdg-popup-private)))

(define-wlr-private-listener xdg-popup-grab seat-destroy)

(define-wlr-struct xdg-popup-grab
  (:client (:pointer (:struct wl:client)))
  (:pointer-grab (:struct seat-pointer-grab))
  (:keyboard-grab (:struct seat-keyboard-grab))
  (:touch-grab (:struct seat-touch-grab))
  (:seat (:pointer (:struct seat)))
  (:popups (:struct wl:list))
  (:link (:struct wl:list))
  (:private (:struct xdg-popup-grab-private)))

(defcenum xdg-surface-role
  :none
  :toplevel
  :popup)

(define-wlr-struct xdg-toplevel-state
  (:maximized :bool)
  (:fullscreen :bool)
  (:resizing :bool)
  (:activated :bool)
  (:suspended :bool)
  (:tiled :uint32)
  (:width :int32)
  (:height :int32)
  (:max-width :int32)
  (:max-height :int32)
  (:min-width :int32)
  (:min-height :int32))

(defcenum xdg-toplevel-wm-capabilities
  (:window-menu 1)
  (:maximize 2)
  (:fullscreen 4)
  (:minimize 8))

(defcenum xdg-toplevel-configure-field
  (:bounds 1)
  (:wm-capabilities 2))

(define-wlr-struct xdg-toplevel-bounds
  (:width :int32)
  (:height :int32))

(define-wlr-struct xdg-toplevel-configure
  (:fields :uint32)
  (:maximized :bool)
  (:fullscreen :bool)
  (:resizing :bool)
  (:activated :bool)
  (:suspended :bool)
  (:tiled :uint32)
  (:width :int32)
  (:height :int32)
  (:bounds (:struct xdg-toplevel-bounds))
  (:wm-capabilities :uint32))

(define-wlr-private-listener xdg-toplevel-requested fullscreen-output-destroy)

(define-wlr-struct xdg-toplevel-requested
  (:maximized :bool)
  (:minimized :bool)
  (:fullscreen :bool)
  (:fullscreen-output (:pointer (:struct output)))
  (:private (:struct xdg-toplevel-requested-private)))

(define-wlr-events-struct xdg-toplevel
  destroy
  request-maximize
  request-fullscreen
  request-minimize
  request-move
  request-resize
  request-show-window-menu
  set-parent
  set-title
  set-app-id)

(define-wlr-struct xdg-toplevel-private
  (:synced (:struct surface-synced))
  (:parent-unmap (:struct wl:listener)))

(define-wlr-struct xdg-toplevel
  (:resource (:pointer (:struct wl:resource)))
  (:base (:pointer (:struct xdg-surface)))
  (:parent (:pointer (:struct xdg-toplevel)))
  (:current (:struct xdg-toplevel-state))
  (:pending (:struct xdg-toplevel-state))
  (:scheduled (:struct xdg-toplevel-configure))
  (:requested (:struct xdg-toplevel-requested))
  (:title :string)
  (:app-id :string)
  (:events (:struct xdg-toplevel-events))
  (:private (:struct xdg-toplevel-private)))

(define-wlr-struct xdg-surface-configure
  (:surface (:pointer (:struct xdg-surface)))
  (:link (:struct wl:list))
  (:serial :uint32)
  (:toplevel-configure (:pointer (:struct xdg-toplevel-configure)))
  (:popup-configure (:pointer (:struct xdg-popup-configure))))

(defcenum xdg-surface-state-field
  (:window-geometry 1))

(define-wlr-struct xdg-surface-state
  (:committed :uint32)
  (:geometry (:struct box))
  (:configure-serial :uint32))

(define-wlr-events-struct xdg-surface
  destroy
  ping-timeout
  new-popup
  configure
  ack-configure)

(define-wlr-struct xdg-surface-private
  (:synced (:struct surface-synced))
  (:role-resource-destroy (:struct wl:listener)))

(define-wlr-struct xdg-surface
  (:client (:pointer (:struct xdg-client)))
  (:resource (:pointer (:struct wl:resource)))
  (:surface (:pointer (:struct surface)))
  (:link (:struct wl:list))
  (:role :int)
  (:role-resource (:pointer (:struct wl:resource)))
  (:toplevel (:pointer (:struct xdg-toplevel)))
  (:popup (:pointer (:struct xdg-popup)))
  (:popups (:struct wl:list))
  (:configured :bool)
  (:configure-idle (:pointer (:struct wl:event-source)))
  (:scheduled-serial :uint32)
  (:configure-list (:struct wl:list))
  (:current (:struct xdg-surface-state))
  (:pending (:struct xdg-surface-state))
  (:initialized :bool)
  (:initial-commit :bool)
  (:geometry (:struct box))
  (:events (:struct xdg-surface-events))
  (:data (:pointer :void))
  (:private (:struct xdg-surface-private)))

(define-wlr-struct xdg-toplevel-move-event
  (:toplevel (:pointer (:struct xdg-toplevel)))
  (:seat (:pointer (:struct seat-client)))
  (:serial :uint32))

(define-wlr-struct xdg-toplevel-resize-event
  (:toplevel (:pointer (:struct xdg-toplevel)))
  (:seat (:pointer (:struct seat-client)))
  (:serial :uint32)
  (:edges :uint32))

(define-wlr-struct xdg-toplevel-show-window-menu-event
  (:toplevel (:pointer (:struct xdg-toplevel)))
  (:seat (:pointer (:struct seat-client)))
  (:serial :uint32)
  (:x :int32)
  (:y :int32))

(defcfun ("wlr_xdg_shell_create" xdg-shell-create) (:pointer (:struct xdg-shell))
  (display (:pointer (:struct wl:display)))
  (version :uint32))
(export 'xdg-shell-create)

(defcfun ("wlr_xdg_surface_from_resource" xdg-surface-from-resource) (:pointer (:struct xdg-surface))
  (resource (:pointer (:struct wl:resource))))
(export 'xdg-surface-from-resource)

(defcfun ("wlr_xdg_popup_from_resource" xdg-popup-from-resource) (:pointer (:struct xdg-popup))
  (resource (:pointer (:struct wl:resource))))
(export 'xdg-popup-from-resource)

(defcfun ("wlr_xdg_toplevel_from_resource" xdg-toplevel-from-resource) (:pointer (:struct xdg-toplevel))
  (resource (:pointer (:struct wl:resource))))
(export 'xdg-toplevel-from-resource)

(defcfun ("wlr_xdg_positioner_from_resource" xdg-positioner-from-resource) (:pointer (:struct xdg-positioner))
  (resource (:pointer (:struct wl:resource))))
(export 'xdg-positioner-from-resource)

(define-wlr-func xdg-surface ping :void)

(define-wlr-func xdg-toplevel configure :uint32
  (configure (:pointer (:struct xdg-toplevel-configure))))

(define-wlr-func xdg-toplevel set-size :uint32
  (width :int32)
  (height :int32))

(define-wlr-func xdg-toplevel set-activated :uint32
  (activated :bool))

(define-wlr-func xdg-toplevel set-maximized :uint32
  (maximized :bool))

(define-wlr-func xdg-toplevel set-fullscreen :uint32
  (fullscreen :bool))

(define-wlr-func xdg-toplevel set-resizing :uint32
  (resizing :bool))

(define-wlr-func xdg-toplevel set-tiled :uint32
  (tiled-edges :uint32))

(define-wlr-func xdg-toplevel set-bounds :uint32
  (width :int32)
  (height :int32))

(define-wlr-func xdg-toplevel set-wm-capabilities :uint32
  (caps :uint32))

(define-wlr-func xdg-toplevel set-suspended :uint32
  (suspended :bool))

(define-wlr-func xdg-toplevel send-close :void)

(define-wlr-func xdg-toplevel set-parent :bool
  (parent (:pointer (:struct xdg-toplevel))))

(define-wlr-func xdg-popup destroy :void)

(define-wlr-func xdg-popup get-position :void
  (popup-sx (:pointer :double))
  (popup-sy (:pointer :double)))

(define-wlr-func xdg-positioner is-complete :bool)

(define-wlr-func xdg-positioner-rules get-geometry :void
  (box (:pointer (:struct box))))

(define-wlr-func xdg-positioner-rules unconstrain-box :void
  (constraint (:pointer (:struct box)))
  (box (:pointer (:struct box))))

(define-wlr-func xdg-popup get-toplevel-coords :void
  (popup-sx :int)
  (popup-sy :int)
  (toplevel-sx (:pointer :int))
  (toplevel-sy (:pointer :int)))

(define-wlr-func xdg-popup unconstrain-from-box :void
  (toplevel-space-box (:pointer (:struct box))))

(define-wlr-func xdg-surface surface-at (:pointer (:struct surface))
  (sx :double)
  (sy :double)
  (sub-x (:pointer :double))
  (sub-y (:pointer :double)))

(define-wlr-func xdg-surface popup-surface-at (:pointer (:struct surface))
  (sx :double)
  (sy :double)
  (sub-x (:pointer :double))
  (sub-y (:pointer :double)))

(defcfun ("wlr_xdg_surface_try_from_wlr_surface" xdg-surface-try-from-wlr-surface) (:pointer (:struct xdg-surface))
  (surface (:pointer (:struct surface))))
(export 'xdg-surface-try-from-wlr-surface)

(defcfun ("wlr_xdg_toplevel_try_from_wlr_surface" xdg-toplevel-try-from-wlr-surface) (:pointer (:struct xdg-toplevel))
  (surface (:pointer (:struct surface))))
(export 'xdg-toplevel-try-from-wlr-surface)

(defcfun ("wlr_xdg_popup_try_from_wlr_surface" xdg-popup-try-from-wlr-surface) (:pointer (:struct xdg-popup))
  (surface (:pointer (:struct surface))))
(export 'xdg-popup-try-from-wlr-surface)

(define-wlr-func xdg-surface for-each-surface :void
  (iterator surface-iterator-func)
  (user-data (:pointer :void)))

(define-wlr-func xdg-surface for-each-popup-surface :void
  (iterator surface-iterator-func)
  (user-data (:pointer :void)))

(define-wlr-func xdg-surface schedule-configure :uint32)

(export '(xdg-shell
          xdg-client
          xdg-positioner-rules
          xdg-positioner
          xdg-positioner-size
          xdg-positioner-offset
          xdg-popup
          xdg-popup-state
          xdg-popup-private
          xdg-popup-grab
          xdg-surface
          xdg-surface-private
          xdg-surface-configure
          xdg-surface-state
          xdg-toplevel
          xdg-toplevel-state
          xdg-toplevel-configure
          xdg-toplevel-bounds
          xdg-toplevel-requested
          xdg-toplevel-private
          xdg-toplevel-move-event
          xdg-toplevel-resize-event
          xdg-toplevel-show-window-menu-event
          xdg-popup-configure))
