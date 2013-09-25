(load "regexp")
(defun load-words (path) 
  (let ((word-repo nil))
    (progn (with-open-file (words (make-pathname :name path) :direction :input )
             (do 
               ((i 0 (+ i 1))
                (word (read-line words nil 'eof) (read-line words nil 'eof)))
               ((eql word 'eof))
               (push (cons i word) word-repo)))
           word-repo)))

(defun filter-length (condidate pattern)
  (if (and condidate (= (length condidate)(- (length pattern) 2)))
    (list condidate pattern )
    (list nil pattern)))

(defun filter-pattern (condidate pattern)
  (if (regexp:match pattern condidate :start 0 :end (- (length pattern) 2))
    (list condidate pattern length)
    (list nil pattern length)))

(defun most-likely-to-be (candidates pattern)
  (remove-if-not 
    (lambda (c) 
      (if (regexp:match pattern (cadr c) :start 0 :end (- (length pattern) 2))
        t
        nil))
    (remove-if-not 
      (lambda (c) 
        (= (length (cadr c)) (length pattern))))) )
