

.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib
include \masm32\include\user32.inc 
includelib \masm32\lib\user32.lib 
includelib \masm32\lib\Fpu.lib
include \masm32\include\Fpu.inc


.data

finalizandoprograma db "Finalizando o programa", 0ah, 0h
qntdnotaspergunta db "Quantas notas quer registrar?", 0ah, 0h
digitarnotas db "Qual nota voce deseja registrar?", 0ah, 0h
notanecessariaparapassarfinal db "Nota necessaria para passar na final", 0ah, 0h
perguntasequercontinuardigitando db "Deseja digitar novas nota? ('s' ou 'n')", 0ah, 0h
caractereinvalido db "Digite um caractere valido - digite ['s' ou 'n']", 0ah, 0h
perguntaresposta db 10 dup (?)
opsomar db " SOMA ", 0ah, 0h
opdividir db " MEDIA ", 0ah, 0h
pulalinha db " ", 0ah, 0h
aprovado db "Esta aprovado :)", 0ah, 0h
reprovado db "Reprovado :(", 0ah, 0h
finalsosa db "Esta na final", 0ah, 0h
Iqntdnotas dd ?
Snotassoma db 10 dup (?)
Fnotassoma real8 ?
set_e real8 7.0 
quatroso real8 4.0
qntddnotas db 10 dup (?)
notas db 10 dup (?)
notasfloat real8 ?
write_count db 5 dup (?)
notafinal real8 ?
i dd 0
zeroso real8 0.0
Fqntdnotas real8 ?
Fmedia real8 ?
Smedia db 10 dup (?)
cinquentoso real8 50.0
seisao real8 6.0
Fnotanafinal real8 ?
notanafinal db 10 dup (?)
Simcmp db "s"
Naocmp db "n"

.code
start:

mov i, 0
fld zeroso

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL


;Quantas avaliações?
;-------------------------------------------------------------------------------------------------
push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr qntdnotaspergunta, sizeof qntdnotaspergunta, addr write_count, NULL
;-------------------------------------------------------------------------------------------------




;Input inicial
;-------------------------------------------------------------------------------------------------
push STD_INPUT_HANDLE 
call GetStdHandle
invoke ReadConsole, eax, addr qntddnotas, sizeof qntddnotas, addr write_count, NULL
;-------------------------------------------------------------------------------------------------

;Tirar enter
;-------------------------------------------------------------------------------------------------
mov esi, offset qntddnotas 
proximo:
mov al, [esi] 
inc esi 
cmp al, 48 
jl terminar
cmp al, 58 ;40
jl proximo
terminar:
dec esi 
xor al, al 
mov [esi], al 
;-------------------------------------------------------------------------------------------------


;Transformar de String(quantidade de notas) para ponto flutuante, para dividir
;-------------------------------------------------------------------------------------------------
invoke StrToFloat, addr qntddnotas, addr Fqntdnotas
;-------------------------------------------------------------------------------------------------


;Transformar a quantidade de notas em inteiro
;-------------------------------------------------------------------------------------------------
invoke atodw, addr qntddnotas
;-------------------------------------------------------------------------------------------------

;Transferir eax para Iqntdnotes(nota convertida em inteiro), para fazer o compare
;-------------------------------------------------------------------------------------------------
mov Iqntdnotas, eax
;-------------------------------------------------------------------------------------------------


;Laco de somar notas
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
digitarNotas:


push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL


continuar:

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL




push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr digitarnotas, sizeof digitarnotas, addr write_count, NULL

push STD_INPUT_HANDLE 
call GetStdHandle
invoke ReadConsole, eax, addr notas, sizeof notas, addr write_count, NULL


mov esi, offset notas 
proximaozao:
mov al, [esi] 
inc esi 
cmp al, 46 
jl terminaraozao
cmp al, 58 ;40
jl proximaozao
terminaraozao:
dec esi 
xor al, al 
mov [esi], al 


