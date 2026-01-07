(defpackage "TINYWL"
  (:use "CL"))
(in-package "TINYWL")

(defvar *display* nil)
(defvar *backend* nil)
(defvar *renderer* nil)
(defvar *allocator* nil)
(defvar *output-layout* nil)
(defvar *scene* nil)
(defvar *scene-layout* nil)
(defvar *xdg-shell* nil)
(defvar *cursor* nil)
(defvar *cursor-manager* nil)
(defvar *cursor-mode* :passthrough)
(defvar *seat* nil)

(defvar *new-output-listener* nil)
(defvar *new-xdg-toplevel* nil)
(defvar *new-xdg-popup* nil)
(defvar *cursor-motion* nil)
(defvar *cursor-motion-absolute* nil)
(defvar *cursor-button* nil)
(defvar *cursor-axis* nil)
(defvar *cursor-frame* nil)
(defvar *new-input-listener* nil)
(defvar *request-set-cursor-listener* nil)
(defvar *request-set-selection-listener* nil)

(defvar *grabbed-toplevel* nil)
(defvar *grab-x* 0)
(defvar *grab-y* 0)
(defvar *grab-geobox* nil)
(defvar *resize-edges* nil)

(defvar *keyboards* nil)
(defstruct keyboard wlr-keyboard modifiers key destroy)

(defvar *focused-toplevel* nil)
(defvar *toplevels* nil)
(defstruct toplevel xdg-toplevel scene-tree map unmap commit destroy
                    request-move request-resize request-maximize request-fullscreen)

(defvar *popups* nil)
(defstruct popup xdg-popup commit destroy)

(defvar *outputs* nil)
(defstruct output wlr-output frame request-state destroy)

(defun focus-toplevel (toplevel)
  (format t "Focusing toplevel ~a~%" toplevel)
  (when toplevel
    (format t "DEBUG: focus-toplevel accessing seat keyboard-state~%")
    (let ((prev-surface (wlr:seat-keyboard-state-focused-surface (wlr:seat-keyboard-state *seat*))))
      (format t "DEBUG: prev-surface = ~a~%" prev-surface)
      (format t "DEBUG: toplevel-xdg-toplevel = ~a~%" (toplevel-xdg-toplevel toplevel))
      (format t "DEBUG: accessing xdg-toplevel->base->surface~%")
      (let ((surface (wlr:xdg-surface-surface (wlr:xdg-toplevel-base (toplevel-xdg-toplevel toplevel)))))
        (format t "DEBUG: surface = ~a~%" surface)
        (unless (cffi:pointer-eq prev-surface surface)
          (unless (cffi:null-pointer-p prev-surface)
            (let ((prev-toplevel (wlr:xdg-toplevel-try-from-wlr-surface prev-surface)))
              (unless (cffi:null-pointer-p prev-toplevel)
                (wlr:xdg-toplevel-set-activated prev-toplevel nil))))
          ;; Move the toplevel to the front of the list
          (setf *toplevels* (cons toplevel (remove toplevel *toplevels*)))
          (wlr:scene-node-raise-to-top (wlr:scene-tree-node (toplevel-scene-tree toplevel)))
          (wlr:xdg-toplevel-set-activated (toplevel-xdg-toplevel toplevel) t)
          (let ((keyboard (wlr:seat-get-keyboard *seat*)))
            (when keyboard
              (wlr:seat-keyboard-notify-enter
               *seat*
               surface
               (wlr:keyboard-keycodes keyboard)
               (wlr:keyboard-num-keycodes keyboard)
               (wlr:keyboard-modifiers keyboard)))))))))

(cffi:defcallback keyboard-handle-modifiers :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (format t "Keyboard modifiers changed~%")
  (let ((kb (find-if (lambda (k) (cffi:pointer-eq (keyboard-modifiers k) listener)) *keyboards*)))
    (when kb
      (wlr:seat-set-keyboard *seat* (keyboard-wlr-keyboard kb))
      (wlr:seat-keyboard-notify-modifiers
       *seat*
       (wlr:keyboard-modifiers (keyboard-wlr-keyboard kb))))))

(defun handle-keybinding (keycode)
  (format t "Keycode: ~a~%" keycode)
  (case keycode
    (9 (format t "Escape key pressed, exiting...~%")
     (reset-cursor-mode)
     (wl:display-terminate *display*)
     t)
    (67 (format t "F1 key pressed, switching toplevel")
     (when (> (length *toplevels*) 1)
       (let ((toplevel (nth (mod (+ (position *focused-toplevel* *toplevels*) 1)
                                 (length *toplevels*))
                            *toplevels*)))
         (setf *focused-toplevel* toplevel)
         (focus-toplevel toplevel))))))

