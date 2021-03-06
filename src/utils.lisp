
(defun 2* (l) (* l 2))

(defun 2+ (l) (+ l 2))

(defun half (l) (/ l 2))


(defmacro print-every (i n)
  `(if (= 0 (mod ,i ,n)) (print ,i)))


(defun make-dfloat-array (rows &key (cols 2) (initial 0.0d0))
  (make-array
    (list rows cols)
    :adjustable t
    :initial-element initial
    :element-type 'double-float ))


(defun make-int-array (rows  &key (cols 2) (initial 0))
  (make-array
    (list rows cols)
    :adjustable t
    :initial-element initial
    :element-type 'integer))


(defun to-int (x)
  (coerce x 'integer))

(defun to-int* (xx)
  (mapcar (lambda (x) (coerce x 'integer)) xx))

(defun to-dfloat (x)
  (coerce x 'double-float))

(defun to-dfloat* (xx)
  (mapcar (lambda (x) (coerce x 'double-float)) xx))


(defun x-or-large (x &optional (l 100000.0d0) (lim 0.00001d0))
  (if (> x lim) x l))


;http://cl-cookbook.sourceforge.net/os.html
(defun cmd-args ()
  (or #+SBCL *posix-argv*
      #+LISPWORKS system:*line-arguments-list*
      #+CMU extensions:*command-line-words*
       nil))


; below code is from from On Lisp by Paul Graham.
; http://ep.yimg.com/ty/cdn/paulgraham/onlisp.lisp

; This code is copyright 1993 by Paul Graham, but anyone who wants
; to use the code in any nonprofit activity, or distribute free
; verbatim copies (including this notice), is encouraged to do so.


(defun flatten (x)
  (labels ((rec (x acc)
             (cond ((null x) acc)
                   ((atom x) (cons x acc))
                   (t (rec (car x) (rec (cdr x) acc))))))
    (rec x nil)))


(defun group (source n)
  (if (zerop n) (error "zero length"))
  (labels ((rec (source acc)
             (let ((rest (nthcdr n source)))
               (if (consp rest)
                   (rec rest (cons (subseq source 0 n) acc))
                   (nreverse (cons source acc))))))
    (if source (rec source nil) nil)))


(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))


(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))


(defmacro with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (s) `(,s (gensym)))
                 syms)
     ,@body))


(defmacro mac (expr)
  `(pprint (macroexpand-1 ',expr)))


(defmacro with-struct ((name . fields) struct &body body)
  (let ((gs (gensym)))
    `(let ((,gs ,struct))
       (let ,(mapcar #'(lambda (f)
                         `(,f (,(symb name f) ,gs)))
                     fields)
         ,@body))))

