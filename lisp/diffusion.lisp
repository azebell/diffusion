#!/usr/bin/sbcl --script

(defvar A)
(defvar M 10)

(setf A (make-array (list M M M)))

(dotimes(i M)
	(dotimes(j M)
		(dotimes(k M)
			(setf (aref A i j k) (list (* i j k)))
		)
	)
)

(dotimes(i M)
	(dotimes(j M)
		(dotimes(k M)
			(print (aref A i j k))
		)
	)
)

