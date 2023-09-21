;;  --------------------------
;;  This is my modified version of Zero Angel's xbindkeys configuration, which I originally found here:
;;  https://www.linuxquestions.org/questions/linux-desktop-74/%5Bxbindkeys%5D-advanced-mouse-binds-4175428297/#post4786821
;;  
;;
;;  I prefer to use the Right Mouse Button as the chord key, but doing so seems to create some kind of weird infinite loop.
;;  So I used ratbagctl to reprogram my Logitech G403's right mouse button from Button 3 to the unused Button 12. 
;;  (Actually, it's Button 8 in ratbagctl, but that seems to correspond to Button 12 in xbindkeys for some reason.)
;;  That is why button 12 is the chord key.
;;  
;;  Sometimes, it would still perform a normal right click when releasing the button, even when it already performed an "extra function."
;;  At first, I assumed I was letting my finger off the right mouse button just after (run-command) runs, but before (set! actionperformed 1) happens. 
;;  So I switched around (set! actionperformed 1) and (run-command), so that actionperformed gets set as early as possible.
;;  This seems to have helped slightly, but it still happens. 
;;  It turns out, this is a known problem with Logitech mice. They use cheap switches, which can register two clicks when you only clicked once.
;;
;;  https://github.com/silentJET85
;;  --------------------------





;;   Comments from the original script:
;;   ------------------------------------
;;   This configuration is guile based.
;;   http://www.gnu.org/software/guile/guile.html
;;   This config script is supposed to live in the homedirectory.
;;   Awesome script created by Zero Angel
;;   This couldnt have been possible without seeing Vee Lee's configuration file
;;   You'll need xdotool and xbindkeys with -guile support compiled for this to work (The Ubuntu xbindkeys will have this support by default).
;;   It assigns keybindings to the scroll wheel  on the fly when mouse modifier keys are pressed. Useful for mice with lots of buttons!
;;   v1.0 -- Shoulder button + scrollwheel bindings
;;   v1.1 -- Fixes some 'stuckness' problems with the modifer keys (ctrl, alt, shift)
;;   v1.2 -- Can trigger events properly if the modifier button is simply pressed and released by itself. Forcefully clears modifier keys when the shoulder buttons are depressed.
;;   ------------------------------------


(define actionperformed 0)

(define (first-binding)
    "First binding"
    ;; Right Mouse button, which has already been reprogrammed to be button 12
    (xbindkey-function '("b:12") b12-second-binding)
)


(define (reset-first-binding)
    "reset first binding"
    (ungrab-all-keys)
    (remove-all-keys)
    ;; Set Action Performed state back to 0
    (set! actionperformed 0)
    ;; Forcefully release all modifier keys!
    (run-command "xdotool keyup ctrl keyup alt keyup shift keyup super &")
    (first-binding)
    (grab-all-keys)
)



(define (b12-second-binding)
    "Right Mouse Button Extra Functions"
    (ungrab-all-keys)
    (remove-all-keys)

    
    
    ;; Scroll Up
    (xbindkey-function '("b:4")
        (lambda ()
            ;; Emulate Home key (scroll to top of page)
            (set! actionperformed 1)
            (run-command "xdotool key Home")
        )
    )
    
    
    ;; Scroll Down
    (xbindkey-function '("b:5")
        (lambda ()
            ;; Emulate End key (scroll to bottom of page)
            (set! actionperformed 1)
            (run-command "xdotool key End")
        )
    )


    ;; Back Button
    (xbindkey-function '("b:8")
        (lambda ()
            ;; Emulate CTRL W (close tab)
            (set! actionperformed 1)
            (run-command "xdotool keydown ctrl key w keyup ctrl")
        )
    )


    ;; Forward Button
    (xbindkey-function '("b:9")
        (lambda ()
            ;; Emulate CTRL T (new tab)
            (set! actionperformed 1)
            (run-command "xdotool keydown ctrl key t keyup ctrl")
        )
    )





    (xbindkey-function '(release "b:12") 
        (lambda ()
            ;; Perform Action if Button 12 is pressed and released by itself
            (if (= actionperformed 0)
                (run-command "xdotool click 3 &")
            )
            (reset-first-binding)
        )
    )
    
    (grab-all-keys)
    
)

;; (debug)
(first-binding)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End of xbindkeys configuration ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;























