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

(defcenum display-error
  (:invalid-object 0)
  (:invalid-method 1)
  (:no-memory 2)
  (:implementation 3))
(cl:export 'display-error)

(define-wl-struct display-listener
  (:error :pointer)
  (:delete-id :pointer))
(cl:export 'display-listener)

(define-wl-proxy-func display add-listener listener data)

(define-wl-proxy-func display set-user-data userdata)

(define-wl-proxy-func display get-user-data)

(define-wl-proxy-func display get-version)

(cl:defvar *display-sync* 0)
(cl:defvar *display-get-registry* 1)

(cl:defun display-sync (display)
  (proxy-marshal-flags display *display-sync* *display-interface*
                       (proxy-get-version display) 0
                       :pointer (null-pointer)))

(cl:defun display-get-registry (display)
  (proxy-marshal-flags display *display-get-registry* *registry-interface*
                       (proxy-get-version display) 0
                       :pointer (null-pointer)))

(define-wl-struct registry-listener
  (:global :pointer)
  (:global-remove :pointer))

(define-wl-proxy-func registry add-listener listener data)

(cl:defvar *registry-bind* 0)

(define-wl-proxy-func registry set-user-data user-data)

(define-wl-proxy-func registry get-user-data)

(define-wl-proxy-func registry get-version)

(define-wl-proxy-func registry destroy)

(cl:defun registry-bind (registry name interface version)
  (proxy-marshal-flags registry *registry-bind* interface version 0
                       :uint32 name
                       :string (foreign-slot-value interface '(:struct interface) :name)
                       :uint32 version
                       :pointer (null-pointer)))

(define-wl-struct callback-listener
  (:done :pointer))

(define-wl-proxy-func callback add-listener listener data)

(define-wl-proxy-func callback set-user-data user-data)

(define-wl-proxy-func callback get-user-data)

(define-wl-proxy-func callback get-version)

(define-wl-proxy-func callback destroy)

(cl:defvar *compositor-create-surface* 0)
(cl:defvar *compositor-create-region* 1)

(define-wl-proxy-func compositor set-user-data user-data)

(define-wl-proxy-func compositor get-user-data)

(define-wl-proxy-func compositor get-version)

(define-wl-proxy-func compositor destroy)

(cl:defun compositor-create-surface (compositor)
  (proxy-marshal-flags compositor *compositor-create-surface* *surface-interface*
                       (proxy-get-version compositor) 0
                       :pointer (null-pointer)))

(cl:defun compositor-create-region (compositor)
  (proxy-marshal-flags compositor *compositor-create-region* *region-interface*
                       (proxy-get-version compositor) 0
                       :pointer (null-pointer)))

(cl:defvar *shm-pool-create-buffer* 0)
(cl:defvar *shm-pool-destroy* 1)
(cl:defvar *shm-pool-resize* 2)

(define-wl-proxy-func shm-pool set-user-data user-data)

(define-wl-proxy-func shm-pool get-user-data)

(define-wl-proxy-func shm-pool get-version)

(cl:defun shm-pool-create-buffer (pool offset width height stride format)
  (proxy-marshal-flags pool *shm-pool-create-buffer* *buffer-interface*
                       (proxy-get-version pool) 0
                       :pointer (null-pointer)
                       :int32 offset
                       :int32 width
                       :int32 height
                       :int32 stride
                       :uint32 format))

(cl:defun shm-pool-destroy (pool)
  (proxy-marshal-flags pool *shm-pool-destroy* (null-pointer)
                       (proxy-get-version pool) *marshal-flag-destroy*))

(cl:defun shm-pool-resize (pool size)
  (proxy-marshal-flags pool *shm-pool-resize* (null-pointer)
                       (proxy-get-version pool) 0
                       :int32 size))

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

(define-wl-struct shm-listener
  (:format :pointer))

(define-wl-proxy-func shm add-listener listener data)

(cl:defvar *shm-create-pool* 0)
(cl:defvar *shm-release* 1)

(define-wl-proxy-func shm set-user-data user-data)

(define-wl-proxy-func shm get-user-data)

(define-wl-proxy-func shm get-version)

(define-wl-proxy-func shm destroy)

(cl:defun shm-create-pool (shm fd size)
  (proxy-marshal-flags shm *shm-create-pool* *shm-pool-interface* (proxy-get-version shm) 0
                       :pointer (null-pointer) :int32 fd :int32 size))

(cl:defun shm-release (shm)
  (proxy-marshal-flags shm *shm-release* (null-pointer)
                       (proxy-get-version shm) *marshal-flag-destroy*))

(define-wl-struct buffer-listener
  (:release :pointer))

(define-wl-proxy-func buffer add-listener listener data)

(define-wl-proxy-func buffer set-user-data user-data)

(define-wl-proxy-func buffer get-user-data)

(define-wl-proxy-func buffer get-version)

(cl:defvar *buffer-destroy* 0)

(cl:defun buffer-destroy (buffer)
  (proxy-marshal-flags buffer *buffer-destroy* (null-pointer)
                       (proxy-get-version buffer) *marshal-flag-destroy*))

(defcenum data-offer-error
  (:invalid-finish 0)
  (:invalid-action-mask 1)
  (:invalid-action 2)
  (:invalid-offer 3))

(define-wl-struct data-offer-listener
  (:offer :pointer)
  (:source-actions :pointer)
  (:action :pointer))

(define-wl-proxy-func data-offer add-listener listener data)

(define-wl-proxy-func data-offer set-user-data user-data)

(define-wl-proxy-func data-offer get-user-data)

(define-wl-proxy-func data-offer get-version)

(cl:defvar *data-offer-accept* 0)
(cl:defvar *data-offer-receive* 1)
(cl:defvar *data-offer-destroy* 2)
(cl:defvar *data-offer-finish* 3)
(cl:defvar *data-offer-set-actions* 4)

(cl:defun data-offer-accept (offer serial mime-type)
  (cl:if mime-type
         (proxy-marshal-flags offer *data-offer-accept* (null-pointer)
                              (proxy-get-version offer) 0
                              :uint32 serial
                              :string mime-type)
         (proxy-marshal-flags offer *data-offer-accept* (null-pointer)
                              (proxy-get-version offer) 0
                              :uint32 serial
                              :pointer (null-pointer))))

(cl:defun data-offer-receive (offer mime-type fd)
  (proxy-marshal-flags offer *data-offer-receive* (null-pointer)
                       (proxy-get-version offer) 0
                       :string mime-type
                       :int32 fd))

(cl:defun data-offer-destroy (offer)
  (proxy-marshal-flags offer *data-offer-destroy* (null-pointer)
                       (proxy-get-version offer) *marshal-flag-destroy*))

(cl:defun data-offer-finish (offer)
  (proxy-marshal-flags offer *data-offer-finish* (null-pointer)
                       (proxy-get-version offer) 0))

(cl:defun data-offer-set-actions (offer dnd-actions preferred-action)
  (proxy-marshal-flags offer *data-offer-set-actions* (null-pointer)
                       (proxy-get-version offer) 0
                       :uint32 dnd-actions
                       :uint32 preferred-action))

(defcenum data-source-error
  (:invalid-action-mask 0)
  (:invalid-source 1))

(define-wl-struct data-source-listener
  (:target :pointer)
  (:send :pointer)
  (:cancelled :pointer)
  (:dnd-drop-performed :pointer)
  (:dnd-finished :pointer)
  (:action :pointer))

(define-wl-proxy-func data-source add-listener listener data)

(define-wl-proxy-func data-source set-user-data user-data)

(define-wl-proxy-func data-source get-user-data)

(define-wl-proxy-func data-source get-version)

(cl:defvar *data-source-offer* 0)
(cl:defvar *data-source-destroy* 1)
(cl:defvar *data-source-set-actions* 2)

(cl:defun data-source-offer (source mime-type)
  (proxy-marshal-flags source *data-source-offer* (null-pointer)
                       (proxy-get-version source) 0
                       :string mime-type))

(cl:defun data-source-destroy (source)
  (proxy-marshal-flags source *data-source-destroy* (null-pointer)
                       (proxy-get-version source) *marshal-flag-destroy*))

(cl:defun data-source-set-actions (source dnd-actions)
  (proxy-marshal-flags source *data-source-set-actions* (null-pointer)
                       (proxy-get-version source) 0
                       :uint32 dnd-actions))

(defcenum data-device-error
  (:role 0)
  (:used-source 1))

(define-wl-struct data-device-listener
  (:data-offer :pointer)
  (:enter :pointer)
  (:leave :pointer)
  (:motion :pointer)
  (:drop :pointer)
  (:selection :pointer))

(define-wl-proxy-func data-device add-listener listener data)

(define-wl-proxy-func data-device set-user-data user-data)

(define-wl-proxy-func data-device get-user-data)

(define-wl-proxy-func data-device get-version)

(define-wl-proxy-func data-device destroy)

(cl:defvar *data-device-start-drag* 0)
(cl:defvar *data-device-set-selection* 1)
(cl:defvar *data-device-release* 2)

(cl:defun data-device-start-drag (device source origin icon serial)
  (proxy-marshal-flags device *data-device-start-drag* (null-pointer)
                       (proxy-get-version device) 0
                       :pointer (cl:or source (null-pointer))
                       :pointer origin
                       :pointer (cl:or icon (null-pointer))
                       :uint32 serial))

(cl:defun data-device-set-selection (device source serial)
  (proxy-marshal-flags device *data-device-set-selection* (null-pointer)
                       (proxy-get-version device) 0
                       :pointer (cl:or source (null-pointer))
                       :uint32 serial))

(cl:defun data-device-release (device)
  (proxy-marshal-flags device *data-device-release* (null-pointer)
                       (proxy-get-version device) *marshal-flag-destroy*))

(defcenum data-device-manager-dnd-action
  (:none 0)
  (:copy 1)
  (:move 2)
  (:ask 4))

(define-wl-proxy-func data-device-manager set-user-data user-data)

(define-wl-proxy-func data-device-manager get-user-data)

(define-wl-proxy-func data-device-manager get-version)

(define-wl-proxy-func data-device-manager destroy)

(cl:defvar *data-device-manager-create-data-source* 0)
(cl:defvar *data-device-manager-get-data-device* 1)

(cl:defun data-device-manager-create-data-source (manager)
  (proxy-marshal-flags manager *data-device-manager-create-data-source* *data-source-interface*
                       (proxy-get-version manager) 0
                       :pointer (null-pointer)))

(cl:defun data-device-manager-get-data-device (manager seat)
  (proxy-marshal-flags manager *data-device-manager-get-data-device* *data-device-interface*
                       (proxy-get-version manager) 0
                       :pointer (null-pointer)
                       :pointer seat))

(defcenum shell-error
  (:role 0))

(define-wl-proxy-func shell set-user-data user-data)

(define-wl-proxy-func shell get-user-data)

(define-wl-proxy-func shell get-version)

(define-wl-proxy-func shell destroy)

(cl:defvar *shell-get-shell-surface* 0)

(cl:defun shell-get-shell-surface (shell surface)
  (proxy-marshal-flags shell *shell-get-shell-surface* *shell-surface-interface*
                       (proxy-get-version shell) 0
                       :pointer (null-pointer)
                       :pointer surface))

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

(define-wl-struct shell-surface-listener
  (:ping :pointer)
  (:configure :pointer)
  (:popup-done :pointer))

(define-wl-proxy-func shell-surface add-listener listener data)

(define-wl-proxy-func shell-surface set-user-data user-data)

(define-wl-proxy-func shell-surface get-user-data)

(define-wl-proxy-func shell-surface get-version)

(define-wl-proxy-func shell-surface destroy)

(cl:defvar *shell-surface-pong* 0)
(cl:defvar *shell-surface-move* 1)
(cl:defvar *shell-surface-resize* 2)
(cl:defvar *shell-surface-set-toplevel* 3)
(cl:defvar *shell-surface-set-transient* 4)
(cl:defvar *shell-surface-set-fullscreen* 5)
(cl:defvar *shell-surface-set-popup* 6)
(cl:defvar *shell-surface-set-maximized* 7)
(cl:defvar *shell-surface-set-title* 8)
(cl:defvar *shell-surface-set-class* 9)

(cl:defun shell-surface-pong (shell-surface serial)
  (proxy-marshal-flags shell-surface *shell-surface-pong* (null-pointer)
                       (proxy-get-version shell-surface) 0
                       :uint32 serial))

(cl:defun shell-surface-move (shell-surface seat serial)
  (proxy-marshal-flags shell-surface *shell-surface-move* (null-pointer)
                       (proxy-get-version shell-surface) 0
                       :pointer seat
                       :uint32 serial))

(cl:defun shell-surface-resize (shell-surface seat serial edges)
  (proxy-marshal-flags shell-surface *shell-surface-resize* (null-pointer)
                       (proxy-get-version shell-surface) 0
                       :pointer seat
                       :uint32 serial
                       :uint32 edges))

(cl:defun shell-surface-set-toplevel (shell-surface)
  (proxy-marshal-flags shell-surface *shell-surface-set-toplevel* (null-pointer)
                       (proxy-get-version shell-surface) 0))

(cl:defun shell-surface-set-transient (shell-surface parent x y flags)
  (proxy-marshal-flags shell-surface *shell-surface-set-transient* (null-pointer)
                       (proxy-get-version shell-surface) 0
                       :pointer parent
                       :int32 x
                       :int32 y
                       :uint32 flags))

(cl:defun shell-surface-set-fullscreen (shell-surface method framerate output)
  (proxy-marshal-flags shell-surface *shell-surface-set-fullscreen* (null-pointer)
                       (proxy-get-version shell-surface) 0
                       :uint32 method
                       :uint32 framerate
                       :pointer (cl:or output (null-pointer))))

(cl:defun shell-surface-set-popup (shell-surface seat serial parent x y flags)
  (proxy-marshal-flags shell-surface *shell-surface-set-popup* (null-pointer)
                       (proxy-get-version shell-surface) 0
                       :pointer seat
                       :uint32 serial
                       :pointer parent
                       :int32 x
                       :int32 y
                       :uint32 flags))

(cl:defun shell-surface-set-maximized (shell-surface output)
  (proxy-marshal-flags shell-surface *shell-surface-set-maximized* (null-pointer)
                       (proxy-get-version shell-surface) 0
                       :pointer (cl:or output (null-pointer))))

(cl:defun shell-surface-set-title (shell-surface title)
  (proxy-marshal-flags shell-surface *shell-surface-set-title* (null-pointer)
                       (proxy-get-version shell-surface) 0
                       :string title))

(cl:defun shell-surface-set-class (shell-surface class)
  (proxy-marshal-flags shell-surface *shell-surface-set-class* (null-pointer)
                       (proxy-get-version shell-surface) 0
                       :string class))

(defcenum surface-error
  (:invalid-scale 0)
  (:invalid-transform 1)
  (:invalid-size 2)
  (:invalid-offset 3)
  (:defunct-role-object 4))

(define-wl-struct surface-listener
  (:enter :pointer)
  (:leave :pointer)
  (:preferred-buffer-scale :pointer)
  (:preferred-buffer-transform :pointer))

(define-wl-proxy-func surface add-listener listener data)

(define-wl-proxy-func surface set-user-data user-data)

(define-wl-proxy-func surface get-user-data)

(define-wl-proxy-func surface get-version)

(cl:defvar *surface-destroy* 0)
(cl:defvar *surface-attach* 1)
(cl:defvar *surface-damage* 2)
(cl:defvar *surface-frame* 3)
(cl:defvar *surface-set-opaque-region* 4)
(cl:defvar *surface-set-input-region* 5)
(cl:defvar *surface-commit* 6)
(cl:defvar *surface-set-buffer-transform* 7)
(cl:defvar *surface-set-buffer-scale* 8)
(cl:defvar *surface-damage-buffer* 9)
(cl:defvar *surface-offset* 10)

(cl:defun surface-destroy (surface)
  (proxy-marshal-flags surface *surface-destroy* (null-pointer)
                       (proxy-get-version surface) *marshal-flag-destroy*))

(cl:defun surface-attach (surface buffer x y)
  (proxy-marshal-flags surface *surface-attach* (null-pointer)
                       (proxy-get-version surface) 0
                       :pointer (cl:or buffer (null-pointer))
                       :int32 x
                       :int32 y))

(cl:defun surface-damage (surface x y width height)
  (proxy-marshal-flags surface *surface-damage* (null-pointer)
                       (proxy-get-version surface) 0
                       :int32 x
                       :int32 y
                       :int32 width
                       :int32 height))

(cl:defun surface-frame (surface)
  (proxy-marshal-flags surface *surface-frame* *callback-interface*
                       (proxy-get-version surface) 0
                       :pointer (null-pointer)))

(cl:defun surface-set-opaque-region (surface region)
  (proxy-marshal-flags surface *surface-set-opaque-region* (null-pointer)
                       (proxy-get-version surface) 0
                       :pointer (cl:or region (null-pointer))))

(cl:defun surface-set-input-region (surface region)
  (proxy-marshal-flags surface *surface-set-input-region* (null-pointer)
                       (proxy-get-version surface) 0
                       :pointer (cl:or region (null-pointer))))

(cl:defun surface-commit (surface)
  (proxy-marshal-flags surface *surface-commit* (null-pointer)
                       (proxy-get-version surface) 0))

(cl:defun surface-set-buffer-transform (surface transform)
  (proxy-marshal-flags surface *surface-set-buffer-transform* (null-pointer)
                       (proxy-get-version surface) 0
                       :int32 transform))

(cl:defun surface-set-buffer-scale (surface scale)
  (proxy-marshal-flags surface *surface-set-buffer-scale* (null-pointer)
                       (proxy-get-version surface) 0
                       :int32 scale))

(cl:defun surface-damage-buffer (surface x y width height)
  (proxy-marshal-flags surface *surface-damage-buffer* (null-pointer)
                       (proxy-get-version surface) 0
                       :int32 x
                       :int32 y
                       :int32 width
                       :int32 height))

(cl:defun surface-offset (surface x y)
  (proxy-marshal-flags surface *surface-offset* (null-pointer)
                       (proxy-get-version surface) 0
                       :int32 x
                       :int32 y))

(defcenum seat-capability
  (:pointer 1)
  (:keyboard 2)
  (:touch 4))

(defcenum seat-error
  (:missing-capability 0))

(define-wl-struct seat-listener
  (:capabilities :pointer)
  (:name :pointer))

(define-wl-proxy-func seat add-listener listener data)

(define-wl-proxy-func seat set-user-data user-data)

(define-wl-proxy-func seat get-user-data)

(define-wl-proxy-func seat get-version)

(define-wl-proxy-func seat destroy)

(cl:defvar *seat-get-pointer* 0)
(cl:defvar *seat-get-keyboard* 1)
(cl:defvar *seat-get-touch* 2)
(cl:defvar *seat-release* 3)

(cl:defun seat-get-pointer (seat)
  (proxy-marshal-flags seat *seat-get-pointer* *pointer-interface*
                       (proxy-get-version seat) 0
                       :pointer (null-pointer)))

(cl:defun seat-get-keyboard (seat)
  (proxy-marshal-flags seat *seat-get-keyboard* *keyboard-interface*
                       (proxy-get-version seat) 0
                       :pointer (null-pointer)))

(cl:defun seat-get-touch (seat)
  (proxy-marshal-flags seat *seat-get-touch* *touch-interface*
                       (proxy-get-version seat) 0
                       :pointer (null-pointer)))

(cl:defun seat-release (seat)
  (proxy-marshal-flags seat *seat-release* (null-pointer)
                       (proxy-get-version seat) *marshal-flag-destroy*))

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

(define-wl-struct pointer-listener
  (:enter :pointer)
  (:leave :pointer)
  (:motion :pointer)
  (:button :pointer)
  (:axis :pointer)
  (:frame :pointer)
  (:axis-source :pointer)
  (:axis-stop :pointer)
  (:axis-discrete :pointer)
  (:axis-value120 :pointer)
  (:axis-relative-direction :pointer))

(define-wl-proxy-func pointer add-listener listener data)

(define-wl-proxy-func pointer set-user-data user-data)

(define-wl-proxy-func pointer get-user-data)

(define-wl-proxy-func pointer get-version)

(define-wl-proxy-func pointer destroy)

(cl:defvar *pointer-set-cursor* 0)
(cl:defvar *pointer-release* 1)

(cl:defun pointer-set-cursor (pointer serial surface hotspot-x hotspot-y)
  (proxy-marshal-flags pointer *pointer-set-cursor* (null-pointer)
                       (proxy-get-version pointer) 0
                       :uint32 serial
                       :pointer (cl:or surface (null-pointer))
                       :int32 hotspot-x
                       :int32 hotspot-y))

(cl:defun pointer-release (pointer)
  (proxy-marshal-flags pointer *pointer-release* (null-pointer)
                       (proxy-get-version pointer) *marshal-flag-destroy*))

(defcenum keyboard-keymap-format
  (:no-keymap 0)
  (:xkb-v1 1))

(defcenum keyboard-key-state
  (:released 0)
  (:pressed 1))

(define-wl-struct keyboard-listener
  (:keymap :pointer)
  (:enter :pointer)
  (:leave :pointer)
  (:key :pointer)
  (:modifiers :pointer)
  (:repeat-info :pointer))

(define-wl-proxy-func keyboard add-listener listener data)

(define-wl-proxy-func keyboard set-user-data user-data)

(define-wl-proxy-func keyboard get-user-data)

(define-wl-proxy-func keyboard get-version)

(define-wl-proxy-func keyboard destroy)

(cl:defvar *keyboard-release* 0)

(cl:defun keyboard-release (keyboard)
  (proxy-marshal-flags keyboard *keyboard-release* (null-pointer)
                       (proxy-get-version keyboard) *marshal-flag-destroy*))

(define-wl-struct touch-listener
  (:down :pointer)
  (:up :pointer)
  (:motion :pointer)
  (:frame :pointer)
  (:cancel :pointer)
  (:shape :pointer)
  (:orientation :pointer))

(define-wl-proxy-func touch add-listener listener data)

(define-wl-proxy-func touch set-user-data user-data)

(define-wl-proxy-func touch get-user-data)

(define-wl-proxy-func touch get-version)

(define-wl-proxy-func touch destroy)

(cl:defvar *touch-release* 0)

(cl:defun touch-release (touch)
  (proxy-marshal-flags touch *touch-release* (null-pointer)
                       (proxy-get-version touch) *marshal-flag-destroy*))

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

(define-wl-struct output-listener
  (:geometry :pointer)
  (:mode :pointer)
  (:done :pointer)
  (:scale :pointer)
  (:name :pointer)
  (:description :pointer))

(define-wl-proxy-func output add-listener listener data)

(define-wl-proxy-func output set-user-data user-data)

(define-wl-proxy-func output get-user-data)

(define-wl-proxy-func output get-version)

(define-wl-proxy-func output destroy)

(cl:defvar *output-release* 0)

(cl:defun output-release (output)
  (proxy-marshal-flags output *output-release* (null-pointer)
                       (proxy-get-version output) *marshal-flag-destroy*))

(define-wl-proxy-func region set-user-data user-data)

(define-wl-proxy-func region get-user-data)

(define-wl-proxy-func region get-version)

(cl:defvar *region-destroy* 0)
(cl:defvar *region-add* 1)
(cl:defvar *region-subtract* 2)

(cl:defun region-destroy (region)
  (proxy-marshal-flags region *region-destroy* (null-pointer)
                       (proxy-get-version region) *marshal-flag-destroy*))

(cl:defun region-add (region x y width height)
  (proxy-marshal-flags region *region-add* (null-pointer)
                       (proxy-get-version region) 0
                       :int32 x
                       :int32 y
                       :int32 width
                       :int32 height))

(cl:defun region-subtract (region x y width height)
  (proxy-marshal-flags region *region-subtract* (null-pointer)
                       (proxy-get-version region) 0
                       :int32 x
                       :int32 y
                       :int32 width
                       :int32 height))

(defcenum subcompositor-error
  (:bad-surface 0)
  (:bad-parent 1))

(define-wl-proxy-func subcompositor set-user-data user-data)

(define-wl-proxy-func subcompositor get-user-data)

(define-wl-proxy-func subcompositor get-version)

(cl:defvar *subcompositor-destroy* 0)
(cl:defvar *subcompositor-get-subsurface* 1)

(cl:defun subcompositor-destroy (subcompositor)
  (proxy-marshal-flags subcompositor *subcompositor-destroy* (null-pointer)
                       (proxy-get-version subcompositor) *marshal-flag-destroy*))

(cl:defun subcompositor-get-subsurface (subcompositor surface parent)
  (proxy-marshal-flags subcompositor *subcompositor-get-subsurface* *subsurface-interface*
                       (proxy-get-version subcompositor) 0
                       :pointer (null-pointer)
                       :pointer surface
                       :pointer parent))

(defcenum subsurface-error
  (:bad-surface 0))

(define-wl-proxy-func subsurface set-user-data user-data)

(define-wl-proxy-func subsurface get-user-data)

(define-wl-proxy-func subsurface get-version)

(cl:defvar *subsurface-destroy* 0)
(cl:defvar *subsurface-set-position* 1)
(cl:defvar *subsurface-place-above* 2)
(cl:defvar *subsurface-place-below* 3)
(cl:defvar *subsurface-set-sync* 4)
(cl:defvar *subsurface-set-desync* 5)

(cl:defun subsurface-destroy (subsurface)
  (proxy-marshal-flags subsurface *subsurface-destroy* (null-pointer)
                       (proxy-get-version subsurface) *marshal-flag-destroy*))

(cl:defun subsurface-set-position (subsurface x y)
  (proxy-marshal-flags subsurface *subsurface-set-position* (null-pointer)
                       (proxy-get-version subsurface) 0
                       :int32 x
                       :int32 y))

(cl:defun subsurface-place-above (subsurface sibling)
  (proxy-marshal-flags subsurface *subsurface-place-above* (null-pointer)
                       (proxy-get-version subsurface) 0
                       :pointer sibling))

(cl:defun subsurface-place-below (subsurface sibling)
  (proxy-marshal-flags subsurface *subsurface-place-below* (null-pointer)
                       (proxy-get-version subsurface) 0
                       :pointer sibling))

(cl:defun subsurface-set-sync (subsurface)
  (proxy-marshal-flags subsurface *subsurface-set-sync* (null-pointer)
                       (proxy-get-version subsurface) 0))

(cl:defun subsurface-set-desync (subsurface)
  (proxy-marshal-flags subsurface *subsurface-set-desync* (null-pointer)
                       (proxy-get-version subsurface) 0))

;; defcenum and defcstruct
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
  display-listener
  registry-listener
  callback-listener
  shm-listener
  buffer-listener
  data-offer-listener
  data-source-listener
  data-device-listener
  shell-surface-listener
  surface-listener
  seat-listener
  pointer-listener
  keyboard-listener
  touch-listener
  output-listener))
;; defun
(cl:export '(
  display-sync
  display-get-registry
  registry-bind
  compositor-create-surface
  compositor-create-region
  shm-pool-create-buffer
  shm-pool-destroy
  shm-pool-resize
  shm-create-pool
  shm-release
  buffer-destroy
  data-offer-accept
  data-offer-receive
  data-offer-destroy
  data-offer-finish
  data-offer-set-actions
  data-source-offer
  data-source-destroy
  data-source-set-actions
  data-device-start-drag
  data-device-set-selection
  data-device-release
  data-device-manager-create-data-source
  data-device-manager-get-data-device
  shell-get-shell-surface
  shell-surface-pong
  shell-surface-move
  shell-surface-resize
  shell-surface-set-toplevel
  shell-surface-set-transient
  shell-surface-set-fullscreen
  shell-surface-set-popup
  shell-surface-set-maximized
  shell-surface-set-title
  shell-surface-set-class
  surface-destroy
  surface-attach
  surface-damage
  surface-frame
  surface-set-opaque-region
  surface-set-input-region
  surface-commit
  surface-set-buffer-transform
  surface-set-buffer-scale
  surface-damage-buffer
  surface-offset
  seat-get-pointer
  seat-get-keyboard
  seat-get-touch
  seat-release
  pointer-set-cursor
  pointer-release
  keyboard-release
  touch-release
  output-release
  region-destroy
  region-add
  region-subtract
  subcompositor-destroy
  subcompositor-get-subsurface
  subsurface-destroy
  subsurface-set-position
  subsurface-place-above
  subsurface-place-below
  subsurface-set-sync
  subsurface-set-desync))
