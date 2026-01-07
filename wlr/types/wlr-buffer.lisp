(in-package "WLR")

(define-wlr-struct shm-attributes
  (:fd :int)
  (:format :uint32)
  (:width :int)
  (:height :int)
  (:stride :int)
  (:offset :long))

(defcenum buffer-cap
  (:data-ptr 1)
  (:dmabuf 2)
  (:shm 4))

(define-wlr-events-struct buffer
  destroy
  release)

(define-wlr-struct buffer
  (:impl :pointer)
  (:width :int)
  (:height :int)
  (:dropped :bool)
  (:n-locks :size)
  (:accessing-data-ptr :bool)
  (:events (:struct buffer-events))
  (:addons (:struct addon-set)))

(define-wlr-func buffer drop :void)

(define-wlr-func buffer lock :pointer)

(define-wlr-func buffer unlock :void)

(define-wlr-func buffer get-dmabuf :bool
  (attribs (:pointer (:struct dmabuf-attributes))))

(define-wlr-func buffer get-shm :bool
  (attribs (:pointer (:struct shm-attributes))))

(defcfun ("wlr_buffer_try_from_resource" buffer-try-from-resource) :pointer
  (resource :pointer))
(export 'buffer-try-from-resource)

(define-wlr-func buffer is-opaque :bool)

(defcenum buffer-data-ptr-access-flag
  (:read 1)
  (:write 2))

(define-wlr-func buffer begin-data-ptr-access :bool
  (flags :uint32)
  (data (:pointer :pointer))
  (format (:pointer :uint32))
  (stride (:pointer :size)))

(define-wlr-func buffer end-data-ptr-access :void)

(define-wlr-struct client-buffer-private
  (:source-destroy (:struct wl:listener))
  (:renderer-destroy (:struct wl:listener))
  (:n-ignore-locks :size))

(define-wlr-struct client-buffer
  (:base (:struct buffer))
  (:texture :pointer)
  (:source :pointer)
  (:private (:struct client-buffer-private)))

(define-wlr-func buffer client-buffer-get :pointer)

(define-wlr-struct single-pixel-buffer-v1-private
  (:resource :pointer)
  (:release (:struct wl:listener))
  (:argb8888 (:array :uint8 4)))

(define-wlr-struct single-pixel-buffer-v1
  (:base (:struct buffer))
  (:r :uint32)
  (:g :uint32)
  (:b :uint32)
  (:a :uint32)
  (:private (:struct single-pixel-buffer-v1-private)))

(defcfun ("wlr_single_pixel_buffer_v1_try_from_buffer" single-pixel-buffer-v1-try-from-buffer) :pointer
  (buffer :pointer))
(export 'single-pixel-buffer-v1-try-from-buffer)

(export '(shm-attributes buffer-cap buffer buffer-data-ptr-access-flag client-buffer single-pixel-buffer-v1))
