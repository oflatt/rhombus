#lang racket/base
(provide set-primitive-contract!
         set-primitive-contract-combinator!
         set-primitive-subcontract!
         get-primitive-contract
         set-primitive-who!
         get-primitive-who)

(define primitive-contract-table (make-hash))

(define primitive-contract-combinator-table (make-hash))

(define primitive-subcontract-table (make-hash))

(define primitive-who-table (make-hasheq))

(define (set-primitive-contract! contract/rkt contract/rhm)
  (hash-set! primitive-contract-table contract/rkt contract/rhm))

(define (set-primitive-contract-combinator! head handler)
  (hash-set! primitive-contract-combinator-table head handler))

(define (set-primitive-subcontract! contracts/rkt contract/rkt)
  (hash-set! primitive-subcontract-table contracts/rkt contract/rkt))

(define (handle-and/c form)
  (cond
    [(and (list? (cdr form))
          (hash-ref primitive-subcontract-table (cdr form) #f))
     => (lambda (contract/rkt)
          (hash-ref primitive-contract-table contract/rkt #f))]
    [else #f]))

(void (set-primitive-contract-combinator! 'and/c handle-and/c))

(define (get-primitive-contract contract/rkt)
  (cond
    [(and (pair? contract/rkt)
          (hash-ref primitive-contract-combinator-table (car contract/rkt) #f))
     => (lambda (handler)
          (handler contract/rkt))]
    [else (hash-ref primitive-contract-table contract/rkt #f)]))

(define (set-primitive-who! who/rkt who/rhm)
  (hash-set! primitive-who-table who/rkt who/rhm))

(define (get-primitive-who who/rkt)
  (hash-ref primitive-who-table who/rkt #f))