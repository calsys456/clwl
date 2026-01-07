(in-package "WLR")

(defcenum output-mode-aspect-ratio
  :none
  :4-3
  :16-9
  :64-27
  :256-135)

(define-wlr-struct output-mode
  (:width :int32)
  (:height :int32)
  (:refresh :int32)
  (:preferred :bool)
  (:picture-aspect-ratio :int)
  (:link (:struct wl:list)))

(define-wlr-private-listener output-cursor renderer-destroy)

(define-wlr-struct output-cursor
  (:output :pointer)
  (:x :double)
  (:y :double)
  (:enabled :bool)
  (:visible :bool)
  (:src-box (:struct fbox))
  (:transform :int)
  (:hotspot-x :int32)
  (:hotspot-y :int32)
  (:texture :pointer)
  (:own-texture :bool)
  (:wait-timeline :pointer)
  (:wait-point :uint64)
  (:link (:struct wl:list))
  (:private (:struct output-cursor-private)))

(defcenum output-adaptive-sync-status
  :enabled
  :disabled)

(defcenum output-state-field
  (:buffer 1)
  (:damage 2)
  (:mode 4)
  (:enabled 8)
  (:scale 16)
  (:transform 32)
  (:adaptive-sync-enabled 64)
  (:gamma-lut 128)
  (:render-format 256)
  (:subpixel 512)
  (:layers 1024)
  (:wait-timeline 2048)
  (:signal-timeline 4096))

(defcenum output-state-mode-type
  :fixed
  :custom)

(define-wlr-struct output-state-custom-mode
  (:width :int32)
  (:height :int32)
  (:refresh :int32))

(define-wlr-struct output-state
  (:committed :uint32)
  (:allow-reconfiguration :bool)
  (:damage (:struct wl-util:pixman-region32))
  (:enabled :bool)
  (:scale :float)
  (:transform :int)
  (:adaptive-sync-enabled :bool)
  (:render-format :uint32)
  (:subpixel :int)

  (:buffer :pointer)
  (:buffer-src-box (:struct fbox))
  (:buffer-dst-box (:struct box))

  (:tearing-page-flip :bool)

  (:mode-type :int)
  (:mode :pointer)
  (:custom-mode (:struct output-state-custom-mode))

  (:gamma-lut :pointer)
  (:gamma-lut-size :unsigned-long-long)

  (:layers :pointer)
  (:layers-len :unsigned-long-long)

  (:wait-timeline :pointer)
  (:wait-point :uint64)
  (:signal-timeline :pointer)
  (:signal-point :uint64))

(define-wlr-events-struct output
  frame
  damage
  needs-frame
  precommit
  commit
  present
  bind
  description
  request-state
  destroy)

(define-wlr-private-listener output display-destroy)

(define-wlr-struct output
  (:impl :pointer)
  (:backend :pointer)
  (:event-loop :pointer)

  (:global :pointer)
  (:resources (:struct wl:list))

  (:name :string)
  (:description :string)
  (:make :string)
  (:model :string)
  (:serial :string)
  (:phys-width :int32)
  (:phys-height :int32)

  (:modes (:struct wl:list))
  (:current-mode :pointer)
  (:width :int32)
  (:height :int32)
  (:refresh :int32)

  (:enabled :bool)
  (:scale :float)
  (:subpixel :int)
  (:transform :int)
  (:adaptive-sync-status :int)
  (:render-format :uint32)

  (:adaptive-sync-supported :bool)

  (:needs-frame :bool)
  (:frame-pending :bool)

  (:non-desktop :bool)

  (:commit-seq :uint32)

  (:events (:struct output-events))

  (:idle-frame :pointer)
  (:idle-done :pointer)

  (:attach-render-locks :int)

  (:cursors (:struct wl:list))
  (:hardware-cursor :pointer)
  (:cursor-swapchain :pointer)
  (:cursor-front-buffer :pointer)
  (:software-cursor-locks :int)

  (:layers (:struct wl:list))

  (:allocator :pointer)
  (:renderer :pointer)
  (:swapchain :pointer)

  (:addons (:struct addon-set))

  (:data :pointer)

  (:private (:struct output-private)))

(define-wlr-struct output-event-damage
  (:output :pointer)
  (:damage :pointer))

(define-wlr-struct output-event-precommit
  (:output :pointer)
  (:timespec :pointer)
  (:state :pointer))

(define-wlr-struct output-event-commit
  (:output :pointer)
  (:timespec :pointer)
  (:state :pointer))

(defcenum output-present-flag
  (:vsync 1)
  (:hw-clock 2)
  (:hw-completion 4)
  (:zero-copy 8))

(define-wlr-struct timespec
  (:tv-sec :long)
  (:tv-nsec :long))

(define-wlr-struct output-event-present
  (:output :pointer)
  (:commit-seq :uint32)
  (:presented :bool)
  (:when (:struct timespec))
  (:seq :unsigned-int)
  (:refresh :int)
  (:flags :uint32))

(define-wlr-struct output-event-bind
  (:output :pointer)
  (:resource :pointer))

(define-wlr-struct output-event-request-state
  (:output :pointer)
  (:state :pointer))

(export '(output-mode
          output-cursor
          output-state-custom-mode
          output-state
          output
          output-event-damage
          output-event-precommit
          output-event-commit
          timespec
          output-event-present
          output-event-bind
          output-event-request-state))


(define-wlr-func output create-global :void
  (display :pointer))

(define-wlr-func output destroy-global :void)

(define-wlr-func output init-render :bool
  (allocator :pointer)
  (renderer :pointer))

(define-wlr-func output preferred-mode (:pointer (:struct output-mode)))

(define-wlr-func output set-name :void
  (name :string))

(define-wlr-func output set-description :void
  (desc :string))

(define-wlr-func output schedule-done :void)

(define-wlr-func output destroy :void)

(define-wlr-func output transformed-resolution :void
  (width (:pointer :int))
  (height (:pointer :int)))

(define-wlr-func output effective-resolution :void
  (width (:pointer :int))
  (height (:pointer :int)))

(define-wlr-func output test-state :bool
  (state (:pointer (:struct output-state))))

(define-wlr-func output commit-state :bool
  (state (:pointer (:struct output-state))))

(define-wlr-func output schedule-frame :void)

(define-wlr-func output get-gamma-size :unsigned-long-long)

(defcfun ("wlr_output_from_resource" output-from-resource) (:pointer (:struct output))
  (resource (:pointer (:struct wl:resource))))
(export 'output-from-resource)

(define-wlr-func output lock-attach-render :void
  (lock :bool))

(define-wlr-func output lock-software-cursors :void
  (lock :bool))

(define-wlr-func output add-software-cursors-to-render-pass :void
  (render-pass (:pointer (:struct render-pass)))
  (damage (:pointer (:struct wl-util:pixman-region32))))

(define-wlr-func output get-primary-formats :pointer
  (buffer-caps :uint32))

(define-wlr-func output is-direct-scanout-allowed :bool)


(define-wlr-func output cursor-create (:pointer (:struct output-cursor)))

(define-wlr-func output-cursor set-buffer :bool
  (buffer (:pointer (:struct buffer)))
  (hotspot-x :int32)
  (hotspot-y :int32))

(define-wlr-func output-cursor move :bool
  (x :double)
  (y :double))

(define-wlr-func output-cursor destroy :void)

(define-wlr-func output-state init :void)

(define-wlr-func output-state finish :void)

(define-wlr-func output-state set-enabled :void
  (enabled :bool))

(define-wlr-func output-state set-mode :void
  (mode (:pointer (:struct output-mode))))

(define-wlr-func output-state set-custom-mode :void
  (width :int32)
  (height :int32)
  (refresh :int32))

(define-wlr-func output-state set-scale :void
  (scale :float))

(define-wlr-func output-state set-transform :void
  (transform :int))

(define-wlr-func output-state set-adaptive-sync-enabled :void
  (enabled :bool))

(define-wlr-func output-state set-render-format :void
  (format :uint32))

(define-wlr-func output-state set-subpixel :void
  (subpixel :int))

(define-wlr-func output-state set-buffer :void
  (buffer :pointer))

(define-wlr-func output-state set-gamma-lut :bool
  (ramp-size :unsigned-long-long)
  (r :uint16)
  (g :uint16)
  (b :uint16))

(define-wlr-func output-state set-damage :void
  (damage :pointer))

(define-wlr-func output-state set-layers :void
  (layers :pointer)
  (layers-len :unsigned-long-long))

(define-wlr-func output-state set-wait-timeline :void
  (timeline :pointer)
  (src-point :uint64))

(define-wlr-func output-state set-signal-timeline :void
  (timeline :pointer)
  (dst-point :uint64))

(define-wlr-func output-state copy :bool
  (src :pointer))


(define-wlr-func output configure-primary-swapchain :bool
  (state :pointer)
  (swapchain :pointer))

(define-wlr-func output begin-render-pass (:pointer (:struct render-pass))
  (state (:pointer (:struct output-state)))
  (render-options (:pointer (:struct buffer-pass-options))))
