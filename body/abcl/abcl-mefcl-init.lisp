
(in-package :cl-user)

(defpackage "INIT-TEMP" (:use :cl))

(in-package "INIT-TEMP")

(defun change-path (symbol abcl-base)
  ;; currently, the physical path of the source is #P"L:/abcl-src-1.1.1/src/org/armedbear/lisp/precompiler.lisp"
  (let (orig-source-path)
    (when (and
           (setq orig-source-path
                 (car (getf (symbol-plist symbol) 'SYSTEM::%SOURCE)))
           (string= "L" (pathname-device orig-source-path))
           (eq :absolute
               (first (pathname-directory orig-source-path)))
           (string= "abcl-src-1.1.1"
                    (second (pathname-directory orig-source-path))))
      (setf (car (getf (symbol-plist symbol) 'SYSTEM::%SOURCE))
            (make-pathname :defaults abcl-base
                           :directory (concatenate 'list
                                                   (pathname-directory abcl-base)
                                                   (copy-list (cddr (pathname-directory orig-source-path))))
                           :name (pathname-name orig-source-path)
                           :type (pathname-type orig-source-path)))))
  )

;; change the source localtions of all the symbols
(let ((abcl-base (make-pathname :name nil :type nil :defaults (merge-pathnames "../" (first (pathname-device extensions:*lisp-home*))))))
  (do-all-symbols (sym)
    (change-path sym abcl-base)))

(delete-package "INIT-TEMP")