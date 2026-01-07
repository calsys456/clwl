(in-package "WLR")

(define-wlr-events-struct drm-lease destroy)

(define-wlr-struct drm-backend)
(define-wlr-struct session)
(define-wlr-struct device)

(define-wlr-struct drm-lease
  (:fd :int)
  (:lessee-id :uint32)
  (:drm-backend (:pointer (:struct drm-backend)))
  (:events (:struct drm-lease-events))
  (:data :pointer))
(export 'drm-lease)

(defcfun ("wlr_drm_backend_create" drm-backend-create) (:pointer (:struct backend))
  (session (:pointer (:struct session)))
  (device (:pointer (:struct device)))
  (parent (:pointer (:struct backend))))
(export 'drm-backend-create)

(define-wlr-func backend is-drm :bool)
(define-wlr-func output is-drm :bool)

(define-wlr-func drm-backend get-parent (:pointer (:struct backend)))

(defcfun ("wlr_drm_connector_get_id" drm-connector-get-id) :uint32
  (output (:pointer (:struct output))))
(export 'drm-connector-get-id)

(define-wlr-func drm-backend get-non-master-fd :int)

(defcfun ("wlr_drm_create_lease" drm-create-lease) (:pointer (:struct drm-lease))
  (outputs (:pointer (:pointer (:struct output))))
  (outputs-count :unsigned-long-long)
  (lease-fd (:pointer :int)))
(export 'drm-create-lease)

(define-wlr-func drm-lease terminate :void)

(defcfun ("wlr_drm_connector_add_mode" drm-connector-add-mode) (:pointer (:struct output-mode))
  (output (:pointer (:struct output)))
  (mode :pointer))

(defcfun ("wlr_drm_mode_get_info" drm-mode-get-info) :pointer
  (output-mode (:pointer (:struct output-mode))))

(defcfun ("wlr_drm_connector_get_panel_orientation" drm-connector-get-panel-orientation) :int
  (output (:pointer (:struct output))))

(export '(drm-connector-add-mode drm-mode-get-info drm-connector-get-panel-orientation))
