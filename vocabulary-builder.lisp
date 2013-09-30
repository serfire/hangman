(defparameter *voca* nil)

(defun load-words (path) 
  (with-open-file (words (make-pathname :name path) :direction :input )
    (do 
      ((i 0 (+ i 1))
       (word (read-line words nil 'eof) (read-line words nil 'eof)))
      ((eql word 'eof))
      (pushnew word  *voca*  :test #'equal))))

(defun export-words (path)
  (with-open-file (words (make-pathname :name path) :direction :output)
    (loop for word in *voca* do
          (format words "~a~%" word))))
