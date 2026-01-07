(in-package "WLR")

(define-wlr-events-struct output-layout
  add
  change
  destroy)

(define-wlr-private-listener output-layout display-destroy)

(define-wlr-struct output-layout
  (:outputs (:struct wl:list))
  (:display (:pointer (:struct wl:display)))
  (:events (:struct output-layout-events))
  (:data :pointer)
  (:private (:struct output-layout-private)))

(define-wlr-events-struct output-layout-output destroy)

(define-wlr-private-listener output-layout-output addon commit)

(define-wlr-struct output-layout-output
  (:layout (:pointer (:struct output-layout)))
  (:output (:pointer (:struct output)))
  (:x :int)
  (:y :int)
  (:link (:struct wl:list))
  (:auto-configured :bool)
  (:events (:struct output-layout-output-events))
  (:private (:struct output-layout-output-private)))

(defcenum direction
  (:up 1)
  (:down 2)
  (:left 4)
  (:right 8))

(defcfun ("wlr_output_layout_create" output-layout-create) (:pointer (:struct output-layout))
  (display (:pointer (:struct wl:display))))
(export 'output-layout-create)

(define-wlr-func output-layout destroy :void)

(define-wlr-func output-layout get (:pointer (:struct output-layout-output))
  (reference (:pointer (:struct output))))

(define-wlr-func output-layout output-at (:pointer (:struct output))
  (lx :double)
  (ly :double))

(define-wlr-func output-layout add (:pointer (:struct output-layout-output))
  (output (:pointer (:struct output)))
  (lx :int)
  (ly :int))

(define-wlr-func output-layout add-auto (:pointer (:struct output-layout-output))
  (output (:pointer (:struct output))))

(define-wlr-func output-layout remove :void
  (output (:pointer (:struct output))))

(define-wlr-func output-layout output-coords :void
  (reference (:pointer (:struct output)))
  (lx (:pointer :double))
  (ly (:pointer :double)))

(define-wlr-func output-layout contains-point :bool
  (reference (:pointer (:struct output)))
  (lx :int)
  (ly :int))

(define-wlr-func output-layout intersects :bool
  (reference (:pointer (:struct output)))
  (target-lbox (:pointer (:struct box))))

(define-wlr-func output-layout closest-point :void
  (reference (:pointer (:struct output)))
  (lx :double)
  (ly :double)
  (dest-lx (:pointer :double))
  (dest-ly (:pointer :double)))

(define-wlr-func output-layout get-box :void
  (reference (:pointer (:struct output)))
  (dest-box (:pointer (:struct box))))

(define-wlr-func output-layout get-center-output (:pointer (:struct output)))

(define-wlr-func output-layout adjacent-output (:pointer (:struct output))
  (direction :int)
  (reference (:pointer (:struct output)))
  (ref-lx :double)
  (ref-ly :double))

(define-wlr-func output-layout farthest-output (:pointer (:struct output))
  (direction :int)
  (reference (:pointer (:struct output)))
  (ref-lx :double)
  (ref-ly :double))

(export '(output-layout output-layout-output direction))
