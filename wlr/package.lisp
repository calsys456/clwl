(cl:eval-when (:compile-toplevel :load-toplevel :execute)
  (cl:unless (cl:find-package "WLR")
    (cl:make-package "WLR" :use '("CL" "CFFI"))))
(cl:in-package "WLR")

(define-foreign-library libwlroots
  (:unix (:or "libwlroots-0.19.so")))

(use-foreign-library libwlroots)

(defmacro define-wlr-struct (name-and-options &body fields)
  (let ((name (if (listp name-and-options)
                  (first name-and-options)
                  name-and-options)))
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (defcstruct ,name-and-options ,@fields)
       (export ',name)
       ,@(loop for field in fields
               for field-name = (first field)
               for accessor-name = (intern (concatenate 'string
                                                        (symbol-name name)
                                                        "-"
                                                        (symbol-name field-name))
                                           "WLR")
               collect `(defmacro ,accessor-name (obj)
                          (list ',(if (and (atom (second field))
                                           (not (member (second field) '(:pointer))))
                                      'foreign-slot-value
                                      'foreign-slot-pointer)
                                obj ''(:struct ,name) ',field-name))
               collect `(define-setf-expander ,accessor-name (x &environment env)
                          (multiple-value-bind (dummies vals newval setter getter)
                              (get-setf-expansion x env)
                            (declare (ignore newval setter))
                            (let ((store (gensym)))
                              (values dummies
                                      vals
                                      `(,store)
                                      (list 'setf (list 'foreign-slot-value getter ''(:struct ,name) ',field-name) store)
                                      (list ',accessor-name getter)))))
               collect `(export ',accessor-name)))))

(defmacro define-wlr-events-struct (name &body signals)
  (let ((struct-name (intern (concatenate 'string (symbol-name name) "-EVENTS") "WLR")))
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (define-wlr-struct ,struct-name
         ,@(loop for signal in signals
                 collect `(,(cl:intern (cl:symbol-name signal) "KEYWORD")
                            (:struct wl:signal)))))))

(defmacro define-wlr-private-listener (name &body listeners)
  (let ((struct-name (intern (concatenate 'string (symbol-name name) "-PRIVATE") "WLR")))
    `(defcstruct ,struct-name
       ,@(loop for listener in listeners
               collect `(,(cl:intern (cl:symbol-name listener) "KEYWORD")
                          (:struct wl:listener))))))

(defmacro define-wlr-func (object suffix ret-type &body args)
  (let* ((object-str (translate-underscore-separated-name object))
         (suffix-str (translate-underscore-separated-name suffix))
         (c-name (concatenate 'string "wlr_" object-str "_" suffix-str))
         (lisp-name (intern (concatenate
                             'string
                             (symbol-name object) "-" (symbol-name suffix))
                            "WLR")))
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (defcfun (,c-name ,lisp-name) ,ret-type
         (,object (:pointer (:struct ,object)))
         ,@args)
       (export ',lisp-name))))

(defmacro event-signal (object type-name slot-name)
  (let ((events-type-name (intern (concatenate 'string (symbol-name type-name) "-EVENTS") "WLR")))
    `(cffi:foreign-slot-pointer (cffi:foreign-slot-pointer ,object '(:struct ,type-name) :events)
                                 '(:struct ,events-type-name)
                                 ,slot-name)))
(export 'event-signal)
