#lang racket

(require net/http-client)
(require xml)
(require racket/gui)

(define (get-rss)
  (define-values (a b c) (http-sendrecv "musicforprogramming.net" "/rss.php"))
  c)

(define (xml-element in)
  (xml->xexpr (document-element
               (read-xml in))))

(define (extract-list doc tag)
  (filter (λ (e) (and (pair? e) (eq? (car e) tag))) doc))

(define (leaf-value lst)
  (third lst))

(define (all-items)
  (let* ([doc (xml-element (get-rss))]
         [channel (first (extract-list doc 'channel))]
         [items (extract-list channel 'item)]
         [required-data (map (λ (i)
                               (list (leaf-value (first (extract-list i 'title)))
                                     (leaf-value (first (extract-list i 'description)))
                                     (leaf-value (first (extract-list i 'guid))))) items)])
    (reverse required-data)))

(define (open-command)
  (match (system-type 'os)
    ('unix "xdg-open")
    ('windows "start ")
    ('macosx "open")
    (else "echo")))

(define (gui items)
  (define root (new frame%
                    [label "music_for_programming"]
                    [min-height 400]))
  (define root-panel (new horizontal-panel%
                          [parent root]))
  (define music-list (new list-box%
                          [label #f]
                          [parent root-panel]
                          [choices (map (λ (i) (first i)) items)]
                          [min-width 200]
                          [horiz-margin 8]
                          [vert-margin 8]))
  (define button-panel (new vertical-panel%
                            [parent root-panel]))
  (define play-button (new button%
                           [label "Play"]
                           [parent button-panel]
                           [min-width 60]
                           [callback (λ (e b)
                                       (let ([indices (send music-list get-selections)])
                                         (let ([data (list-ref items (first indices))])
                                           (displayln (format "Playing ~a (~a)" (first data) (second data)))
                                           (system (format "~a ~a"
                                                           (open-command)
                                                           (third data))))))]))
  (send root show #t))

(gui (all-items))

