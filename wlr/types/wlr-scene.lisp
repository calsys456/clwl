(in-package "WLR")

(define-wlr-struct xdg-surface)

(defctype scene-buffer-point-accepts-input-func :pointer)
(defctype scene-buffer-iterator-func :pointer)

(define-wlr-struct damage-ring-private
  (:buffers (:struct wl:list)))

(define-wlr-struct damage-ring
  (:current (:struct wl-util:pixman-region32))
  (:private (:struct damage-ring-private)))

(defcenum scene-node-type
  :tree
  :rect
  :buffer)

(define-wlr-events-struct scene-node destroy)

(define-wlr-struct scene-node
  (:type :int)
  (:parent :pointer)
  (:link (:struct wl:list))
  (:enabled :bool)
  (:x :int)
  (:y :int)
  (:events (:struct scene-node-events))
  (:data :pointer)
  (:addons (:struct addon-set))
  (:private :pointer))

(defcenum scene-debug-damage-option
  :none
  :rerender
  :highlight)

(define-wlr-struct scene-tree
  (:node (:struct scene-node))
  (:children (:struct wl:list)))

(define-wlr-struct scene
  (:tree (:struct scene-tree))
  (:outputs (:struct wl:list))
  (:linux-dmabuf-v1 :pointer)
  (:gamma-control-manager-v1 :pointer)
  (:private :pointer))

(define-wlr-struct scene-surface
  (:buffer :pointer)
  (:surface :pointer)
  (:private :pointer))

(define-wlr-struct scene-rect
  (:node (:struct scene-node))
  (:width :int)
  (:height :int)
  (:color (:array :float 4)))

(define-wlr-struct scene-outputs-update-event
  (:active :pointer)
  (:size :size))

(define-wlr-struct scene-output-sample-event
  (:output :pointer)
  (:direct-scanout :bool))