(cffi:defcallback keyboard-handle-key :void ((listener :pointer) (data :pointer))
  (format t "Keyboard key event~%")
  (let ((kb (find-if (lambda (k) (cffi:pointer-eq (keyboard-key k) listener)) *keyboards*))
        (keycode (+ (wlr:keyboard-key-event-keycode data) 8)))
    (when kb
      (let* ((modifiers (wlr:keyboard-get-modifiers (keyboard-wlr-keyboard kb)))
             handled)
        (when (and (logand modifiers (cffi:foreign-enum-value 'wlr:keyboard-modifier :alt))
                   (eql (wlr:keyboard-key-event-state data)
                        (cffi:foreign-enum-value 'wl:keyboard-key-state :pressed)))
          (setf handled (handle-keybinding keycode)))
        (unless handled
          (wlr:seat-set-keyboard *seat* (keyboard-wlr-keyboard kb))
          (wlr:seat-keyboard-notify-key
           *seat*
           (wlr:keyboard-key-event-time-msec data)
           (wlr:keyboard-key-event-keycode data)
           (wlr:keyboard-key-event-state data)))))))

(cffi:defcallback keyboard-handle-destroy :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (format t "Keyboard destroyed~%")
  (let* ((kb (find-if (lambda (k) (cffi:pointer-eq (keyboard-destroy k) listener)) *keyboards*)))
    (when kb
      (setf *keyboards* (remove kb *keyboards*))
      (wl:list-remove (wl:listener-link (keyboard-modifiers kb)))
      (wl:list-remove (wl:listener-link (keyboard-key kb)))
      (wl:list-remove (wl:listener-link (keyboard-destroy kb))))))

(defun server-new-keyboard (device)
  (let* ((wlr-keyboard (wlr:keyboard-from-input-device device))
         (context (wl-util:xkb-context-new (cffi:foreign-enum-value 'wl-util:xkb-context-flags :no-flags)))
         (keymap (wl-util:xkb-keymap-new-from-names
                  context (cffi:null-pointer)
                  (cffi:foreign-enum-value 'wl-util:xkb-keymap-compile-flags :no-flags)))
         (modifiers (cffi:foreign-alloc '(:struct wl:listener)))
         (key (cffi:foreign-alloc '(:struct wl:listener)))
         (destroy (cffi:foreign-alloc '(:struct wl:listener)))
         (kb (make-keyboard :wlr-keyboard wlr-keyboard
                            :modifiers modifiers
                            :key key
                            :destroy destroy)))
    (wlr:keyboard-set-keymap wlr-keyboard keymap)
    (wl-util:xkb-keymap-unref keymap)
    (wl-util:xkb-context-unref context)
    (wlr:keyboard-set-repeat-info wlr-keyboard 25 600)

    (setf (wl:listener-notify modifiers) (cffi:callback keyboard-handle-modifiers)
          (wl:listener-notify key) (cffi:callback keyboard-handle-key)
          (wl:listener-notify destroy) (cffi:callback keyboard-handle-destroy))
    (wl:signal-add (wlr:event-signal wlr-keyboard wlr:keyboard :modifiers)
                   modifiers)
    (wl:signal-add (wlr:event-signal wlr-keyboard wlr:keyboard :key)
                   key)
    (wl:signal-add (wlr:event-signal device wlr:input-device :destroy)
                   destroy)
    (wlr:seat-set-keyboard *seat* wlr-keyboard)
    (push kb *keyboards*)))

(defun server-new-pointer (device)
  (wlr:cursor-attach-input-device *cursor* device))

(cffi:defcallback server-new-input :void ((listener :pointer) (data :pointer))
  (declare (ignore listener))
  (cffi:with-foreign-slots (((type :type)) data (:struct wlr:input-device))
    (cond
      ((eql type (cffi:foreign-enum-value 'wlr:input-device-type :keyboard))
       (format t "New keyboard input device~%")
       (server-new-keyboard data))
      ((eql type (cffi:foreign-enum-value 'wlr:input-device-type :pointer))
       (format t "New pointer input device~%")
       (server-new-pointer data)))
    (let ((caps (cffi:foreign-enum-value 'wl:seat-capability :pointer)))
      (when *keyboards*
        (setf caps (logior caps (cffi:foreign-enum-value 'wl:seat-capability :keyboard))))
      (wlr:seat-set-capabilities *seat* caps))))

(cffi:defcallback seat-request-set-cursor :void ((listener :pointer) (event :pointer))
  (declare (ignore listener))
  (format t "Seat requested set cursor~%")
  (let* ((focused-client (wlr:seat-pointer-state-focused-client (wlr:seat-pointer-state *seat*))))
    (when (cffi:pointer-eq focused-client
                           (wlr:seat-pointer-request-set-cursor-event-seat-client event))
      (wlr:cursor-set-surface *cursor*
                              (wlr:seat-pointer-request-set-cursor-event-surface event)
                              (wlr:seat-pointer-request-set-cursor-event-hotspot-x event)
                              (wlr:seat-pointer-request-set-cursor-event-hotspot-y event)))))

(cffi:defcallback seat-request-set-selection :void ((listener :pointer) (event :pointer))
  (declare (ignore listener))
  (format t "Seat requested set selection~%")
  (wlr:seat-set-selection *seat*
                          (wlr:seat-request-set-selection-event-source event)
                          (wlr:seat-request-set-selection-event-serial event)))

(defun desktop-toplevel-at (lx ly sx sy)
  (let ((node (wlr:scene-node-at (wlr:scene-tree-node (wlr:scene-tree *scene*))
                                 lx ly sx sy)))
    (when (or (cffi:null-pointer-p node)
              (cffi:with-foreign-slots (((type :type)) node (:struct wlr:scene-node))
                (not (eql type (cffi:foreign-enum-value 'wlr:scene-node-type :buffer)))))
      (return-from desktop-toplevel-at (values (cffi:null-pointer) (cffi:null-pointer))))
    (let* ((scene-buffer (wlr:scene-buffer-from-node node))
           (scene-surface (wlr:scene-surface-try-from-buffer scene-buffer)))
      (when (cffi:null-pointer-p scene-surface)
        (return-from desktop-toplevel-at (values (cffi:null-pointer) (cffi:null-pointer))))
      (let ((tree (wlr:scene-node-parent node)))
        (loop while (and (not (cffi:null-pointer-p tree))
                         (cffi:null-pointer-p
                          (wlr:scene-node-data (wlr:scene-tree-node tree))))
              do (setf tree (wlr:scene-node-parent (wlr:scene-tree-node tree))))
        (values (wlr:scene-node-data (wlr:scene-tree-node tree))
                (wlr:scene-surface-surface scene-surface))))))

(defun reset-cursor-mode ()
  (setf *cursor-mode* :passthrough
        *grabbed-toplevel* nil))

(defun process-cursor-move ()
  (when *grabbed-toplevel*
    (wlr:scene-node-set-position (wlr:scene-tree-node (toplevel-scene-tree *grabbed-toplevel*))
                                 (- (wlr:cursor-x *cursor*) *grab-x*)
                                 (- (wlr:cursor-y *cursor*) *grab-y*))))

(defun process-cursor-resize ()
  (when *grabbed-toplevel*
    (let ((border-x (- (wlr:cursor-x *cursor*) *grab-x*))
          (border-y (- (wlr:cursor-y *cursor*) *grab-y*))
          (new-left (wlr:box-x *grab-geobox*))
          (new-right (+ (wlr:box-x *grab-geobox*) (wlr:box-width *grab-geobox*)))
          (new-top (wlr:box-y *grab-geobox*))
          (new-bottom (+ (wlr:box-y *grab-geobox*) (wlr:box-height *grab-geobox*))))
      (if (logand *resize-edges* (cffi:foreign-enum-value 'wlr:edges :top))
          (progn (setf new-top border-y)
                 (when (>= new-top new-bottom)
                   (setf new-top (- new-bottom 1))))
          (when (logand *resize-edges* (cffi:foreign-enum-value 'wlr:edges :bottom))
            (setf new-bottom border-y)
            (when (< new-bottom new-top)
              (setf new-bottom (+ new-top 1)))))
      (if (logand *resize-edges* (cffi:foreign-enum-value 'wlr:edges :left))
          (progn (setf new-left border-x)
                 (when (>= new-left new-right)
                   (setf new-left (- new-right 1))))
          (when (logand *resize-edges* (cffi:foreign-enum-value 'wlr:edges :right))
            (setf new-right border-x)
            (when (< new-right new-left)
              (setf new-right (+ new-left 1)))))

      (let ((geo-box (wlr:xdg-surface-geometry
                      (wlr:xdg-toplevel-base (toplevel-xdg-toplevel *grabbed-toplevel*))))
            (new-width (- new-right new-left))
            (new-height (- new-bottom new-top)))
        (wlr:scene-node-set-position (wlr:scene-tree-node (toplevel-scene-tree *grabbed-toplevel*))
                                     (- new-left (wlr:box-x geo-box))
                                     (- new-top (wlr:box-y geo-box)))
        (wlr:xdg-toplevel-set-size (toplevel-xdg-toplevel *grabbed-toplevel*) new-width new-height)))))

(defun process-cursor-motion (time)
  (case *cursor-mode*
    (:passthrough
     (cffi:with-foreign-objects ((sx :double) (sy :double) (sx-ptr :pointer) (sy-ptr :pointer))
       (setf (cffi:mem-aref sx-ptr :pointer) sx
             (cffi:mem-aref sy-ptr :pointer) sy)
       (multiple-value-bind (toplevel surface)
           (desktop-toplevel-at (wlr:cursor-x *cursor*) (wlr:cursor-y *cursor*) sx-ptr sy-ptr)
         (when (cffi:null-pointer-p toplevel)
           (wlr:cursor-set-xcursor *cursor* *cursor-manager* "default"))
         (if (cffi:null-pointer-p surface)
             (wlr:seat-pointer-clear-focus *seat*)
             (progn (wlr:seat-pointer-notify-enter *seat* surface
                                                   (cffi:mem-ref sx :double)
                                                   (cffi:mem-ref sy :double))
                    (wlr:seat-pointer-notify-motion *seat* time
                                                    (cffi:mem-ref sx :double)
                                                    (cffi:mem-ref sy :double)))))))
    (:move (process-cursor-move))
    (:resize (process-cursor-resize))))

(cffi:defcallback server-cursor-motion :void ((listener :pointer) (event :pointer))
  (declare (ignore listener))
  (format t "Cursor motion event~%")
  (let* ((pointer (wlr:pointer-motion-event-pointer event))
         (base (wlr:pointer-base pointer)))
    (wlr:cursor-move *cursor*
                     base
                     (wlr:pointer-motion-event-delta-x event)
                     (wlr:pointer-motion-event-delta-y event))
    (process-cursor-motion (wlr:pointer-motion-event-time-msec event))))

(cffi:defcallback server-cursor-motion-absolute :void ((listener :pointer) (event :pointer))
  (declare (ignore listener))
  (format t "Cursor absolute motion event~%")
  (let* ((pointer (wlr:pointer-motion-absolute-event-pointer event))
         (base (wlr:pointer-base pointer)))
    (wlr:cursor-warp-absolute *cursor*
                              base
                              (wlr:pointer-motion-absolute-event-x event)
                              (wlr:pointer-motion-absolute-event-y event))
    (process-cursor-motion (wlr:pointer-motion-absolute-event-time-msec event))))

(cffi:defcallback server-cursor-button :void ((listener :pointer) (event :pointer))
  (declare (ignore listener))
  (format t "Cursor button event~%")
  (wlr:seat-pointer-notify-button *seat*
                                  (wlr:pointer-button-event-time-msec event)
                                  (wlr:pointer-button-event-button event)
                                  (wlr:pointer-button-event-state event))
  (when (eql (wlr:pointer-button-event-state event)
             (cffi:foreign-enum-value 'wl:pointer-button-state :released))
    (reset-cursor-mode))
  (when (eql (wlr:pointer-button-event-state event)
             (cffi:foreign-enum-value 'wl:pointer-button-state :pressed))
    (cffi:with-foreign-objects ((sx :double) (sy :double) (sx-ptr :pointer) (sy-ptr :pointer))
      (setf (cffi:mem-aref sx-ptr :pointer) sx
            (cffi:mem-aref sy-ptr :pointer) sy)
      (let ((scene-tree-ptr (desktop-toplevel-at (wlr:cursor-x *cursor*) (wlr:cursor-y *cursor*) sx-ptr sy-ptr)))
        (unless (cffi:null-pointer-p scene-tree-ptr)
          (let ((toplevel (find-if (lambda (top) (cffi:pointer-eq (toplevel-scene-tree top) scene-tree-ptr))
                                   *toplevels*)))
            (when toplevel
              (focus-toplevel toplevel))))))))

(cffi:defcallback server-cursor-axis :void ((listener :pointer) (event :pointer))
  (declare (ignore listener))
  (format t "Cursor axis event~%")
  (wlr:seat-pointer-notify-axis *seat*
                                (wlr:pointer-axis-event-time-msec event)
                                (wlr:pointer-axis-event-orientation event)
                                (wlr:pointer-axis-event-delta event)
                                (wlr:pointer-axis-event-delta-discrete event)
                                (wlr:pointer-axis-event-source event)
                                (wlr:pointer-axis-event-relative-direction event)))

(cffi:defcallback server-cursor-frame :void ((listener :pointer) (data :pointer))
  (declare (ignore listener data))
  (format t "Cursor frame event~%")
  (wlr:seat-pointer-notify-frame *seat*))

(cffi:defcallback output-frame :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (format t "Output frame event~%")
  (let ((output (find-if (lambda (o) (cffi:pointer-eq (output-frame o) listener)) *outputs*)))
    (when output
      (let ((scene-output (wlr:scene-get-scene-output *scene* (output-wlr-output output))))
        (wlr:scene-output-commit scene-output (cffi:null-pointer))
        (cffi:with-foreign-object (now '(:struct wlr:timespec))
          (cffi:foreign-funcall "clock_gettime" :int 1 :pointer now)
          (wlr:scene-output-send-frame-done scene-output now))))))

(cffi:defcallback output-request-state :void ((listener :pointer) (data :pointer))
  (format t "Output request state event~%")
  (let ((output (find-if (lambda (o) (cffi:pointer-eq (output-request-state o) listener)) *outputs*)))
    (wlr:output-commit-state (output-wlr-output output)
                             (wlr:output-event-request-state-state data))))

(cffi:defcallback output-destroy :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (format t "Output destroyed~%")
  (let* ((out (find-if (lambda (o) (cffi:pointer-eq (output-destroy o) listener)) *outputs*)))
    (when out
      (setf *outputs* (remove out *outputs*))
      (wl:list-remove (wl:listener-link (output-frame out)))
      (wl:list-remove (wl:listener-link (output-request-state out)))
      (wl:list-remove (wl:listener-link (output-destroy out))))))

(cffi:defcallback server-new-output :void ((listener :pointer) (wlr-output :pointer))
  (declare (ignore listener))
  (format t "New output created~%")
  (wlr:output-init-render wlr-output *allocator* *renderer*)
  (cffi:with-foreign-object (state '(:struct wlr:output-state))
    (wlr:output-state-init state)
    (wlr:output-state-set-enabled state t)
    (let ((mode (wlr:output-preferred-mode wlr-output)))
      (unless (cffi:null-pointer-p mode)
        (wlr:output-state-set-mode state mode)))
    (wlr:output-commit-state wlr-output state)
    (wlr:output-state-finish state))

  (let* ((frame (cffi:foreign-alloc '(:struct wl:listener)))
         (request-state (cffi:foreign-alloc '(:struct wl:listener)))
         (destroy (cffi:foreign-alloc '(:struct wl:listener)))
         (output (make-output :wlr-output wlr-output
                              :frame frame
                              :request-state request-state
                              :destroy destroy)))
    (setf (wl:listener-notify frame) (cffi:callback output-frame)
          (wl:listener-notify request-state) (cffi:callback output-request-state)
          (wl:listener-notify destroy) (cffi:callback output-destroy))
    (wl:signal-add (wlr:event-signal wlr-output wlr:output :frame) frame)
    (wl:signal-add (wlr:event-signal wlr-output wlr:output :request-state) request-state)
    (wl:signal-add (wlr:event-signal wlr-output wlr:output :destroy) destroy)
    (push output *outputs*))

  (let ((l-output (wlr:output-layout-add-auto *output-layout* wlr-output))
        (scene-output (wlr:scene-output-create *scene* wlr-output)))
    (wlr:scene-output-layout-add-output *scene-layout* l-output scene-output)))

(cffi:defcallback xdg-toplevel-map :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (format t "XDG toplevel mapped~%")
  (let ((toplevel (find-if (lambda (top) (cffi:pointer-eq (toplevel-map top) listener)) *toplevels*)))
    (when toplevel
      (setf *focused-toplevel* toplevel)
      (focus-toplevel toplevel))))

(cffi:defcallback xdg-toplevel-unmap :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (format t "XDG toplevel unmapped~%")
  (let ((toplevel (find-if (lambda (top) (cffi:pointer-eq (toplevel-unmap top) listener)) *toplevels*)))
    (when toplevel
      (when (eq toplevel *grabbed-toplevel*)
        (reset-cursor-mode))
      (when (eq toplevel *focused-toplevel*)
        (setf *focused-toplevel* nil))
      (setf *toplevels* (remove toplevel *toplevels*)))))

(cffi:defcallback xdg-toplevel-commit :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (format t "XDG toplevel committed~%")
  (let ((toplevel (find-if (lambda (top) (cffi:pointer-eq (toplevel-commit top) listener)) *toplevels*)))
    (when (and toplevel
               (wlr:xdg-surface-initial-commit (wlr:xdg-toplevel-base (toplevel-xdg-toplevel toplevel))))
      (wlr:xdg-toplevel-set-size (toplevel-xdg-toplevel toplevel) 0 0))))

(cffi:defcallback xdg-toplevel-destroy :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (let* ((toplevel (find-if (lambda (top) (cffi:pointer-eq (toplevel-destroy top) listener)) *toplevels*)))
    (when toplevel
      (setf *toplevels* (remove toplevel *toplevels*))
      ;; Simple 1:1 translation of C code: just remove listeners
      (wl:list-remove (wl:listener-link (toplevel-map toplevel)))
      (wl:list-remove (wl:listener-link (toplevel-unmap toplevel)))
      (wl:list-remove (wl:listener-link (toplevel-commit toplevel)))
      (wl:list-remove (wl:listener-link (toplevel-destroy toplevel)))
      (wl:list-remove (wl:listener-link (toplevel-request-move toplevel)))
      (wl:list-remove (wl:listener-link (toplevel-request-resize toplevel)))
      (wl:list-remove (wl:listener-link (toplevel-request-maximize toplevel)))
      (wl:list-remove (wl:listener-link (toplevel-request-fullscreen toplevel)))
      ;; Note: C version would free(toplevel) here, but we can't easily do that in Lisp
      ;; The listener memory will leak, but that's acceptable for now
      )))

(defun begin-interactive (toplevel mode edges)
  (setf *grabbed-toplevel* toplevel
        *cursor-mode* mode)
  (let* ((node (wlr:scene-tree-node (toplevel-scene-tree toplevel)))
         (node-x (wlr:scene-node-x node))
         (node-y (wlr:scene-node-y node)))
    (if (eq mode :move)
        (setf *grab-x* (- (wlr:cursor-x *cursor*) node-x)
              *grab-y* (- (wlr:cursor-y *cursor*) node-y))
        (let* ((geo-box (wlr:xdg-surface-geometry
                         (wlr:xdg-toplevel-base (toplevel-xdg-toplevel toplevel))))
               (border-x (+ node-x
                            (wlr:box-x geo-box)
                            (if (logand edges (cffi:foreign-enum-value 'wlr:edges :right))
                                (wlr:box-width geo-box)
                                0)))
               (border-y (+ node-y
                            (wlr:box-y geo-box)
                            (if (logand edges (cffi:foreign-enum-value 'wlr:edges :bottom))
                                (wlr:box-height geo-box)
                                0))))
          (setf *grab-x* (- (wlr:cursor-x *cursor*) border-x)
                *grab-y* (- (wlr:cursor-y *cursor*) border-y))
          ;; Copy the geobox structure instead of using the pointer directly
          (unless *grab-geobox*
            (setf *grab-geobox* (cffi:foreign-alloc '(:struct wlr:box))))
          (setf (wlr:box-x *grab-geobox*) (+ (wlr:box-x geo-box) node-x)
                (wlr:box-y *grab-geobox*) (+ (wlr:box-y geo-box) node-y)
                (wlr:box-width *grab-geobox*) (wlr:box-width geo-box)
                (wlr:box-height *grab-geobox*) (wlr:box-height geo-box)
                *resize-edges* edges)))))

(cffi:defcallback xdg-toplevel-request-move :void ((listener :pointer) (event :pointer))
  (declare (ignore event))
  (format t "XDG toplevel requested move~%")
  (let ((toplevel (find-if (lambda (top) (cffi:pointer-eq (toplevel-request-move top) listener)) *toplevels*)))
    (when toplevel
      (begin-interactive toplevel :move 0))))

(cffi:defcallback xdg-toplevel-request-resize :void ((listener :pointer) (event :pointer))
  (format t "XDG toplevel requested resize~%")
  (let ((toplevel (find-if (lambda (top) (cffi:pointer-eq (toplevel-request-resize top) listener)) *toplevels*)))
    (when toplevel
      (begin-interactive toplevel :resize (wlr:xdg-toplevel-resize-event-edges event)))))

(cffi:defcallback xdg-toplevel-request-maximize :void ((listener :pointer) (event :pointer))
  (declare (ignore event))
  (format t "XDG toplevel requested maximize~%")
  (let* ((toplevel (find-if (lambda (top) (cffi:pointer-eq (toplevel-request-maximize top) listener)) *toplevels*))
         (base (wlr:xdg-toplevel-base (toplevel-xdg-toplevel toplevel))))
    (when (wlr:xdg-surface-initialized base)
      (wlr:xdg-surface-schedule-configure base))))

(cffi:defcallback xdg-toplevel-request-fullscreen :void ((listener :pointer) (event :pointer))
  (declare (ignore event))
  (format t "XDG toplevel requested fullscreen~%")
  (let* ((toplevel (find-if (lambda (top) (cffi:pointer-eq (toplevel-request-fullscreen top) listener)) *toplevels*))
         (base (wlr:xdg-toplevel-base (toplevel-xdg-toplevel toplevel))))
    (when (wlr:xdg-surface-initialized base)
      (wlr:xdg-surface-schedule-configure base))))

(cffi:defcallback server-new-xdg-toplevel :void ((listener :pointer) (xdg-toplevel :pointer))
  (declare (ignore listener))
  (format t "New XDG toplevel created~%")
  (let* ((base (wlr:xdg-toplevel-base xdg-toplevel))
         (scene-tree (wlr:scene-xdg-surface-create (wlr:scene-tree *scene*) base))
         (surface (wlr:xdg-surface-surface base))
         (map (cffi:foreign-alloc '(:struct wl:listener)))
         (unmap (cffi:foreign-alloc '(:struct wl:listener)))
         (commit (cffi:foreign-alloc '(:struct wl:listener)))
         (destroy (cffi:foreign-alloc '(:struct wl:listener)))
         (request-move (cffi:foreign-alloc '(:struct wl:listener)))
         (request-resize (cffi:foreign-alloc '(:struct wl:listener)))
         (request-maximize (cffi:foreign-alloc '(:struct wl:listener)))
         (request-fullscreen (cffi:foreign-alloc '(:struct wl:listener)))
         (toplevel (make-toplevel :xdg-toplevel xdg-toplevel
                                  :scene-tree scene-tree
                                  :map map
                                  :unmap unmap
                                  :commit commit
                                  :destroy destroy
                                  :request-move request-move
                                  :request-resize request-resize
                                  :request-maximize request-maximize
                                  :request-fullscreen request-fullscreen)))
    (setf (wlr:xdg-surface-data base) scene-tree)
    (setf (wl:listener-notify map) (cffi:callback xdg-toplevel-map)
          (wl:listener-notify unmap) (cffi:callback xdg-toplevel-unmap)
          (wl:listener-notify commit) (cffi:callback xdg-toplevel-commit)
          (wl:listener-notify destroy) (cffi:callback xdg-toplevel-destroy)
          (wl:listener-notify request-move) (cffi:callback xdg-toplevel-request-move)
          (wl:listener-notify request-resize) (cffi:callback xdg-toplevel-request-resize)
          (wl:listener-notify request-maximize) (cffi:callback xdg-toplevel-request-maximize)
          (wl:listener-notify request-fullscreen) (cffi:callback xdg-toplevel-request-fullscreen))
    (wl:signal-add (wlr:event-signal surface wlr:surface :map) map)
    (wl:signal-add (wlr:event-signal surface wlr:surface :unmap) unmap)
    (wl:signal-add (wlr:event-signal surface wlr:surface :commit) commit)
    (wl:signal-add (wlr:event-signal xdg-toplevel wlr:xdg-toplevel :destroy) destroy)
    (wl:signal-add (wlr:event-signal xdg-toplevel wlr:xdg-toplevel :request-move) request-move)
    (wl:signal-add (wlr:event-signal xdg-toplevel wlr:xdg-toplevel :request-resize) request-resize)
    (wl:signal-add (wlr:event-signal xdg-toplevel wlr:xdg-toplevel :request-maximize) request-maximize)
    (wl:signal-add (wlr:event-signal xdg-toplevel wlr:xdg-toplevel :request-fullscreen) request-fullscreen)
    (push toplevel *toplevels*)))

(cffi:defcallback xdg-popup-commit :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (format t "XDG popup committed~%")
  (let ((popup (find-if (lambda (p) (cffi:pointer-eq (popup-commit p) listener)) *popups*)))
    (when popup
      (let* ((base (wlr:xdg-popup-base (popup-xdg-popup popup))))
        (when (wlr:xdg-surface-initial-commit base)
          (wlr:xdg-surface-schedule-configure base))))))

(cffi:defcallback xdg-popup-destroy :void ((listener :pointer) (data :pointer))
  (declare (ignore data))
  (format t "XDG popup destroyed~%")
  (let* ((popup (find-if (lambda (p) (cffi:pointer-eq (popup-destroy p) listener)) *popups*)))
    (when popup
      (setf *popups* (remove popup *popups*))
      (wl:list-remove (wl:listener-link (popup-commit popup)))
      (wl:list-remove (wl:listener-link (popup-destroy popup))))))

(cffi:defcallback server-new-xdg-popup :void ((listener :pointer) (xdg-popup :pointer))
  (declare (ignore listener))
  (format t "New XDG popup created~%")
  (let ((parent (wlr:xdg-surface-try-from-wlr-surface (wlr:xdg-popup-parent xdg-popup))))
    (assert (not (cffi:null-pointer-p parent)))
    (let* ((parent-tree (wlr:xdg-surface-data parent))
           (base (wlr:xdg-popup-base xdg-popup))
           (commit (cffi:foreign-alloc '(:struct wl:listener)))
           (destroy (cffi:foreign-alloc '(:struct wl:listener)))
           (popup (make-popup :xdg-popup xdg-popup
                              :commit commit
                              :destroy destroy)))
      (setf (wlr:xdg-surface-data base) (wlr:scene-xdg-surface-create parent-tree base))
      (setf (wl:listener-notify commit) (cffi:callback xdg-popup-commit)
            (wl:listener-notify destroy) (cffi:callback xdg-popup-destroy))
      (wl:signal-add (wlr:event-signal (wlr:xdg-surface-surface base) wlr:surface :commit)
                     commit)
      (wl:signal-add (wlr:event-signal xdg-popup wlr:xdg-popup :destroy) destroy)
      (push popup *popups*))))

(defun main (&optional startup-cmd)
  (setf *display* (wl:display-create))
  (when (cffi:null-pointer-p *display*)
    (error "Failed to create Wayland display"))
  (setf *backend* (wlr:backend-autocreate (wl:display-get-event-loop *display*)
                                          (cffi:null-pointer)))
  (when (cffi:null-pointer-p *backend*)
    (error "Failed to create wlr_backend"))
  (setf *renderer* (wlr:renderer-autocreate *backend*))
  (when (cffi:null-pointer-p *renderer*)
    (error "Failed to create wlr_renderer"))
  (wlr:renderer-init-wl-display *renderer* *display*)
  (setf *allocator* (wlr:allocator-autocreate *backend* *renderer*))
  (when (cffi:null-pointer-p *allocator*)
    (error "Failed to create wlr_allocator"))
  (wlr:compositor-create *display* 5 *renderer*)
  (wlr:subcompositor-create *display*)
  (wlr:data-device-manager-create *display*)

  (setf *output-layout* (wlr:output-layout-create *display*))
  (setf *new-output-listener* (cffi:foreign-alloc '(:struct wl:listener)))
  (setf (wl:listener-notify *new-output-listener*) (cffi:callback server-new-output))
  (wl:signal-add (wlr:event-signal *backend* wlr:backend :new-output)
                 *new-output-listener*)

  (setf *scene* (wlr:scene-create))
  (setf *scene-layout* (wlr:scene-attach-output-layout *scene* *output-layout*))

  (setf *xdg-shell* (wlr:xdg-shell-create *display* 3))
  (setf *new-xdg-toplevel* (cffi:foreign-alloc '(:struct wl:listener))
        *new-xdg-popup* (cffi:foreign-alloc '(:struct wl:listener)))
  (setf (wl:listener-notify *new-xdg-toplevel*) (cffi:callback server-new-xdg-toplevel)
        (wl:listener-notify *new-xdg-popup*) (cffi:callback server-new-xdg-popup))
  (wl:signal-add (wlr:event-signal *xdg-shell* wlr:xdg-shell :new-toplevel)
                 *new-xdg-toplevel*)
  (wl:signal-add (wlr:event-signal *xdg-shell* wlr:xdg-shell :new-popup)
                 *new-xdg-popup*)

  (setf *cursor* (wlr:cursor-create))
  (wlr:cursor-attach-output-layout *cursor* *output-layout*)
  (setf *cursor-manager* (wlr:xcursor-manager-create (cffi:null-pointer) 24))

  (setf *cursor-motion* (cffi:foreign-alloc '(:struct wl:listener))
        *cursor-motion-absolute* (cffi:foreign-alloc '(:struct wl:listener))
        *cursor-button* (cffi:foreign-alloc '(:struct wl:listener))
        *cursor-axis* (cffi:foreign-alloc '(:struct wl:listener))
        *cursor-frame* (cffi:foreign-alloc '(:struct wl:listener)))
  (setf (wl:listener-notify *cursor-motion*) (cffi:callback server-cursor-motion)
        (wl:listener-notify *cursor-motion-absolute*) (cffi:callback server-cursor-motion-absolute)
        (wl:listener-notify *cursor-button*) (cffi:callback server-cursor-button)
        (wl:listener-notify *cursor-axis*) (cffi:callback server-cursor-axis)
        (wl:listener-notify *cursor-frame*) (cffi:callback server-cursor-frame))
  (wl:signal-add (wlr:event-signal *cursor* wlr:cursor :motion)
                 *cursor-motion*)
  (wl:signal-add (wlr:event-signal *cursor* wlr:cursor :motion-absolute)
                 *cursor-motion-absolute*)
  (wl:signal-add (wlr:event-signal *cursor* wlr:cursor :button)
                 *cursor-button*)
  (wl:signal-add (wlr:event-signal *cursor* wlr:cursor :axis)
                 *cursor-axis*)
  (wl:signal-add (wlr:event-signal *cursor* wlr:cursor :frame)
                 *cursor-frame*)

  (setf *new-input-listener* (cffi:foreign-alloc '(:struct wl:listener)))
  (setf (wl:listener-notify *new-input-listener*) (cffi:callback server-new-input))
  (wl:signal-add (wlr:event-signal *backend* wlr:backend :new-input)
                 *new-input-listener*)
  (setf *seat* (wlr:seat-create *display* "seat0"))
  (setf *request-set-cursor-listener* (cffi:foreign-alloc '(:struct wl:listener))
        *request-set-selection-listener* (cffi:foreign-alloc '(:struct wl:listener)))
  (setf (wl:listener-notify *request-set-cursor-listener*) (cffi:callback seat-request-set-cursor)
        (wl:listener-notify *request-set-selection-listener*) (cffi:callback seat-request-set-selection))
  (wl:signal-add (wlr:event-signal *seat* wlr:seat :request-set-cursor)
                 *request-set-cursor-listener*)
  (wl:signal-add (wlr:event-signal *seat* wlr:seat :request-set-selection)
                 *request-set-selection-listener*)

  (let ((socket (wl:display-add-socket-auto *display*)))
    (unless socket
      (error "Failed to add socket to Wayland display"))
    (format t "Wayland socket: ~a~%" socket)

    (unless (wlr:backend-start *backend*)
      (error "Failed to start backend"))

    (sb-posix:setenv "WAYLAND_DISPLAY" socket 1)
    (format t "Running Wayland compositor on WAYLAND_DISPLAY=~A~%" socket)
    (when startup-cmd
      (format t "Running startup command: ~a~%" startup-cmd)
      (uiop:launch-program (list "/bin/sh" "-c" startup-cmd)))
    (format t "Entering main event loop~%")
    (wl:display-run *display*))

  ;; Cleanup - matching C version structure
  (wl:display-destroy-clients *display*)
  ;; Note: Not freeing listeners - they will leak but program is exiting anyway
  (wlr:scene-node-destroy (wlr:scene-tree-node (wlr:scene-tree *scene*)))
  (wlr:xcursor-manager-destroy *cursor-manager*)
  (wlr:cursor-destroy *cursor*)
  (wlr:allocator-destroy *allocator*)
  (wlr:renderer-destroy *renderer*)
  (wlr:backend-destroy *backend*)
  (wl:display-destroy *display*))

(export 'main)
