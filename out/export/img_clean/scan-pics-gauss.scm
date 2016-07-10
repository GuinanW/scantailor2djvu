; применения выборочного размытия и levels к картинкам
; gimp -i -b "(scan-pics-gauss \"*.tif\")" -b "(gimp-quit 0)"

(define (scan-pics-gauss pattern)
(let* (
    (filelist (cadr (file-glob pattern 1)))
    (vresize 1500)
)

(while (not (null? filelist))
    (let* ((filename (car filelist))
        (image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
        (drawable (car (gimp-image-get-active-layer image)))
        (multiply-layer 0)
    )

    ;(plug-in-unsharp-mask RUN-NONINTERACTIVE image drawable 4 7 200)

    ;уровни
    (gimp-levels drawable 0 40 230 1.0 0 255)
    ;выборочное гауссово размытие
    (plug-in-sel-gauss RUN-NONINTERACTIVE image drawable 4 75)

    ;подчистка после размытия
    (gimp-levels drawable 0 0 250 1.0 0 255)

    ; автоконтраст
    ;(gimp-levels-stretch drawable)
    
    ; нерезкая маска
    (plug-in-unsharp-mask RUN-NONINTERACTIVE image drawable 5.0 0.5 0)

    (gimp-displays-flush)
    (set! drawable (car (gimp-image-get-active-layer image)))
    (file-tiff-save 1 image drawable filename filename 1)
    (gimp-image-delete image)

    )

    (set! filelist (cdr filelist))
)

)

)
