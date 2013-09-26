(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre")
(defun load-words (path) 
  (let ((word-repo nil))
    (progn (with-open-file (words (make-pathname :name path) :direction :input )
             (do 
               ((i 0 (+ i 1))
                (word (read-line words nil 'eof) (read-line words nil 'eof)))
               ((eql word 'eof))
               (push (cons i word) word-repo)))
           word-repo)))

(defun filter-all (candidates pattern)
  (remove-if-not 
    (lambda (c) 
      (if (cl-ppcre:scan pattern (cdr c) :start 0 :end (- (length pattern) 2))
        t
        nil))
    (remove-if-not 
      (lambda (c) 
        (= (length (cdr c)) (-  (length pattern) 2))) 
      candidates)) )

(defun all-letter-rates (candidates) 
  (let ((repo (make-hash-table)))
    (progn
      (mapcar 
        (lambda (c)
          (progn (loop for ch across (cdr c) do
                       (if (gethash ch repo)
                         (incf (gethash ch repo) )
                         (setf (gethash ch repo) 1)))
                 (print  (cdr c)))
          )
        candidates)
      repo)))

(defun most-likely-to-be (candidates pattern) 
  (let ((top 0) (letter nil)) 
    (progn
      (maphash 
        (lambda(k v)
          (if (> v top) 
            (setf top v letter k))) 
        (all-letter-rates (filter-all candidates pattern)))
      letter)))
