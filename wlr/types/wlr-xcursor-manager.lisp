(in-package "WLR")

(define-wlr-struct xcursor-manager-theme
  (:scale :float)
  (:theme :pointer)
  (:link (:struct wl:list)))

(define-wlr-struct xcursor-manager
  (:name :string)
  (:size :uint32)
  (:scaled-themes (:struct wl:list)))

(defcfun ("wlr_xcursor_manager_create" xcursor-manager-create) (:pointer (:struct xcursor-manager))
  (name :string)
  (size :uint32))
(export 'xcursor-manager-create)

(define-wlr-func xcursor-manager destroy :void)

(define-wlr-func xcursor-manager load :bool
  (scale :float))

(define-wlr-func xcursor-manager get-xcursor :pointer
  (name :string)
  (scale :float))

(export '(xcursor-manager-theme xcursor-manager))
