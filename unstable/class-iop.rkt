#lang racket/base

;; Re-exports from `racket/class/iop`, for backwards compatibility.
(require racket/class/iop)
(provide define-interface
         define-interface/dynamic
         send/i
         send*/i
         send/apply/i
         define/i
         init/i
         init-field/i
         init-private/i
         define-interface-expander)
