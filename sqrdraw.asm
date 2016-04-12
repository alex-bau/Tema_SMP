; Programul printeaza patratele folosind Z,
; reseteaza totul folosind X si deplaseaza
; coordonatele cu WASD

;org 0x7C00
;bits 16  
        
     
mov bx, 160
mov si, 100           ; Coordonatele XY ale patratelului

s equ 10              ; Marginea patratului
t equ 10              ; Step-ul

jmp main  

main:   

    mov ah, 0
    mov al, 13h       ; Initializare grafica
    int 10h 
    jmp new_move      ; Se face jump si se asteapta primirea unei comenzi
                      ; Initializare variabile pentru printare sus
        
    print:
        mov cx, s   
        add cx, bx
        mov dx, si
        mov al, 1         ; Setare culoarea albastru

    up:
        mov ah, 0ch   ; printare pixel
        int 10h  
        dec cx        ; decrementare numar de pixeli de desenat
        cmp cx, bx    ; comparare pozitia de printare cu limita
        ja up         ; daca nu sunt identice se continua printul
        mov ah, 0ch 
        int 10h
                      ; Printare jos
        mov cx, s
        add cx, bx
        mov dx, s
        add dx, si
        mov al, 1  
    
    down:  
    
        mov ah, 0ch
        int 10h
        dec cx
        cmp cx, bx
        ja down
                      ; Printare stanga
        mov cx, 0
        add cx, bx
        mov dx, s
        add dx, si
        mov al, 1                                                             
    
    left:  
    
        mov ah, 0ch
        int 10h
        dec dx
        cmp dx, si
        ja left
                      ; Printare dreapta
        mov cx, s
        add cx, bx
        mov dx, s
        add dx, si
        mov al, 1

    right:
    
        mov ah, 0ch
        int 10h
        dec dx
        cmp dx, si
        ja right
        jmp walled
         
    new_move:
               
        mov ah,00     ; Se ia noua directie de mutare
        int 16h       ; Seteaza mod pentru keyboard input

        cmp al, 119   ; 'w' apasat
        je move_up    ; se muta coordonatele sus
        cmp al, 97    ; 'a' apasat
        je move_left  ; se muta coordonatele stanga   
        cmp al, 115   ; 's' apasat
        je move_down  ; se muta coordonatele jos
        cmp al, 100   ; 'd' apasat
        je move_right ; se muta coordonatele dreapta      
        cmp al, 122   ; 'z' apasat
        je print      ; se deseneaza patratul la noua coordonata
        cmp al, 120   ; 'x' apasat
        je main       ; se reseteaza totul
        jmp new_move  ; Daca mutarea nu merge se asteapta o noua comanda
    
    move_up:
        
        cmp si, 0     ; verificam daca se afla la una dintre limite
        je walled     ; invalid si face beep 
        sbb si, t     ; updatare pozitie
        jmp new_move  ; jump catre zona de update  
    
    move_left:
        
        cmp bx, 0     ; verificam daca se afla la una dintre limite
        je walled     ; invalid si face beep 
        sbb bx, t     ; updatare pozitie
        jmp new_move  ; jump catre zona de update
    
    move_down:
        
        cmp si, 180   ; verificam daca se afla la una dintre limite
        jae walled    ; invalid si face beep 
        add si, t     ; updatare pozitie
        jmp new_move  ; jump catre zona de update
    
    move_right: 
        
        cmp bx, 300   ; verificam daca se afla la una dintre limite
        jae walled    ; invalid si face beep 
        add bx, t     ; updatare pozitie
        jmp new_move  ; jump catre zona de update
        
    walled:           ; if squre unable to move, emit audio signal
        
        mov ah, 02    ; load beep
        mov dl, 07h
        int 21h       ; execute
        jmp new_move  ; wait for new move direction
        
ret              

;times   510 - ($-$$) db 0
;dw 0xAA55