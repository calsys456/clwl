(cl:in-package "WL")

(define-wl-interface display)
(define-wl-interface registry)
(define-wl-interface callback)
(define-wl-interface compositor)
(define-wl-interface shm-pool)
(define-wl-interface shm)
(define-wl-interface buffer)
(define-wl-interface data-offer)
(define-wl-interface data-source)
(define-wl-interface data-device)
(define-wl-interface data-device-manager)
(define-wl-interface shell)
(define-wl-interface shell-surface)
(define-wl-interface surface)
(define-wl-interface seat)
(define-wl-interface pointer)
(define-wl-interface keyboard)
(define-wl-interface touch)
(define-wl-interface output)
(define-wl-interface region)
(define-wl-interface subcompositor)
(define-wl-interface subsurface)

(define-wl-struct display-interface
  (:sync :pointer)
  (:get-registry :pointer))

(define-wl-struct registry-interface
  (:bind :pointer))

(define-wl-struct compositor-interface
  (:create-surface :pointer)
  (:create-region :pointer))

(define-wl-struct shm-pool-interface
  (:create-buffer :pointer)
  (:destroy :pointer)
  (:resize :pointer))

(define-wl-struct shm-interface
  (:create-pool :pointer)
  (:release :pointer))

(define-wl-struct buffer-interface
  (:destroy :pointer))

(define-wl-struct data-offer-interface
  (:accept :pointer)
  (:receive :pointer)
  (:destroy :pointer)
  (:finish :pointer)
  (:set-actions :pointer))

(define-wl-struct data-source-interface
  (:offer :pointer)
  (:destroy :pointer)
  (:set-actions :pointer))

(define-wl-struct data-device-interface
  (:start-drag :pointer)
  (:set-selection :pointer)
  (:release :pointer))

(define-wl-struct data-device-manager-interface
  (:create-data-source :pointer)
  (:get-data-device :pointer))

(define-wl-struct shell-interface
  (:get-shell-surface :pointer))

(define-wl-struct shell-surface-interface
  (:pong :pointer)
  (:move :pointer)
  (:resize :pointer)
  (:set-toplevel :pointer)
  (:set-transient :pointer)
  (:set-fullscreen :pointer)
  (:set-popup :pointer)
  (:set-maximized :pointer)
  (:set-title :pointer)
  (:set-class :pointer))

(define-wl-struct surface-interface
  (:destroy :pointer)
  (:attach :pointer)
  (:damage :pointer)
  (:frame :pointer)
  (:set-opaque-region :pointer)
  (:set-input-region :pointer)
  (:commit :pointer)
  (:set-buffer-transform :pointer)
  (:set-buffer-scale :pointer)
  (:damage-buffer :pointer)
  (:offset :pointer))

(define-wl-struct seat-interface
  (:get-pointer :pointer)
  (:get-keyboard :pointer)
  (:get-touch :pointer)
  (:release :pointer))

(define-wl-struct pointer-interface
  (:set-cursor :pointer)
  (:release :pointer))

(define-wl-struct keyboard-interface
  (:release :pointer))

(define-wl-struct touch-interface
  (:release :pointer))

(define-wl-struct output-interface
  (:release :pointer))

(define-wl-struct region-interface
  (:destroy :pointer)
  (:add :pointer)
  (:subtract :pointer))

(define-wl-struct subcompositor-interface
  (:destroy :pointer)
  (:get-subsurface :pointer))

(define-wl-struct subsurface-interface
  (:destroy :pointer)
  (:set-position :pointer)
  (:place-above :pointer)
  (:place-below :pointer)
  (:set-sync :pointer)
  (:set-desync :pointer))

(defcenum display-error
  (:invalid-object 0)
  (:invalid-method 1)
  (:no-memory 2)
  (:implementation 3))

(defcenum shm-error
  (:invalid-format 0)
  (:invalid-stride 1)
  (:invalid-fd 2))

