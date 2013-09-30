(load "~/quicklisp/setup.lisp")
;(ql:quickload "cl-ppcre")

(defpackage :hangman 
  (:use :common-lisp
        :common-lisp-user))

(in-package :hangman)
(export '(load-words
           most-likely-to-be all-true match-pattern))

(defun load-words (path) 
  (let ((word-repo nil))
    (progn (with-open-file (words (make-pathname :name path) :direction :input )
             (do 
               ((i 0 (+ i 1))
                (word (read-line words nil 'eof) (read-line words nil 'eof)))
               ((eql word 'eof))
               (push word  word-repo)))
           word-repo)))

(defun match-pattern (pattern str)
  (if (/= (length pattern) (length str))
    nil
    (all-true (mapcar 
                (lambda (x y) 
                  (or (char= x #\.) (char-equal x y)))
                (coerce pattern 'list) 
                (coerce str 'list)))))

(defun all-true (lst)
  (let ((re t))
    (progn (loop for i in lst do
                 (if (null i)
                   (setf re nil)))
           re)))



(defun filter-all (candidates pattern)
  (remove-if-not 
    (lambda (c) 
      (if (match-pattern pattern c)
        t
        nil))
    (remove-if-not 
      (lambda (c) 
        (= (length c) (length pattern))) 
      candidates)) )

(defun hash-table-to-list (table)
  (let ((alist nil))
    (maphash (lambda (k v)
               (push (cons k v) alist))
             table)
    alist))

(defun sorted-hash-table (table)
  (sort (hash-table-to-list table) #'> :key #'cdr ))

(defun all-letter-rates (candidates tested) 
  (let ((repo (make-hash-table)))
    (progn

      ;(format t "haha : ~a" (length candidates))
      (if (> (length candidates) 0)
        (mapcar 
          (lambda (c)
            (progn 
              ;(format t "~a~%" c)
              (loop for ch across c  do
                    (progn 
                      ;(format t "~a " ch)
                      (if (and ch (null (find ch tested :test #'equalp)))
                        (if (gethash ch repo)
                          (incf (gethash ch repo) )
                          (setf (gethash ch repo) 1)))))
              )
            )
          candidates))
      ;(format t "haha sdfsdf: ~a" (length candidates))

      ;(maphash (lambda (k v) (format t "[ ~a:~a] ~%" k v) ) repo) 
      (loop for item in tested do (remhash item repo))
      repo)))

(defun most-likely-to-be-2 (candidates pattern tested)
  (let* ((rate-list (sorted-hash-table (all-letter-rates (filter-all candidates pattern) tested)))    
         (filter-rate-list 
           (remove-if 
             (lambda (i)
               (progn 
                 ;(format t "tested : ~a ~% ~a ~%" tested i) 
                 (numberp (position (car i) tested))))
             rate-list)))
    (car 
      (nth (if (null filter-rate-list)
             0                    
             1)
           ;(cond ((> (length filter-rate-list) 2) (random 3)) 
           ;     (t 1))) 
           filter-rate-list))))

(defun most-likely-to-be (candidates pattern tested) 
  (let ((top 0) (letter nil)) 
    (progn
      ;(format t "tested: ~a ~% candidates: ~a~% " tested (length candidates))
      (maphash 
        (lambda(k v)
          (progn 
            ;(format t "aaaaaaaaaaaaaaaaaaaa[~a:~a] ~%" k v)
            (if (and (null (find k tested :test #'equalp)) (> v top)) 
              (setf top v letter k)))) 
        (all-letter-rates (filter-all candidates pattern) tested))
      letter)))

(defun filter-exclude-letter (words letter)
  (remove-if
    (lambda(w)(find letter w :test #'equalp))
    words))