(export '(damage-ring-private damage-ring scene-outputs-update-event scene-output-sample-event))

(define-wlr-events-struct scene-buffer
  outputs-update
  output-enter
  output-leave
  output-sample
  frame-done)

(define-wlr-struct scene-buffer
  (:node (:struct scene-node))
  (:buffer :pointer)
  (:events (:struct scene-buffer-events))
  (:point-accepts-input scene-buffer-point-accepts-input-func)
  (:primary-output :pointer)
  (:opacity :float)
  (:filter-mode :int)
  (:src-box (:struct fbox))
  (:dst-width :int)
  (:dst-height :int)
  (:transform :int)
  (:opaque-region (:struct wl-util:pixman-region32))
  (:private :pointer))

(define-wlr-events-struct scene-output destroy)

(define-wlr-struct scene-output
  (:output :pointer)
  (:link (:struct wl:list))
  (:scene :pointer)
  (:addon (:struct addon))
  (:damage-ring (:struct damage-ring))
  (:x :int)
  (:y :int)
  (:events (:struct scene-output-events))
  (:private :pointer))

(define-wlr-struct scene-output-layout)

(define-wlr-struct scene-timer
  (:pre-render-duration :int64)
  (:render-timer :pointer))

(define-wlr-struct scene-layer-surface-v1
  (:tree :pointer)
  (:layer-surface :pointer)
  (:private :pointer))

(define-wlr-struct scene-buffer-set-buffer-options
  (:damage (:pointer (:struct wl-util:pixman-region32)))
  (:wait-timeline :pointer)
  (:wait-point :uint64))

(define-wlr-struct scene-output-state-options
  (:timer :pointer)
  (:color-transform :pointer)
  (:swapchain :pointer))

(define-wlr-func scene-node destroy :void)

(define-wlr-func scene-node set-enabled :void
  (enabled :bool))

(define-wlr-func scene-node set-position :void
  (x :int)
  (y :int))

(define-wlr-func scene-node place-above :void
  (sibling :pointer))

(define-wlr-func scene-node place-below :void
  (sibling :pointer))

(define-wlr-func scene-node raise-to-top :void)

(define-wlr-func scene-node lower-to-bottom :void)

(define-wlr-func scene-node reparent :void
  (new-parent :pointer))

(define-wlr-func scene-node coords :bool
  (lx (:pointer :int))
  (ly (:pointer :int)))

(define-wlr-func scene-node for-each-buffer :void
  (iterator scene-buffer-iterator-func)
  (user-data :pointer))

(define-wlr-func scene-node at (:pointer (:struct scene-node))
  (lx :double)
  (ly :double)
  (nx (:pointer :double))
  (ny (:pointer :double)))

(defcfun ("wlr_scene_create" scene-create) (:pointer (:struct scene)))
(export 'scene-create)

(define-wlr-func scene set-linux-dmabuf-v1 :void
  (linux-dmabuf-v1 :pointer))

(define-wlr-func scene set-gamma-control-manager-v1 :void
  (gamma-control :pointer))

(define-wlr-func scene-tree create (:pointer (:struct scene-tree)))

(defcfun ("wlr_scene_surface_create" scene-surface-create) (:pointer (:struct scene-surface))
  (parent (:pointer (:struct scene-tree)))
  (surface (:pointer (:struct surface))))
(export 'scene-surface-create)

(defcfun ("wlr_scene_buffer_from_node" scene-buffer-from-node) (:pointer (:struct scene-buffer))
  (node (:pointer (:struct scene-node))))
(export 'scene-buffer-from-node)

(defcfun ("wlr_scene_tree_from_node" scene-tree-from-node) (:pointer (:struct scene-tree))
  (node (:pointer (:struct scene-node))))
(export 'scene-tree-from-node)

(defcfun ("wlr_scene_rect_from_node" scene-rect-from-node) (:pointer (:struct scene-rect))
  (node (:pointer (:struct scene-node))))
(export 'scene-rect-from-node)

(defcfun ("wlr_scene_surface_try_from_buffer" scene-surface-try-from-buffer) (:pointer (:struct scene-surface))
  (scene-buffer (:pointer (:struct scene-buffer))))
(export 'scene-surface-try-from-buffer)

(defcfun ("wlr_scene_rect_create" scene-rect-create) (:pointer (:struct scene-rect))
  (parent (:pointer (:struct scene-tree)))
  (width :int)
  (height :int)
  (color :pointer))
(export 'scene-rect-create)

(define-wlr-func scene-rect set-size :void
  (width :int)
  (height :int))

(define-wlr-func scene-rect set-color :void
  (color :pointer))

(defcfun ("wlr_scene_buffer_create" scene-buffer-create) (:pointer (:struct scene-buffer))
  (parent (:pointer (:struct scene-tree)))
  (buffer (:pointer (:struct buffer))))
(export 'scene-buffer-create)

(define-wlr-func scene-buffer set-buffer :void
  (buffer (:pointer (:struct buffer))))

(define-wlr-func scene-buffer set-buffer-with-damage :void
  (buffer (:pointer (:struct buffer)))
  (region (:pointer (:struct wl-util:pixman-region32))))

(define-wlr-func scene-buffer set-buffer-with-options :void
  (buffer (:pointer (:struct buffer)))
  (options (:pointer (:struct scene-buffer-set-buffer-options))))

(define-wlr-func scene-buffer set-opaque-region :void
  (region (:pointer (:struct wl-util:pixman-region32))))

(define-wlr-func scene-buffer set-source-box :void
  (box (:pointer (:struct fbox))))

(define-wlr-func scene-buffer set-dest-size :void
  (width :int)
  (height :int))

(define-wlr-func scene-buffer set-transform :void
  (transform :int))

(define-wlr-func scene-buffer set-opacity :void
  (opacity :float))

(define-wlr-func scene-buffer set-filter-mode :void
  (filter-mode :int))

(define-wlr-func scene-buffer send-frame-done :void
  (now (:pointer (:struct timespec))))

(define-wlr-func scene output-create (:pointer (:struct scene-output))
  (output (:pointer (:struct output))))

(define-wlr-func scene-output destroy :void)

(define-wlr-func scene-output set-position :void
  (lx :int)
  (ly :int))

(define-wlr-func scene-output needs-frame :bool)

(define-wlr-func scene-output commit :bool
  (options (:pointer (:struct scene-output-state-options))))

(define-wlr-func scene-output build-state :bool
  (state :pointer)
  (options (:pointer (:struct scene-output-state-options))))

(define-wlr-func scene-timer get-duration-ns :int64)

(define-wlr-func scene-timer finish :void)

(define-wlr-func scene-output send-frame-done :void
  (now (:pointer (:struct timespec))))

(define-wlr-func scene-output for-each-buffer :void
  (iterator scene-buffer-iterator-func)
  (user-data :pointer))

(define-wlr-func scene get-scene-output (:pointer (:struct scene-output))
  (output (:pointer (:struct output))))

(define-wlr-func scene attach-output-layout (:pointer (:struct scene-output-layout))
  (output-layout (:pointer (:struct output-layout))))

(define-wlr-func scene-output-layout add-output :void
  (layout-output (:pointer (:struct output-layout-output)))
  (scene-output (:pointer (:struct scene-output))))

(defcfun ("wlr_scene_subsurface_tree_create" scene-subsurface-tree-create) (:pointer (:struct scene-tree))
  (parent (:pointer (:struct scene-tree)))
  (surface (:pointer (:struct surface))))
(export 'scene-subsurface-tree-create)

(defcfun ("wlr_scene_subsurface_tree_set_clip" scene-subsurface-tree-set-clip) :void
  (node (:pointer (:struct scene-node)))
  (clip (:pointer (:struct box))))
(export 'scene-subsurface-tree-set-clip)

(defcfun ("wlr_scene_xdg_surface_create" scene-xdg-surface-create) (:pointer (:struct scene-tree))
  (parent (:pointer (:struct scene-tree)))
  (xdg-surface (:pointer (:struct xdg-surface))))
(export 'scene-xdg-surface-create)

(defcfun ("wlr_scene_layer_surface_v1_create" scene-layer-surface-v1-create) (:pointer (:struct scene-layer-surface-v1))
  (parent (:pointer (:struct scene-tree)))
  (layer-surface :pointer))
(export 'scene-layer-surface-v1-create)

(define-wlr-func scene-layer-surface-v1 configure :void
  (full-area (:pointer (:struct box)))
  (usable-area (:pointer (:struct box))))

(defcfun ("wlr_scene_drag_icon_create" scene-drag-icon-create) (:pointer (:struct scene-tree))
  (parent (:pointer (:struct scene-tree)))
  (drag-icon (:pointer (:struct drag-icon))))
(export 'scene-drag-icon-create)

(export '(scene scene-node scene-node-type scene-tree scene-surface scene-buffer scene-rect scene-output scene-output-layout scene-layer-surface-v1 scene-buffer-set-buffer-options scene-output-state-options scene-timer))