(defcenum shm-format
  (:argb8888 0)
  (:xrgb8888 1)
  (:c8 #x20203843)
  (:rgb332 #x38424752)
  (:bgr233 #x38524742)
  (:xrgb4444 #x32315258)
  (:xbgr4444 #x32314258)
  (:rgbx4444 #x32315852)
  (:bgrx4444 #x32315842)
  (:argb4444 #x32315241)
  (:abgr4444 #x32314241)
  (:rgba4444 #x32314152)
  (:bgra4444 #x32314142)
  (:xrgb1555 #x35315258)
  (:xbgr1555 #x35314258)
  (:rgbx5551 #x35315852)
  (:bgrx5551 #x35315842)
  (:argb1555 #x35315241)
  (:abgr1555 #x35314241)
  (:rgba5551 #x35314152)
  (:bgra5551 #x35314142)
  (:rgb565 #x36314752)
  (:bgr565 #x36314742)
  (:rgb888 #x34324752)
  (:bgr888 #x34324742)
  (:xbgr8888 #x34324258)
  (:rgbx8888 #x34325852)
  (:bgrx8888 #x34325842)
  (:abgr8888 #x34324241)
  (:rgba8888 #x34324152)
  (:bgra8888 #x34324142)
  (:xrgb2101010 #x30335258)
  (:xbgr2101010 #x30334258)
  (:rgbx1010102 #x30335852)
  (:bgrx1010102 #x30335842)
  (:argb2101010 #x30335241)
  (:abgr2101010 #x30334241)
  (:rgba1010102 #x30334152)
  (:bgra1010102 #x30334142)
  (:yuyv #x56595559)
  (:yvyu #x55595659)
  (:uyvy #x59565955)
  (:vyuy #x59555956)
  (:ayuv #x56555941)
  (:nv12 #x3231564e)
  (:nv21 #x3132564e)
  (:nv16 #x3631564e)
  (:nv61 #x3136564e)
  (:yuv410 #x39565559)
  (:yvu410 #x39555659)
  (:yuv411 #x31315559)
  (:yvu411 #x31315659)
  (:yuv420 #x32315559)
  (:yvu420 #x32315659)
  (:yuv422 #x36315559)
  (:yvu422 #x36315659)
  (:yuv444 #x34325559)
  (:yvu444 #x34325659)
  (:r8 #x20203852)
  (:r16 #x20363152)
  (:rg88 #x38384752)
  (:gr88 #x38385247)
  (:rg1616 #x32334752)
  (:gr1616 #x32335247)
  (:xrgb16161616f #x48345258)
  (:xbgr16161616f #x48344258)
  (:argb16161616f #x48345241)
  (:abgr16161616f #x48344241)
  (:xyuv8888 #x56555958)
  (:vuy888 #x34325556)
  (:vuy101010 #x30335556)
  (:y210 #x30313259)
  (:y212 #x32313259)
  (:y216 #x36313259)
  (:y410 #x30313459)
  (:y412 #x32313459)
  (:y416 #x36313459)
  (:xvyu2101010 #x30335658)
  (:xvyu12-16161616 #x36335658)
  (:xvyu16161616 #x38345658)
  (:y0l0 #x304c3059)
  (:x0l0 #x304c3058)
  (:y0l2 #x324c3059)
  (:x0l2 #x324c3058)
  (:yuv420-8bit #x38305559)
  (:yuv420-10bit #x30315559)
  (:xrgb8888-a8 #x38415258)
  (:xbgr8888-a8 #x38414258)
  (:rgbx8888-a8 #x38415852)
  (:bgrx8888-a8 #x38415842)
  (:rgb888-a8 #x38413852)
  (:bgr888-a8 #x38413842)
  (:rgb565-a8 #x38413552)
  (:bgr565-a8 #x38413542)
  (:nv24 #x3432564e)
  (:nv42 #x3234564e)
  (:p210 #x30313250)
  (:p010 #x30313050)
  (:p012 #x32313050)
  (:p016 #x36313050)
  (:axbxgxrx106106106106 #x30314241)
  (:nv15 #x3531564e)
  (:q410 #x30313451)
  (:q401 #x31303451)
  (:xrgb16161616 #x38345258)
  (:xbgr16161616 #x38344258)
  (:argb16161616 #x38345241)
  (:abgr16161616 #x38344241)
  (:c1 #x20203143)
  (:c2 #x20203243)
  (:c4 #x20203443)
  (:d1 #x20203144)
  (:d2 #x20203244)
  (:d4 #x20203444)
  (:d8 #x20203844)
  (:r1 #x20203152)
  (:r2 #x20203252)
  (:r4 #x20203452)
  (:r10 #x20303152)
  (:r12 #x20323152)
  (:avuy8888 #x59555641)
  (:xvuy8888 #x59555658)
  (:p030 #x30333050))

(defcenum data-offer-error
  (:invalid-finish 0)
  (:invalid-action-mask 1)
  (:invalid-action 2)
  (:invalid-offer 3))

(defcenum data-source-error
  (:invalid-action-mask 0)
  (:invalid-source 1))

(defcenum data-device-error
  (:role 0)
  (:used-source 1))

(defcenum data-device-manager-dnd-action
  (:none 0)
  (:copy 1)
  (:move 2)
  (:ask 4))

(defcenum shell-error
  (:role 0))

(defcenum shell-surface-resize
  (:none 0)
  (:top 1)
  (:bottom 2)
  (:left 4)
  (:top-left 5)
  (:bottom-left 6)
  (:right 8)
  (:top-right 9)
  (:bottom-right 10))

(defcenum shell-surface-transient
  (:inactive #x1))

(defcenum shell-surface-fullscreen-method
  (:default 0)
  (:scale 1)
  (:driver 2)
  (:fill 3))

(defcenum surface-error
  (:invalid-scale 0)
  (:invalid-transform 1)
  (:invalid-size 2)
  (:invalid-offset 3)
  (:defunct-role-object 4))

(defcenum seat-capability
  (:pointer 1)
  (:keyboard 2)
  (:touch 4))

(defcenum seat-error
  (:missing-capability 0))

(defcenum pointer-error
  (:role 0))

(defcenum pointer-button-state
  (:released 0)
  (:pressed 1))

(defcenum pointer-axis
  (:vertical-scroll 0)
  (:horizontal-scroll 1))

(defcenum pointer-axis-source
  (:wheel 0)
  (:finger 1)
  (:continuous 2)
  (:wheel-tilt 3))

(defcenum pointer-axis-relative-direction
  (:identical 0)
  (:inverted 1))

(defcenum keyboard-keymap-format
  (:no-keymap 0)
  (:xkb-v1 1))

(defcenum keyboard-key-state
  (:released 0)
  (:pressed 1))

(defcenum output-subpixel
  (:unknown 0)
  (:none 1)
  (:horizontal-rgb 2)
  (:horizontal-bgr 3)
  (:vertical-rgb 4)
  (:vertical-bgr 5))

(defcenum output-transform
  (:normal 0)
  (:rotate-90 1)
  (:rotate-180 2)
  (:rotate-270 3)
  (:flipped 4)
  (:flipped-rotate-90 5)
  (:flipped-rotate-180 6)
  (:flipped-rotate-270 7))

(defcenum output-mode
  (:current #x1)
  (:preferred #x2))

(defcenum subcompositor-error
  (:bad-surface 0)
  (:bad-parent 1))

(defcenum subsurface-error
  (:bad-surface 0))

(cl:defun %enum-value (enum value)
  (cl:cond
    ((cl:integerp value) value)
    ((cl:keywordp value)
     (cl:ignore-errors (foreign-enum-value enum value)))
    (cl:t cl:nil)))

(cl:defun display-error-is-valid (value version)
  (cl:let ((code (%enum-value 'display-error value)))
    (cl:when code
      (cl:case code
        ((0 1 2 3) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun shm-error-is-valid (value version)
  (cl:let ((code (%enum-value 'shm-error value)))
    (cl:when code
      (cl:case code
        ((0 1 2) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun shm-format-is-valid (value version)
  (cl:let ((code (%enum-value 'shm-format value)))
    (cl:when code
      (cl:case code
        ((0 1
          #x20203843 #x38424752 #x38524742 #x32315258 #x32314258 #x32315852 #x32315842 #x32315241 #x32314241
          #x32314152 #x32314142 #x35315258 #x35314258 #x35315852 #x35315842 #x35315241 #x35314241 #x35314152
          #x35314142 #x36314752 #x36314742 #x34324752 #x34324742 #x34324258 #x34325852 #x34325842 #x34324241
          #x34324152 #x34324142 #x30335258 #x30334258 #x30335852 #x30335842 #x30335241 #x30334241 #x30334152
          #x30334142 #x56595559 #x55595659 #x59565955 #x59555956 #x56555941 #x3231564E #x3132564E #x3631564E
          #x3136564E #x39565559 #x39555659 #x31315559 #x31315659 #x32315559 #x32315659 #x36315559 #x36315659
          #x34325559 #x34325659 #x20203852 #x20363152 #x38384752 #x38385247 #x32334752 #x32335247 #x48345258
          #x48344258 #x48345241 #x48344241 #x56555958 #x34325556 #x30335556 #x30313259 #x32313259 #x36313259
          #x30313459 #x32313459 #x36313459 #x30335658 #x36335658 #x38345658 #x304C3059 #x304C3058 #x324C3059
          #x324C3058 #x38305559 #x30315559 #x38415258 #x38414258 #x38415852 #x38415842 #x38413852 #x38413842
          #x38413552 #x38413542 #x3432564E #x3234564E #x30313250 #x30313050 #x32313050 #x36313050 #x30314241
          #x3531564E #x30313451 #x31303451 #x38345258 #x38344258 #x38345241 #x38344241 #x20203143 #x20203243
          #x20203443 #x20203144 #x20203244 #x20203444 #x20203844 #x20203152 #x20203252 #x20203452 #x20303152
          #x20323152 #x59555641 #x59555658 #x30333050)
         (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun data-offer-error-is-valid (value version)
  (cl:let ((code (%enum-value 'data-offer-error value)))
    (cl:when code
      (cl:case code
        ((0 1 2 3) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun data-source-error-is-valid (value version)
  (cl:let ((code (%enum-value 'data-source-error value)))
    (cl:when code
      (cl:case code
        ((0 1) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun data-device-error-is-valid (value version)
  (cl:let ((code (%enum-value 'data-device-error value)))
    (cl:when code
      (cl:case code
        ((0 1) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun data-device-manager-dnd-action-is-valid (value version)
  (cl:let ((code (%enum-value 'data-device-manager-dnd-action value)))
    (cl:when code
      (cl:let ((valid 0))
        (cl:when (cl:>= version 1)
          (cl:setf valid (cl:logior valid 1)
                valid (cl:logior valid 2)
                valid (cl:logior valid 4)))
        (cl:if (cl:< version 1)
            (cl:zerop code)
            (cl:case code
              ((0 1 2 4) (cl:>= version 1))
              (cl:otherwise (cl:zerop (cl:logandc2 code valid)))))))))

(cl:defun shell-error-is-valid (value version)
  (cl:let ((code (%enum-value 'shell-error value)))
    (cl:when code
      (cl:case code
        (0 (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun shell-surface-resize-is-valid (value version)
  (cl:let ((code (%enum-value 'shell-surface-resize value)))
    (cl:when code
      (cl:let ((valid 0))
        (cl:when (cl:>= version 1)
          (cl:setf valid (cl:logior valid 1)
                valid (cl:logior valid 2)
                valid (cl:logior valid 4)
                valid (cl:logior valid 5)
                valid (cl:logior valid 6)
                valid (cl:logior valid 8)
                valid (cl:logior valid 9)
                valid (cl:logior valid 10)))
        (cl:if (cl:< version 1)
            (cl:zerop code)
            (cl:case code
              ((0 1 2 4 5 6 8 9 10) (cl:>= version 1))
              (cl:otherwise (cl:zerop (cl:logandc2 code valid)))))))))

(cl:defun shell-surface-transient-is-valid (value version)
  (cl:let ((code (%enum-value 'shell-surface-transient value)))
    (cl:when code
      (cl:let ((valid 0))
        (cl:when (cl:>= version 1)
          (cl:setf valid (cl:logior valid #x1)))
        (cl:if (cl:< version 1)
            (cl:zerop code)
            (cl:case code
              (#x1 (cl:>= version 1))
              (cl:otherwise (cl:zerop (cl:logandc2 code valid)))))))))

(cl:defun shell-surface-fullscreen-method-is-valid (value version)
  (cl:let ((code (%enum-value 'shell-surface-fullscreen-method value)))
    (cl:when code
      (cl:case code
        ((0 1 2 3) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun surface-error-is-valid (value version)
  (cl:let ((code (%enum-value 'surface-error value)))
    (cl:when code
      (cl:case code
        ((0 1 2 3 4) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun seat-capability-is-valid (value version)
  (cl:let ((code (%enum-value 'seat-capability value)))
    (cl:when code
      (cl:let ((valid 0))
        (cl:when (cl:>= version 1)
          (cl:setf valid (cl:logior valid 1)
                valid (cl:logior valid 2)
                valid (cl:logior valid 4)))
        (cl:if (cl:< version 1)
            (cl:zerop code)
            (cl:case code
              ((1 2 4) (cl:>= version 1))
              (cl:otherwise (cl:zerop (cl:logandc2 code valid)))))))))

(cl:defun seat-error-is-valid (value version)
  (cl:let ((code (%enum-value 'seat-error value)))
    (cl:when code
      (cl:case code
        (0 (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun pointer-error-is-valid (value version)
  (cl:let ((code (%enum-value 'pointer-error value)))
    (cl:when code
      (cl:case code
        (0 (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun pointer-button-state-is-valid (value version)
  (cl:let ((code (%enum-value 'pointer-button-state value)))
    (cl:when code
      (cl:case code
        ((0 1) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun pointer-axis-is-valid (value version)
  (cl:let ((code (%enum-value 'pointer-axis value)))
    (cl:when code
      (cl:case code
        ((0 1) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun pointer-axis-source-is-valid (value version)
  (cl:let ((code (%enum-value 'pointer-axis-source value)))
    (cl:when code
      (cl:case code
        ((0 1 2) (cl:>= version 1))
        (3 (cl:>= version 6))
        (cl:otherwise cl:nil)))))

(cl:defun pointer-axis-relative-direction-is-valid (value version)
  (cl:let ((code (%enum-value 'pointer-axis-relative-direction value)))
    (cl:when code
      (cl:case code
        ((0 1) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun keyboard-keymap-format-is-valid (value version)
  (cl:let ((code (%enum-value 'keyboard-keymap-format value)))
    (cl:when code
      (cl:case code
        ((0 1) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun keyboard-key-state-is-valid (value version)
  (cl:let ((code (%enum-value 'keyboard-key-state value)))
    (cl:when code
      (cl:case code
        ((0 1) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun output-subpixel-is-valid (value version)
  (cl:let ((code (%enum-value 'output-subpixel value)))
    (cl:when code
      (cl:case code
        ((0 1 2 3 4 5) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun output-transform-is-valid (value version)
  (cl:let ((code (%enum-value 'output-transform value)))
    (cl:when code
      (cl:case code
        ((0 1 2 3 4 5 6 7) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun output-mode-is-valid (value version)
  (cl:let ((code (%enum-value 'output-mode value)))
    (cl:when code
      (cl:let ((valid 0))
        (cl:when (cl:>= version 1)
          (cl:setf valid (cl:logior valid #x1)
                valid (cl:logior valid #x2)))
        (cl:if (cl:< version 1)
            (cl:zerop code)
            (cl:case code
              ((#x1 #x2) (cl:>= version 1))
              (cl:otherwise (cl:zerop (cl:logandc2 code valid)))))))))

(cl:defun subcompositor-error-is-valid (value version)
  (cl:let ((code (%enum-value 'subcompositor-error value)))
    (cl:when code
      (cl:case code
        ((0 1) (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defun subsurface-error-is-valid (value version)
  (cl:let ((code (%enum-value 'subsurface-error value)))
    (cl:when code
      (cl:case code
        (0 (cl:>= version 1))
        (cl:otherwise cl:nil)))))

(cl:defvar *registry-global* 0)
(cl:defun registry-send-global (resource name interface version)
  (resource-post-event resource *registry-global*
                       :uint32 name
                       :string interface
                       :uint32 version))

(cl:defvar *registry-global-remove* 1)
(cl:defun registry-send-global-remove (resource name)
  (resource-post-event resource *registry-global-remove*
                       :uint32 name))

(cl:defvar *callback-done* 0)
(cl:defun callback-send-done (resource callback-data)
  (resource-post-event resource *callback-done*
                       :uint32 callback-data))

(cl:defvar *shm-format* 0)
(cl:defun shm-send-format (resource format)
  (resource-post-event resource *shm-format*
                       :uint32 format))

(cl:defvar *buffer-release* 0)
(cl:defun buffer-send-release (resource)
  (resource-post-event resource *buffer-release*))

(cl:defvar *data-offer-offer* 0)
(cl:defun data-offer-send-offer (resource mime-type)
  (resource-post-event resource *data-offer-offer*
                       :string mime-type))

(cl:defvar *data-offer-source-actions* 1)
(cl:defun data-offer-send-source-actions (resource source-actions)
  (resource-post-event resource *data-offer-source-actions*
                       :uint32 source-actions))

(cl:defvar *data-offer-action* 2)
(cl:defun data-offer-send-action (resource dnd-action)
  (resource-post-event resource *data-offer-action*
                       :uint32 dnd-action))

(cl:defvar *data-source-target* 0)
(cl:defun data-source-send-target (resource mime-type)
  (resource-post-event resource *data-source-target*
                       :string mime-type))

(cl:defvar *data-source-send* 1)
(cl:defun data-source-send-send (resource mime-type fd)
  (resource-post-event resource *data-source-send*
                       :string mime-type
                       :int32 fd))

(cl:defvar *data-source-cancelled* 2)
(cl:defun data-source-send-cancelled (resource)
  (resource-post-event resource *data-source-cancelled*))

(cl:defvar *data-source-dnd-drop-performed* 3)
(cl:defun data-source-send-dnd-drop-performed (resource)
  (resource-post-event resource *data-source-dnd-drop-performed*))

(cl:defvar *data-source-dnd-finished* 4)
(cl:defun data-source-send-dnd-finished (resource)
  (resource-post-event resource *data-source-dnd-finished*))

(cl:defvar *data-source-action* 5)
(cl:defun data-source-send-action (resource dnd-action)
  (resource-post-event resource *data-source-action*
                       :uint32 dnd-action))

(cl:defvar *data-device-data-offer* 0)
(cl:defun data-device-send-data-offer (resource id)
  (resource-post-event resource *data-device-data-offer*
                       :pointer (cl:or id (null-pointer))))

(cl:defvar *data-device-enter* 1)
(cl:defun data-device-send-enter (resource serial surface x y id)
  (resource-post-event resource *data-device-enter*
                       :uint32 serial
                       :pointer (cl:or surface (null-pointer))
                       :int32 x
                       :int32 y
                       :pointer (cl:or id (null-pointer))))

(cl:defvar *data-device-leave* 2)
(cl:defun data-device-send-leave (resource)
  (resource-post-event resource *data-device-leave*))

(cl:defvar *data-device-motion* 3)
(cl:defun data-device-send-motion (resource time x y)
  (resource-post-event resource *data-device-motion*
                       :uint32 time
                       :int32 x
                       :int32 y))

(cl:defvar *data-device-drop* 4)
(cl:defun data-device-send-drop (resource)
  (resource-post-event resource *data-device-drop*))

(cl:defvar *data-device-selection* 5)
(cl:defun data-device-send-selection (resource id)
  (resource-post-event resource *data-device-selection*
                       :pointer (cl:or id (null-pointer))))

(cl:defvar *shell-surface-ping* 0)
(cl:defun shell-surface-send-ping (resource serial)
  (resource-post-event resource *shell-surface-ping*
                       :uint32 serial))

(cl:defvar *shell-surface-configure* 1)
(cl:defun shell-surface-send-configure (resource edges width height)
  (resource-post-event resource *shell-surface-configure*
                       :uint32 edges
                       :int32 width
                       :int32 height))

(cl:defvar *shell-surface-popup-done* 2)
(cl:defun shell-surface-send-popup-done (resource)
  (resource-post-event resource *shell-surface-popup-done*))

(cl:defvar *surface-enter* 0)
(cl:defun surface-send-enter (resource output)
  (resource-post-event resource *surface-enter*
                       :pointer (cl:or output (null-pointer))))

(cl:defvar *surface-leave* 1)
(cl:defun surface-send-leave (resource output)
  (resource-post-event resource *surface-leave*
                       :pointer (cl:or output (null-pointer))))

(cl:defvar *surface-preferred-buffer-scale* 2)
(cl:defun surface-send-preferred-buffer-scale (resource factor)
  (resource-post-event resource *surface-preferred-buffer-scale*
                       :int32 factor))

(cl:defvar *surface-preferred-buffer-transform* 3)
(cl:defun surface-send-preferred-buffer-transform (resource transform)
  (resource-post-event resource *surface-preferred-buffer-transform*
                       :uint32 transform))

(cl:defvar *seat-capabilities* 0)
(cl:defun seat-send-capabilities (resource capabilities)
  (resource-post-event resource *seat-capabilities*
                       :uint32 capabilities))

(cl:defvar *seat-name* 1)
(cl:defun seat-send-name (resource name)
  (resource-post-event resource *seat-name*
                       :string name))

(cl:defvar *pointer-enter* 0)
(cl:defun pointer-send-enter (resource serial surface surface-x surface-y)
  (resource-post-event resource *pointer-enter*
                       :uint32 serial
                       :pointer (cl:or surface (null-pointer))
                       :int32 surface-x
                       :int32 surface-y))

(cl:defvar *pointer-leave* 1)
(cl:defun pointer-send-leave (resource serial surface)
  (resource-post-event resource *pointer-leave*
                       :uint32 serial
                       :pointer (cl:or surface (null-pointer))))

(cl:defvar *pointer-motion* 2)
(cl:defun pointer-send-motion (resource time surface-x surface-y)
  (resource-post-event resource *pointer-motion*
                       :uint32 time
                       :int32 surface-x
                       :int32 surface-y))

(cl:defvar *pointer-button* 3)
(cl:defun pointer-send-button (resource serial time button state)
  (resource-post-event resource *pointer-button*
                       :uint32 serial
                       :uint32 time
                       :uint32 button
                       :uint32 state))

(cl:defvar *pointer-axis* 4)
(cl:defun pointer-send-axis (resource time axis value)
  (resource-post-event resource *pointer-axis*
                       :uint32 time
                       :uint32 axis
                       :int32 value))

(cl:defvar *pointer-frame* 5)
(cl:defun pointer-send-frame (resource)
  (resource-post-event resource *pointer-frame*))

(cl:defvar *pointer-axis-source* 6)
(cl:defun pointer-send-axis-source (resource axis-source)
  (resource-post-event resource *pointer-axis-source*
                       :uint32 axis-source))

(cl:defvar *pointer-axis-stop* 7)
(cl:defun pointer-send-axis-stop (resource time axis)
  (resource-post-event resource *pointer-axis-stop*
                       :uint32 time
                       :uint32 axis))

(cl:defvar *pointer-axis-discrete* 8)
(cl:defun pointer-send-axis-discrete (resource axis discrete)
  (resource-post-event resource *pointer-axis-discrete*
                       :uint32 axis
                       :int32 discrete))

(cl:defvar *pointer-axis-value120* 9)
(cl:defun pointer-send-axis-value120 (resource axis value120)
  (resource-post-event resource *pointer-axis-value120*
                       :uint32 axis
                       :int32 value120))

(cl:defvar *pointer-axis-relative-direction* 10)
(cl:defun pointer-send-axis-relative-direction (resource axis direction)
  (resource-post-event resource *pointer-axis-relative-direction*
                       :uint32 axis
                       :uint32 direction))

(cl:defvar *keyboard-keymap* 0)
(cl:defun keyboard-send-keymap (resource format fd size)
  (resource-post-event resource *keyboard-keymap*
                       :uint32 format
                       :int32 fd
                       :uint32 size))

(cl:defvar *keyboard-enter* 1)
(cl:defun keyboard-send-enter (resource serial surface keys)
  (resource-post-event resource *keyboard-enter*
                       :uint32 serial
                       :pointer (cl:or surface (null-pointer))
                       :pointer (cl:or keys (null-pointer))))

(cl:defvar *keyboard-leave* 2)
(cl:defun keyboard-send-leave (resource serial surface)
  (resource-post-event resource *keyboard-leave*
                       :uint32 serial
                       :pointer (cl:or surface (null-pointer))))

(cl:defvar *keyboard-key* 3)
(cl:defun keyboard-send-key (resource serial time key state)
  (resource-post-event resource *keyboard-key*
                       :uint32 serial
                       :uint32 time
                       :uint32 key
                       :uint32 state))

(cl:defvar *keyboard-modifiers* 4)
(cl:defun keyboard-send-modifiers (resource serial mods-depressed mods-latched mods-locked group)
  (resource-post-event resource *keyboard-modifiers*
                       :uint32 serial
                       :uint32 mods-depressed
                       :uint32 mods-latched
                       :uint32 mods-locked
                       :uint32 group))

(cl:defvar *keyboard-repeat-info* 5)
(cl:defun keyboard-send-repeat-info (resource rate delay)
  (resource-post-event resource *keyboard-repeat-info*
                       :int32 rate
                       :int32 delay))

(cl:defvar *touch-down* 0)
(cl:defun touch-send-down (resource serial time surface id x y)
  (resource-post-event resource *touch-down*
                       :uint32 serial
                       :uint32 time
                       :pointer (cl:or surface (null-pointer))
                       :int32 id
                       :int32 x
                       :int32 y))

(cl:defvar *touch-up* 1)
(cl:defun touch-send-up (resource serial time id)
  (resource-post-event resource *touch-up*
                       :uint32 serial
                       :uint32 time
                       :int32 id))

(cl:defvar *touch-motion* 2)
(cl:defun touch-send-motion (resource time id x y)
  (resource-post-event resource *touch-motion*
                       :uint32 time
                       :int32 id
                       :int32 x
                       :int32 y))

(cl:defvar *touch-frame* 3)
(cl:defun touch-send-frame (resource)
  (resource-post-event resource *touch-frame*))

(cl:defvar *touch-cancel* 4)
(cl:defun touch-send-cancel (resource)
  (resource-post-event resource *touch-cancel*))

(cl:defvar *touch-shape* 5)
(cl:defun touch-send-shape (resource id major minor)
  (resource-post-event resource *touch-shape*
                       :int32 id
                       :int32 major
                       :int32 minor))

(cl:defvar *touch-orientation* 6)
(cl:defun touch-send-orientation (resource id orientation)
  (resource-post-event resource *touch-orientation*
                       :int32 id
                       :int32 orientation))

(cl:defvar *output-geometry* 0)
(cl:defun output-send-geometry (resource x y physical-width physical-height subpixel make model transform)
  (resource-post-event resource *output-geometry*
                       :int32 x
                       :int32 y
                       :int32 physical-width
                       :int32 physical-height
                       :int32 subpixel
                       :string make
                       :string model
                       :int32 transform))

(cl:defvar *output-mode* 1)
(cl:defun output-send-mode (resource flags width height refresh)
  (resource-post-event resource *output-mode*
                       :uint32 flags
                       :int32 width
                       :int32 height
                       :int32 refresh))

(cl:defvar *output-done* 2)
(cl:defun output-send-done (resource)
  (resource-post-event resource *output-done*))

(cl:defvar *output-scale* 3)
(cl:defun output-send-scale (resource factor)
  (resource-post-event resource *output-scale*
                       :int32 factor))

(cl:defvar *output-name* 4)
(cl:defun output-send-name (resource name)
  (resource-post-event resource *output-name*
                       :string name))

(cl:defvar *output-description* 5)
(cl:defun output-send-description (resource description)
  (resource-post-event resource *output-description*
                       :string description))

(cl:export '(
  display-error
  shm-error
  shm-format
  data-offer-error
  data-source-error
  data-device-error
  data-device-manager-dnd-action
  shell-error
  shell-surface-resize
  shell-surface-transient
  shell-surface-fullscreen-method
  surface-error
  seat-capability
  seat-error
  pointer-error
  pointer-button-state
  pointer-axis
  pointer-axis-source
  pointer-axis-relative-direction
  keyboard-keymap-format
  keyboard-key-state
  output-subpixel
  output-transform
  output-mode
  subcompositor-error
  subsurface-error
  display-interface
  registry-interface
  compositor-interface
  shm-pool-interface
  shm-interface
  buffer-interface
  data-offer-interface
  data-source-interface
  data-device-interface
  data-device-manager-interface
  shell-interface
  shell-surface-interface
  surface-interface
  seat-interface
  pointer-interface
  keyboard-interface
  touch-interface
  output-interface
  region-interface
  subcompositor-interface
  subsurface-interface))

(cl:export '(
  registry-send-global
  registry-send-global-remove
  callback-send-done
  shm-send-format
  buffer-send-release
  data-offer-send-offer
  data-offer-send-source-actions
  data-offer-send-action
  data-source-send-target
  data-source-send-send
  data-source-send-cancelled
  data-source-send-dnd-drop-performed
  data-source-send-dnd-finished
  data-source-send-action
  data-device-send-data-offer
  data-device-send-enter
  data-device-send-leave
  data-device-send-motion
  data-device-send-drop
  data-device-send-selection
  shell-surface-send-ping
  shell-surface-send-configure
  shell-surface-send-popup-done
  surface-send-enter
  surface-send-leave
  surface-send-preferred-buffer-scale
  surface-send-preferred-buffer-transform
  seat-send-capabilities
  seat-send-name
  pointer-send-enter
  pointer-send-leave
  pointer-send-motion
  pointer-send-button
  pointer-send-axis
  pointer-send-frame
  pointer-send-axis-source
  pointer-send-axis-stop
  pointer-send-axis-discrete
  pointer-send-axis-value120
  pointer-send-axis-relative-direction
  keyboard-send-keymap
  keyboard-send-enter
  keyboard-send-leave
  keyboard-send-key
  keyboard-send-modifiers
  keyboard-send-repeat-info
  touch-send-down
  touch-send-up
  touch-send-motion
  touch-send-frame
  touch-send-cancel
  touch-send-shape
  touch-send-orientation
  output-send-geometry
  output-send-mode
  output-send-done
  output-send-scale
  output-send-name
  output-send-description))

(cl:export '(
  display-error-is-valid
  shm-error-is-valid
  shm-format-is-valid
  data-offer-error-is-valid
  data-source-error-is-valid
  data-device-error-is-valid
  data-device-manager-dnd-action-is-valid
  shell-error-is-valid
  shell-surface-resize-is-valid
  shell-surface-transient-is-valid
  shell-surface-fullscreen-method-is-valid
  surface-error-is-valid
  seat-capability-is-valid
  seat-error-is-valid
  pointer-error-is-valid
  pointer-button-state-is-valid
  pointer-axis-is-valid
  pointer-axis-source-is-valid
  pointer-axis-relative-direction-is-valid
  keyboard-keymap-format-is-valid
  keyboard-key-state-is-valid
  output-subpixel-is-valid
  output-transform-is-valid
  output-mode-is-valid
  subcompositor-error-is-valid
  subsurface-error-is-valid))
