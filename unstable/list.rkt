#lang racket/base
(require racket/contract/base
         racket/dict
         racket/list
         (for-syntax racket/base))

;; re-export some things from racket/list, for backwards compatibility
(provide (rename-out [check-duplicates check-duplicate])
         group-by
         cartesian-product
         list-update
         list-set
         list-prefix?
         split-common-prefix
         take-common-prefix
         drop-common-prefix
         remf)

(define (filter-multiple l . fs)
  (apply values
         (map (lambda (f) (filter f l)) fs)))

;; Listof[A] Listof[B] B -> Listof[B]
;; pads out t to be as long as s
(define (extend s t extra)
  (append t (build-list (max 0 (- (length s) (length t))) (lambda _ extra))))

(provide filter-multiple extend)

;; sam added from carl

(define-syntax (values->list stx)
  (syntax-case stx ()
    [(vl expr)
     (syntax/loc stx
       (call-with-values (lambda () expr) list))]))

(define (map/list n f ls)
  (cond
   [(andmap null? ls) (build-list n (lambda (i) null))]
   [(andmap pair? ls)
    (let* ([vs (values->list (apply f (map car ls)))]
           [k (length vs)])
      (unless (= k n)
        (error 'map/values
               "~a produced ~a values, not ~a: ~e"
               f k n vs))
      (map cons vs (map/list n f (map cdr ls))))]
   [else (error 'map/values "list lengths differ")]))

(define (map/values n f . ls)
  (apply values (map/list n f ls)))

(define (map2 f . ls)
  (apply values (map/list 2 f ls)))

(provide map2 map/values)

;; Alex Knauth added:

;; curried version of map
(define ((mapper f) lst1 . lsts)
  (apply map f lst1 lsts))

(provide mapper)
