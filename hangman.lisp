(ql:quickload :st-json)
(ql:quickload :cl-json)
(ql:quickload :drakma)

(load "word-guess.lisp")
(in-package :hangman)
(export  '(initite-game make-a-guess give-me-a-word play-game commit-result ))

(defparameter *game-url* "http://strikingly-interview-test.herokuapp.com/guess/process")

(defparameter *user-id* "shilei.wang.1981@gmail.com")

(defparameter *secret* nil)

(defun request-json-string (&key action guess)
  (let ((result (remove-if
                  (lambda (entity)
                    (null (cdr entity)))
                  (list `("action" . ,action) `("guess" . ,guess) `("userId". ,*user-id*) `("secret" . ,*secret*)))))
    (progn 
      ;(format t "~a ~%" result) 
      result)))

(defun retrieve (request) 
  (let ((stream (drakma:http-request *game-url* 
                                     :accept "application/json"
                                     :method :post
                                     :content-type "application/json"
                                     :external-format-in :utf-8
                                     :external-format-out :utf-8
                                     :content (json:encode-json-to-string request)
                                     :want-stream t)))
    (progn 
      (let ((re (st-json:read-json stream)))
        ;(progn 
        ; (format t "~a ~%" re))
        re))))

(defun get-test-result ()
  (retrieve (request-json-string :action "getTestResults")))

(defun initite-game ()
  (let ((response (retrieve (request-json-string :action "initiateGame"))))
    (if (= (st-json:getjso "status" response) 200)
      (setf *secret* (st-json:getjso "secret" response))
      nil)))

(defun give-me-a-word ()
  (let ((response (retrieve (request-json-string :action "nextWord"))))
    (parse-response-word response)))

(defun make-a-guess (guess)
  (if (null guess)
    nil
    (let ((response (retrieve (request-json-string :action "guessWord" :guess (char-upcase guess)))))
      (parse-response-word response))))

(defun commit-result ()
  (format t "~a~%"  (retrieve (request-json-string :action "submitTestResults"))))

(defun parse-response-word (response)
  (if (= (st-json:getjso "status" response) 200)
    (map 
      'string 
      (lambda (ch) 
        (if (char= ch #\*)
          #\.
          ch))
      (st-json:getjso "word" response)) 
    nil))  

;(defparameter *words* nil)

;(defun play-a-round (words pattern tested)
;  (progn 
;    (format t "pattern is ~a ~%" pattern)
;    (let* ((letter (most-likely-to-be words pattern tested))
;           (result (make-a-guess letter)))
;      (cond ((null result) (format t "guess failed: ~a~%" pattern))
;            ((null (find #\. result)) (format t "guess success ~a ~%" result))
;            (t (setf *words* (if (string= pattern result)
;                 (filter-exclude-letter words letter)
;                 words))))
;    (format t "pattern is ~a, result is ~a ~%" pattern result))))


(defun play-a-round ()
  (labels 
    ((play-round (words pattern tested)
       (if (> (length words) 0)
         (let* ((letter (most-likely-to-be words pattern tested)) (result (make-a-guess letter)))
           (cond ((null result) 
                  (progn 
                    (format t "[F]failed")
                    nil))
                 ((null (find #\. result)) 
                  (progn 
                    (format t "[S]~a~%" result)
                    result))
                 (t (play-round 
                      (if (string= pattern result)
                        (filter-exclude-letter words letter)
                        words) 
                      result (push letter tested))))))))
    (play-round (load-words "voc-combined.txt" ) (give-me-a-word) nil)))

(defun play-game()
  (progn 
    (initite-game)
    (loop for i from 0 to 81 do
          (play-a-round))
    (get-test-result)))




