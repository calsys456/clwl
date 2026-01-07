(cl:in-package "WL")

(cl:defun container-of (ptr type member)
  (make-pointer (cl:- (pointer-address ptr) (foreign-slot-offset type member))))
(cl:export 'container-of)

(define-wl-struct interface)

(define-wl-struct message
  (:name :string)
  (:signature :string)
  (:types (:pointer (:pointer (:struct interface)))))

(define-wl-struct interface
  (:name :string)
  (:version :int)
  (:method-count :int)
  (:methods (:pointer (:struct message)))
  (:event-count :int)
  (:events (:pointer (:struct message))))

(defcstruct list
  (:prev (:pointer (:struct list)))
  (:next (:pointer (:struct list))))
(cl:export 'list)

(define-wl-func list init :void)

(define-wl-func list insert :void
  (elm (:pointer (:struct list))))

(define-wl-func list remove :void)

(define-wl-func list length :int)

(define-wl-func list empty :int)

(define-wl-func list insert-list :void
  (other (:pointer (:struct list))))

(cl:defmacro list-prev (head member item-type)
  `(container-of (foreign-slot-pointer ,head '(struct wl-list) :prev)
    ,item-type ,member))

(cl:defmacro list-next (head member item-type)
  `(container-of (foreign-slot-pointer ,head '(struct wl-list) :next)
    ,item-type ,member))

(cl:defmacro dolist ((head member item-type) cl:&body body)
  `(let ((lst ,head))
     (loop for elm = (list-next lst ,member (:struct ,item-type))
           then (list-next elm ,member (:struct ,item-type))
           while (not (eq elm lst))
           do ,@body)))

(cl:defmacro dolist-safe ((head member item-type) cl:&body body)
  `(let ((lst ,head))
     (loop for elm = (list-next lst ,member (:struct ,item-type))
           then (list-next elm ,member (:struct ,item-type))
           while (not (eq elm lst))
           do (let ((next (list-next elm ,member (:struct ,item-type))))
                ,@body
                (setf elm next)))))

(cl:defmacro dolist-reverse ((head member item-type) cl:&body body)
  `(let ((lst ,head))
     (loop for elm = (list-prev lst ,member (:struct ,item-type))
           then (list-prev elm ,member (:struct ,item-type))
           while (not (eq elm lst))
           do ,@body)))

(cl:defmacro dolist-reverse-safe ((head member item-type) cl:&body body)
  `(let ((lst ,head))
     (loop for elm = (list-prev lst ,member (:struct ,item-type))
           then (list-prev elm ,member (:struct ,item-type))
           while (not (eq elm lst))
           do (let ((prev (list-prev elm ,member (:struct ,item-type))))
                ,@body
                (setf elm prev)))))

(cl:defmacro doarray ((array item-type) cl:&body body)
  `(let* ((arr ,array)
          (data (foreign-slot-pointer arr '(:struct wl_array) :data))
          (size (foreign-slot-value arr '(:struct wl_array) :size))
          (elem-size (foreign-size-of '(:struct ,item-type)))
          (count (if (zerop elem-size) 0 (floor size elem-size)))
          (ptr data))
     (dotimes (i count)
       (let ((elm (make-pointer (+ (pointer-address ptr) (* i elem-size)))))
         ,@body))))

(cl:export '(do-wl-list
             do-wl-list-safe do-wl-list-reverse
             do-wl-list-reverse-safe doarray))

(define-wl-struct array
  (:size :uint32)
  (:alloc :uint32)
  (:data :pointer))

(define-wl-func array init :void)

(define-wl-func array release :void)

(define-wl-func array add :pointer
  (size :uint32))

(define-wl-func array copy :int
  (source (:pointer (:struct array))))

(defcunion argument
  (:i :int32)
  (:u :uint32)
  (:f :int32)
  (:s :string)
  (:o (:pointer (:struct object)))
  (:n :uint32)
  (:a (:pointer (:struct array)))
  (:h :int32))

(defcenum iterator-result
  :stop
  :continue)

(cl:export '(argument iterator-result))
