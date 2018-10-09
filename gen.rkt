#lang typed/racket


(: gen-random-string (-> Integer
                         String))
(define (gen-random-string n)
  (string-join
   (for/list : (Listof String) ([x n])
     (number->string (random 1 10)))
   ""))


(: print-random-strings (-> Integer
                            Integer
                            Void))
(define (print-random-strings nl ns)
  (let ([hash : (Mutable-HashTable String True) (make-hash)])
    (for ([x nl])
      (let looper ([str (gen-random-string ns)])
        (if (hash-has-key? hash str)
            (begin
              (looper (gen-random-string ns))
              (displayln (format "DUP - ~a" str)
                         (current-error-port)))
            (begin
              (hash-set! hash str #t)
              (displayln str)))))))

(: string->integer (-> String Integer))
(define (string->integer s)
  (let ([n (string->number s)])
    (exact-round (real-part (if n n 0)))))

(define (-main)
  (let ([cargs (current-command-line-arguments)]
        [limit 1000]
        [slen 7])
    (if (= (vector-length cargs) 2)
        (let ([nlimit (string->integer (vector-ref cargs 0))]
              [nslen (string->integer (vector-ref cargs 1))])
          (print-random-strings (if (not nlimit)
                                    limit
                                    nlimit)
                                (if (not nslen)
                                    slen
                                    nslen)))
        (print-random-strings limit slen))))


(-main)
