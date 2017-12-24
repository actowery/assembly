TITLE PROGRAM 4     (program4.asm)

; Author: Cihan Towery
; Date: 08 May 2017
; Description: Write a program to calculate composite numbers. 
;First, the user is instructed to enter the number of composites 
;to be displayed, and is prompted to enter an integer in the range 
;[1 .. 400]. The user enters a number, n, and the program verifies 
;that 1 ≤ n ≤ 400. If n is out of range, the user is re-prompted until 
;s/he enters a value in the specified range. The program then calculates 
;and displays all of the composite numbers up to and including the nth 
;composite. 

INCLUDE Irvine32.inc

; Constants here are used for limits of user entry
LOWER_LIMIT = 1
UPPER_LIMIT = 400
MINIMUM_COMP = 4

.data

;variable definitions 
displaytitle		BYTE	"Welcome to the composite finder",0
displayname			BYTE	"Programmed by Cihan Adrian Towery",0
intro				BYTE	"This program identifies composite numbers within a range [1-400].",0
prompt_1			BYTE	"What is your name? ",0
username			BYTE	33 DUP(0)
hello				BYTE	"Hello, ",0
goodbye				BYTE	"Thanks for using my program. Goodbye, ",0
spacing				BYTE	"     ",0
prompt_2			BYTE	"Enter a number between 1 and 400, inclusive. Any other entry will",0
prompt_3			BYTE	"error and ask you to try again. ",0
prompt_4			BYTE	"Enter number ",0
errormsg			BYTE	"Oops! Selection out of range!",0
onespace			BYTE	" ",0
twospace			BYTE	"  ",0
threespace			BYTE	"   ",0

;extra credit prompts (if any are left blank, I couldn't do them)
extra_1				BYTE	"EC**Organize the data neatly.",0
extra_2				BYTE	" ",0
extra_3				BYTE	" ",0

loopholder			DWORD	?
numentered			DWORD	?
rowcounter			DWORD	? ;to help organize the data
current				DWORD	0
foundacomp			DWORD	?

.code

main PROC
;main procedure mostly calls to other procedures
	call Introduction
	call GetName
	call Welcome
	call DispEC
	call GetUserData
	call ShowComposites
	call Farewell

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)
Introduction PROC
;title
	mov		edx, OFFSET displaytitle
	call	WriteString
	call	CrLf
	mov		edx, OFFSET displayname
	call	WriteString
	call	CrLf
	call	CrLf
	ret
Introduction ENDP

GetName PROC
;get user's name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET username
	mov		ecx, 32		;max characters accept 9 remember we did 33 zeroes up top
	call	ReadString	;this guarantees a 0 at the end
	ret
GetName ENDP

Welcome PROC
;greet user
	mov		edx, OFFSET hello
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	CrLf
	ret
Welcome ENDP

DispEC PROC
;Display EC for the user.
	mov		edx, OFFSET extra_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_2
	call	WriteString
	call	CrLf
	ret
DispEC ENDP

GetUserData PROC
;Display instructions for the user.
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_3
;	call	WriteString
	call Validate
	ret
GetUserData ENDP

Validate PROC
;validates integer entry based on limit set as constants
; check range 
	INPUTVALIDATION:
		mov edx, OFFSET prompt_4
		call WriteString
		call ReadInt
		mov numentered, eax
;if it first is lower than upper limit and then higer than lower limit do we skip to valid entry
;otherwise try again
		cmp numentered, UPPER_LIMIT
		jg INPUTISNOTVALID
		cmp numentered, LOWER_LIMIT
		jl INPUTISNOTVALID
		jmp INPUTISVALID

; fails validation check
	INPUTISNOTVALID:
		mov		edx,OFFSET errormsg
		mov		ebx,0                     
		call	MsgBox
		jmp		INPUTVALIDATION
;passes validation check		
	INPUTISVALID:
		ret
Validate ENDP

ShowComposites PROC
;finds all compsite numbers in range with loops
;initialize loop
	mov ecx, numentered
	COMPLOOP:
		call	IsComposite
		inc		current
		loop	COMPLOOP

	FINISHED:
		ret
ShowComposites ENDP
;checks to see a number i scomposite by looping through all possible divisors
;it then methodically looks for a zero remainder (not including from 1 or itself)
;within edx. if it finds one, we display that number and move on. If we do not, we simply move on
IsComposite PROC
	mov loopholder, ecx
	mov eax, current
	cmp eax, MINIMUM_COMP	;if its less than four it isnt composite
	jl	COMPLETE
	mov ecx, current
	LOOPTOFIND:
		cmp ecx,current ; if they are equal we are dividing by itself, skip
		je	NEXT
		cmp ecx,1		; at 1 we can stop and give up
		je	COMPLETE	
		mov eax, current
		CDQ
		div ecx
		cmp edx,0		;remainder zero means we got a hit! no need to keep going
		je GOTONE
		
	NEXT:
		loop LOOPTOFIND
;print out the composite
	GOTONE:		
		mov eax, current
		call WriteDec
;;all of this after here normalizes the whitespace to make the lines nice
		cmp		eax, 10
		jl		MAKETHREESPACE
		jge 	MAKETWOSPACE
	MAKETHREESPACE:
		mov edx, OFFSET threespace
		call WriteString
		jmp INCREASEROW
	MAKETWOSPACE:
		cmp		eax, 100
		jge 	MAKEONESPACE
		mov edx, OFFSET twospace
		call WriteString
		jmp INCREASEROW
	MAKEONESPACE:
		mov edx, OFFSET onespace
		call WriteString
	INCREASEROW:
		inc rowcounter
; calls to make the new line for oganization
		cmp rowcounter, 8
		jl COMPLETE
	MAKENEWLINE:
		call	CrLf
		mov		rowcounter, 0
	COMPLETE:
		mov ecx, loopholder
		ret
IsComposite ENDP


Farewell PROC
;a parting message (with the user’s name)
call	CrLf
mov		edx, OFFSET goodbye
call	WriteString
mov		edx, OFFSET username
call	WriteString
call	CrLf
ret
Farewell ENDP
END main
