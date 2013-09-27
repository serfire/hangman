(ql:quickload :st-json)
(ql:quickload :cl-json)
(ql:quickload :drakma)

(in-package :hangman)

(export '(initite-game))

(defparameter *game-url* "http://strikingly-interview-test.herokuapp.com/guess/process")

(defparameter *user-id* "shilei.wang.1981@gmail.com")

(defparameter *secret* nil)

(defun request-json-string (&key action guess)
  (remove-if
    (lambda (entity)
      (null (cdr entity)))
    (list `("action" . ,action) `("guess" . ,guess) `("userId". ,*user-id*) `("secret" . ,*secret*))))

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
      (st-json:read-json stream))))

(defun initite-game ()
  (let ((response (retrieve (request-json-string :action "initiateGame"))))
    (if (= (st-json:getjso "status" response) 200)
      (setf *secret* (st-json:getjso "secret" response))
      nil)))

(defun give-me-a-word ()
  (let ((response (retrieve (request-json-string :action "nextWord"))))
    (parse-response-word response)))

(defun make-a-guess (guess)
  (let ((response (retrieve (request-json-string :action "guessWord" :guess guess))))
    (parse-response-word response)))

(defun parse-response-word (response)
  (if (= (st-json:getjso "status" response) 200)
    (concatenate 'string "\^" (map 
                                'string 
                                (lambda (ch) 
                                  (if (char= ch #\*)
                                    #\.
                                    ch))
                                (st-json:getjso "word" response)) "\$")
    nil))  


(defun play-a-round()
  nil)
