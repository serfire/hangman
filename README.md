hangman
=======

To run this game, you should install a Implement of clisp, sbcl, for example.

this program depends on some third part source code, include

ST-JSON
CL-JSON
DRAKMA
QUICKLISP

QUICKLISP, a tool like the apt-get in ubuntu, could install other libraries automatically. So you should install it at first.

To install QUICKLISP, you could run the install.lisp.

Finally, you can run this program in sbcl:
  (load "word-guess.lisp")
  (load "hangman.lisp")

then, run the function (hangman:play-game)

this game need a vocabulary repository, you can maintain it by vocabulary-builder.lisp

there are two useful function:
  
  (load-words path) is to load a vocabulary repository file, that contains a vocabulary in single line.

  (export-words path) is to export conbined vocabulary repository to a file. you should rename the exported file to "voc.txt" finally, that is used in our game.