invoke StrToFloat, addr notas, addr notasfloat

fld [notasfloat]
fadd

add i, 1

mov ebx, Iqntdnotas
cmp i, ebx
jl digitarNotas 
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------


;pular linha
;-------------------------------------------------------------------------------------------------
push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL
;-------------------------------------------------------------------------------------------------


;-------------------------------------------------------------------------------------------------
soma:
;-------------------------------------------------------------------------------------------------
push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL


fstp Fnotassoma
invoke FloatToStr,Fnotassoma, addr Snotassoma

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr Snotassoma, sizeof Snotassoma, addr write_count, NULL

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr opsomar, sizeof opsomar, addr write_count, NULL
;-------------------------------------------------------------------------------------------------

;pular linha
;-------------------------------------------------------------------------------------------------
push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL
;-------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------------
dividir:
;-------------------------------------------------------------------------------------------------
finit
fld [Fnotassoma]
fld [Fqntdnotas]
fdiv 
fstp Fmedia

invoke FloatToStr,Fmedia, addr Smedia

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr Smedia, sizeof Smedia, addr write_count, NULL 

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr opdividir, sizeof opdividir, addr write_count, NULL
;-------------------------------------------------------------------------------------------------

;pula linha
;-------------------------------------------------------------------------------------------------
push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL
;-------------------------------------------------------------------------------------------------


;testar se o aluno esta reprovado, aprovado ou na final
;-------------------------------------------------------------------------------------------------
finit
fld [Fmedia]
fcomp quatroso
fnstsw ax
sahf
jb reprovadao


finit
fld [Fmedia]
fcomp set_e
fnstsw ax
sahf
jae aprovadao
;-------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------------
Final:
push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr finalsosa, sizeof finalsosa, addr write_count, NULL

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL

finit
fld [Fmedia]
fld seisao
fmul
fld cinquentoso
fsub
fld quatroso
fdiv
fchs
fstp Fnotanafinal

invoke FloatToStr,Fnotanafinal, addr notanafinal

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr notanecessariaparapassarfinal, sizeof notanecessariaparapassarfinal, addr write_count, NULL

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL


push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr notanafinal, sizeof notanafinal, addr write_count, NULL


push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL


jmp perguntinha
;-------------------------------------------------------------------------------------------------


;-------------------------------------------------------------------------------------------------
aprovadao:
push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr aprovado, sizeof aprovado, addr write_count, NULL

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL

jmp perguntinha
;-------------------------------------------------------------------------------------------------


;-------------------------------------------------------------------------------------------------
reprovadao:
push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr reprovado, sizeof reprovado, addr write_count, NULL

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL

jmp perguntinha
;-------------------------------------------------------------------------------------------------


;pergunta se o usuario deseja continuar digitando mais notas
;-------------------------------------------------------------------------------------------------
perguntinha:

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr perguntasequercontinuardigitando, sizeof perguntasequercontinuardigitando, addr write_count, NULL


push STD_INPUT_HANDLE 
call GetStdHandle
invoke ReadConsole, eax, addr perguntaresposta, sizeof perguntaresposta, addr write_count, NULL

mov esi, offset notas 
proximao:
mov al, [esi] 
inc esi 
cmp al, 46 
jl terminarao
cmp al, 58 ;40
jl proximao
terminarao:
dec esi 
xor al, al 
mov [esi], al 


cmp perguntaresposta, "s"
je start

cmp perguntaresposta, "n"
je exit

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr caractereinvalido, sizeof caractereinvalido, addr write_count, NULL

jmp perguntinha
;-------------------------------------------------------------------------------------------------





exit:

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL

push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr finalizandoprograma, sizeof finalizandoprograma, addr write_count, NULL


push STD_OUTPUT_HANDLE
call GetStdHandle
invoke WriteConsole, eax, addr pulalinha, sizeof pulalinha, addr write_count, NULL

invoke ExitProcess, 0
end start