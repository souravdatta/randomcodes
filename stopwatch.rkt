#lang racket

(require racket/gui)

(define (take-drop lst)
  (define (take-drop-aux slst result)
    (cond
      ((or (< (length slst) 2) (empty? slst)) result)
      (else (take-drop-aux (if (< (length slst) 2)
                               '()
                               (drop slst 2))
                           (cons
                            (take slst 2)
                            result)))))
  (reverse (take-drop-aux lst '())))

(struct timespans (ts))

(define (make-timespans)
  (timespans '()))

(define (add-span tm)
  (timespans (cons (current-milliseconds)
                   (timespans-ts tm))))

(define (duration tm)
  (let* ([diff-list (take-drop (timespans-ts tm))]
         [duration-list (map (λ (x) (apply - x)) diff-list)]
         [duration-sum (apply + duration-list)])
    duration-sum))

(define swatch (timespans '()))

(define (tick-timer!)
  (set! swatch (add-span swatch)))

(define (stop-timer!)
  (let ([dur (duration swatch)])
    (reset-timer!)
    dur))

(define (reset-timer!)
  (set! swatch (timespans '())))

(define (gui)
  (define state #f)
  (define root (new frame%
                    [label "Stopwatch"]
                    [min-width 300]))
  (define hpane (new vertical-panel%
                     [parent root]))
  (define dmessage (new message%
                        [label "####"]
                        [parent hpane]
                        [min-width 280]
                        [vert-margin 10]
                        [horiz-margin 10]))
  (define bpane (new horizontal-panel%
                     [parent hpane]
                     [min-height 80]))
  (define btn1 (new button%
                    [parent bpane]
                    [label "Start"]
                    [min-width 140]
                    [vert-margin 10]
                    [horiz-margin 10]
                    [callback (λ (x y)
                                (set! state (not state))
                                (send
                                 btn1
                                 set-label
                                 (if state "Pause" "Start"))
                                (when state
                                  (send dmessage set-label
                                      (format "~a" "####")))
                                (tick-timer!))]))
  (define btn2 (new button%
                    [parent bpane]
                    [label "Stop"]
                    [min-width 140]
                    [vert-margin 10]
                    [horiz-margin 10]
                    [callback (λ (x y)
                                (send btn1 set-label "Start")
                                (when state
                                  (tick-timer!))
                                (let ([d (stop-timer!)])
                                  (send dmessage set-label
                                      (format "~a ms ≈ ~a s"
                                              d
                                              (floor (/ d 1000.0)))))
                                (set! state #f))]))
  (send root show #t))

                    
 (gui)
 
