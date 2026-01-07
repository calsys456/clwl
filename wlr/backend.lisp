(cl:in-package "WLR")

(define-wlr-struct backend-impl)
(define-wlr-struct session)

(define-wlr-struct backend-output-state
  (:output (:pointer (:struct output)))
  (:base (:struct output-state)))

(define-wlr-struct backend-features
  (:timeline :bool))

(define-wlr-events-struct backend destroy new-input new-output)

(define-wlr-struct backend
  (:impl (:pointer (:struct backend-impl)))
  (:buffer-caps :uint32)
  (:features (:struct backend-features))
  (:events (:struct backend-events)))

(export '(backend-output-state backend-features backend))

(defcfun ("wlr_backend_autocreate" backend-autocreate) (:pointer (:struct backend))
  (event-loop (:pointer (:struct wl:event-loop)))
  (session-ptr (:pointer (:pointer (:struct session)))))
(export 'backend-autocreate)

(define-wlr-func backend start :bool)

(define-wlr-func backend destroy :void)

(define-wlr-func backend get-drm-fd :int)

(define-wlr-func backend test :bool
  (output-states (:pointer (:struct backend-output-state)))
  (states-len :unsigned-long-long))

(define-wlr-func backend commit :bool
  (output-states (:pointer (:struct backend-output-state)))
  (states-len :unsigned-long-long))
