#!/bin/sh
#|-*- mode:lisp -*-|#
#|
exec ros -Q -- $0 "$@"
|#
(progn ;;init forms
  (ros:ensure-asdf)
  ;;#+quicklisp(ql:quickload '() :silent t)
  )

(defpackage :gen
  (:use :cl))
(in-package :gen)

(defun gen-random (n)
  (declare (integer n))
  (concatenate 'string
	       (loop for i from 1 to n
		  collect (digit-char (+ 1 (random 9))))))


(defun print-randoms (nl ns)
  (let ((hash (make-hash-table :test #'equal)))
    (dotimes (i nl)
	 (tagbody
	  generate
	    (let ((s (gen-random ns)))
	      (multiple-value-bind (v exists)
		  (gethash s hash)
		(if exists
		    (go generate)
		    (progn
		      (setf (gethash s hash) 1)
		      (format t "~A~%" s)))))))))


(defun main (&rest argv)
  (if (= (length argv) 2)
      (print-randoms (parse-integer (first argv))
		     (parse-integer (second argv)))
      (print-randoms 10 7)))
;;; vim: set ft=lisp lisp:
