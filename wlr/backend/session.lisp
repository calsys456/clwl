(in-package "WLR")

(define-wlr-events-struct device change remove)

(define-wlr-struct device
  (:fd :int)
  (:device-fd :int)
  (:dev :unsigned-long)
  (:link (:struct wl:list))
  (:events (:struct device-events)))
(export 'device)

(define-wlr-events-struct session active add-drm-card destroy)

(define-wlr-private-listener session event-loop-destroy)

(define-wlr-struct session
  (:active :bool)
  (:seat :string)
  (:udev :pointer)
  (:udev-monitor :pointer)
  (:udev-event (:pointer (:struct wl:event-source)))
  (:seat-handle :pointer)
  (:devices (:struct wl:list))
  (:event-loop (:pointer (:struct wl:event-loop)))
  (:events (:struct session-events))
  (:private (:struct session-private)))
(export 'session)

(define-wlr-struct session-add-event
  (:path :string))
(export 'session-add-event)

(defcenum device-change-type
  (:hotplug 1)
  :lease)

(define-wlr-struct device-hotplug-event
  (:connector-id :uint32)
  (:prop-id :uint32))
(export 'device-hotplug-event)

(defcunion device-hotplug-union
  (hotplug (:struct device-hotplug-event)))

(define-wlr-struct device-change-event
  (:type :int)
  (:union (:union device-hotplug-union)))
(export 'device-change-event)

(defcfun ("wlr_session_create" session-create) (:pointer (:struct session))
  (event-loop (:pointer (:struct wl:event-loop))))

(define-wlr-func session destroy :void)

(define-wlr-func session open-file (:pointer (:struct device))
  (path :string))

(define-wlr-func session close-file :void
  (device (:pointer (:struct device))))

(define-wlr-func session change-vt :bool
  (vt :unsigned-int))

(define-wlr-func session find-gpus :long-long
  (return-len :unsigned-long-long)
  (ret (:pointer (:pointer (:struct device)))))
