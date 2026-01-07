(in-package "WLR")

(define-wlr-struct addon-set-private
  (:addons (:struct wl:list)))

(define-wlr-struct addon-set
  (:private (:struct addon-set-private)))

(define-wlr-struct addon-interface
  (:name :string)
  (:destroy :pointer))

(define-wlr-struct addon-private
  (:owner :pointer)
  (:link (:struct wl:list)))

(define-wlr-struct addon
  (:impl (:pointer (:struct addon-interface)))
  (:private (:struct addon-private)))

(export '(addon-set-private addon-set addon-interface addon-private addon))

(define-wlr-func addon-set init :void)
(define-wlr-func addon-set finish :void)

(define-wlr-func addon init :void
  (addon-set (:pointer (:struct addon-set)))
  (owner :pointer)
  (impl (:pointer (:struct addon-interface))))
(define-wlr-func addon finish :void)

(defcfun ("wlr_addon_find" addon-find) (:pointer (:struct addon))
  (addon-set (:pointer (:struct addon-set)))
  (owner :pointer)
  (impl (:pointer (:struct addon-interface))))
(export 'addon-find)
