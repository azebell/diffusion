#!/usr/bin/sbcl --script

(defvar C 1d21)
(defvar L 5d0)
(defvar u 250d0)
(defvar Dif 0.175d0)
(defvar M 10)
(defvar partition t)


(defvar A)
(setf A (make-array (list M M M) :element-type 'double-float))


; if there is a partition
; assign -1 to the blocks that
; serve as the barrier
(when partition 
	(dotimes(i M)
		(dotimes(j M)
			(dotimes(k M)
				(when (and (= i (floor (/ (- M 1) 2))) (>= J (floor (/ (- M 1) 2))))
					(format t "~d~%" (aref A i j k))
					(setf (aref A i j k) -1d0)
					(format t "~d~%" (aref A i j k))
				)
			)
		)
	)
)

; set the starting position of the
; concentration of particles
(setf (aref A 0 0 0) C)

(defvar tstep (/ L (* u M)))
(defvar tacc 0.0d0)

; dTerm is the factor used when moving particles from 
; one cube to another
; dTerm = D * tstep / h^2
(defvar dTerm (/ (* Dif tstep) (expt (/ L M) 2)))
(defvar dc 0.0d0)

(format t "C = ~d~%" C)
(format t "L = ~d~%" L)
(format t "u = ~d~%" u)
(format t "D = ~d~%" Dif)
(format t "M = ~d~%" M)
(format t "tstep = ~d~%" tstep)
(format t "dTerm = ~d~%" dTerm)

(defvar maxval (aref A 0 0 0))
(defvar minval (aref A (- M 1) (- M 1) (- M 1)))
(format t "max = ~d~%" maxval)
(format t "min = ~d~%" minval)


; for each block in the room,
; move particles between adjacent blocks
; that have a common face
; until the room has equilibrated
(loop 
	(setf tacc (+ tacc tstep))
	(dotimes(i M)
		(dotimes(j M)
			(dotimes(k M)
				(when (< (+ i 1) M)
					(setf dc (* dTerm (- (aref A (+ i 1) j k) (aref A i j k))))
					(setf (aref A i j k) (+ (aref A i j k) dc))
					(setf (aref A (+ i 1) j k) (- (aref A (+ i 1) j k) dc))
				)
				(when (< (+ j 1) M)
					(setf dc (* dTerm (- (aref A i (+ j 1) k) (aref A i j k))))
					(setf (aref A i j k) (+ (aref A i j k) dc))
					(setf (aref A i (+ j 1) k) (- (aref A i (+ j 1) k) dc))
				)
				(when (< (+ k 1) M)
					(setf dc (* dTerm (- (aref A i j (+ k 1)) (aref A i j k))))
					(setf (aref A i j k) (+ (aref A i j k) dc))
					(setf (aref A i j (+ k 1)) (- (aref A i j (+ k 1)) dc))
				)
				(when (>= (- i 1) 0)
					(setf dc (* dTerm (- (aref A (- i 1) j k) (aref A i j k))))
					(setf (aref A i j k) (+ (aref A i j k) dc))
					(setf (aref A (- i 1) j k) (- (aref A (- i 1) j k) dc))
				)
				(when (>= (- j 1) 0)
					(setf dc (* dTerm (- (aref A i (- j 1) k) (aref A i j k))))
					(setf (aref A i j k) (+ (aref A i j k) dc))
					(setf (aref A i (- j 1) k) (- (aref A i (- j 1) k) dc))
				)
				(when (>= (- k 1) 0)
					(setf dc (* dTerm (- (aref A i j (- k 1)) (aref A i j k))))
					(setf (aref A i j k) (+ (aref A i j k) dc))
					(setf (aref A i j (- k 1)) (- (aref A i j (- k 1)) dc))
				)
			)
		)
	)

	; update the max and min
	(setf maxval (aref A 0 0 0))
	(setf minval (aref A (- M 1) (- M 1) (- M 1)))
	(when (> (/ minval maxval) 0.99) (return))
)

(format t "~%")
(format t "tacc ~d seconds~%" tacc)
(format t "max = ~d~%" maxval)
(format t "min = ~d~%" minval)
(format t "~%")
