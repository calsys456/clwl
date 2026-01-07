(cl:eval-when (:compile-toplevel :load-toplevel :execute)
  (cl:unless (cl:find-package "WL")
    (cl:make-package "WL" :use '("CFFI"))))
(cl:in-package "WL")

(define-foreign-library libwayland-server
  (:unix (:or "libwayland-server.so"))
  (t (:default "libwayland-server")))
(define-foreign-library libwayland-client
  (:unix (:or "libwayland-client.so"))
  (t (:default "libwayland-client")))

(use-foreign-library libwayland-server)
(use-foreign-library libwayland-client)

(cl:defmacro define-wl-struct (name-and-options cl:&body fields)
  (cl:let ((name (cl:if (cl:listp name-and-options)
                        (cl:first name-and-options)
                        name-and-options)))
    `(cl:eval-when (:compile-toplevel :load-toplevel :execute)
       (defcstruct ,name-and-options
         ,@fields)
       (cl:export ',name)
       ,@(cl:loop :for field :in fields
            :for field-name := (cl:first field)
            :for accessor-name := (cl:intern (cl:concatenate 'cl:string
                                                             (cl:symbol-name name)
                                                             "-"
                                                             (cl:symbol-name field-name))
                                             "WL")
            :collect `(cl:defmacro ,accessor-name (obj)
                        (cl:list ',(cl:if (cl:and (cl:atom (cl:second field))
                                                  (cl:not (cl:member (cl:second field) '(:pointer))))
                                          'foreign-slot-value
                                          'foreign-slot-pointer)
                                 obj ''(:struct ,name) ',field-name))
            :collect `(cl:define-setf-expander ,accessor-name (x cl:&environment env)
                        (cl:multiple-value-bind (dummies vals newval setter getter)
                            (cl:get-setf-expansion x env)
                          (cl:declare (cl:ignore newval setter))
                          (cl:let ((store (cl:gensym)))
                            (cl:values dummies
                                       vals
                                       `(,store)
                                       (cl:list 'cl:setf (cl:list 'foreign-slot-value getter ''(:struct ,name) ',field-name) store)
                                       (cl:list ',accessor-name getter)))))
            :collect `(cl:export ',accessor-name)))))

(cl:defmacro define-wl-func (type suffix ret-type cl:&body args)
  (cl:let* ((object-str (translate-underscore-separated-name type))
            (suffix-str (translate-underscore-separated-name suffix))
            (c-name (cl:concatenate 'cl:string "wl_" object-str "_" suffix-str))
            (lisp-name (cl:intern (cl:concatenate
                                   'cl:string
                                   (cl:symbol-name type) "-" (cl:symbol-name suffix))
                                  "WL")))
    `(cl:eval-when (:compile-toplevel :load-toplevel :execute)
       (defcfun (,c-name ,lisp-name) ,ret-type
         (,type (:pointer (:struct ,type)))
         ,@args)
       (cl:export ',lisp-name))))

(cl:defmacro define-wl-interface (name)
  (cl:let ((foreign-name (cl:concatenate
                          'cl:string
                          "wl_" (translate-underscore-separated-name name) "_interface"))
           (lisp-name (cl:intern
                       (cl:concatenate 'cl:string
                                       "*" (cl:symbol-name name) "-INTERFACE*"))))
    `(cl:eval-when (:compile-toplevel :load-toplevel :execute)
       (cl:define-symbol-macro ,lisp-name (foreign-symbol-pointer ,foreign-name))
       (cl:export ',lisp-name))))

(cl:defmacro define-wl-proxy-func (name func-name cl:&body args)
  (cl:let ((proxy-name (cl:intern
                        (cl:concatenate 'cl:string
                                        "PROXY-" (cl:symbol-name func-name))))
           (lisp-name (cl:intern
                       (cl:concatenate
                        'cl:string
                        (cl:symbol-name name) "-" (cl:symbol-name func-name)))))
    `(cl:eval-when (:compile-toplevel :load-toplevel :execute)
       (cl:defun ,lisp-name (,name ,@args)
         (cl:declare (cl:inline ,lisp-name))
         (,proxy-name ,name ,@args))
       (cl:export ',lisp-name))))

(define-wl-struct display)
(define-wl-struct proxy)
(define-wl-struct event-queue)
(define-wl-struct surface)
(define-wl-struct egl-window)
(define-wl-struct object)
(define-wl-struct event-loop)
(define-wl-struct event-source)
(define-wl-struct global)
(define-wl-struct client)
(define-wl-struct resource)
(define-wl-struct shm-buffer)
(define-wl-struct shm-pool)
