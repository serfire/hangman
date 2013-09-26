(ql:quickload :st-json)
(ql:quickload :cl-json)
(ql:quickload :drakma)

(defparameter *game-url* "http://strikingly-interview-test.herokuapp.com/guess/process")

(defvar *req* '((date . "20071001") (time . "00") (origin . "all")))

(format t "json:~S~%" (json:encode-json-to-string *req*))

(defparameter *user-id* nil)

(defparameter *secret* nil)

(defun request-json-string (&key action guess)
  (remove-if
    (lambda (entity)
      (null (cdr entity)))
    (list `("action" . ,action) `("guess" . ,guess) `("userId". ,*user-id*) `("secret" . ,*secret*))))



