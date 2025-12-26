	.file	"template.c"
/--------------------------------------------------------------
/	TALKER PROGRAM for FORTH  derived from "C" template
/	The concepts and impregnation methods embodied in this
/	program are the sole intellectual property of ATHENA
/	Programming, Inc.
/--------------------------------------------------------------
/
	.version	"01.01"
	.ident	"@(#)head:stdio.h	2.34.1.2"
	.ident	"@(#)head:fcntl.h	1.6.1.7"
	.ident	"@(#)head.sys:types.h	1.5.8.1"
	.ident	"@(#)head.sys:select.h	1.1.1.1"
	.ident	"@(#)head.sys:fcntl.h	1.3.8.1"
	.text
	.globl	main
	.align	4
main:
	movl	%eax,.Reg		# record entry registers.
	movl	%ecx,.Reg+4
	movl	%edx,.Reg+8
	movl	%ebx,.Reg+12
	movl	%esp,.Reg+16
	movl	%ebp,.Reg+20
	movl	%esi,.Reg+24
	movl	%edi,.Reg+28
/
	jmp	.L76
.L75:
	.data
	.local	.X63			# ram array
	.comm	.X63,2097152,1
	.align	4
.Han:					# Handle table
	.long	.Lcl
	.long	.Reg
	.long	.Ptr
	.long	GREG			# c-include value table
	.long	errno
.Lcl:					# Local pointer table
	.long	main
	.long	.X63  # ram
	.long	.Fid
.Reg:					# Register table (0..7)
	.zero	32
.Ptr:					# Remote pointer table
	.long	open			# Group used in nucleus:
	.long	close
	.long	read
	.long	write
	.long	lseek
/	------------------	Below used only in 9-LOAD:
	.long	time
	.long	times
	.long	mlockall
	.long	munlockall
	.long	getpid
	.long	sigemptyset
	.long	sigfillset
	.long	sigaddset
	.long	sigaction
	.long	sigaltstack
	.long	sigpending
	.long	sigprocmask
	.long	sigsuspend
	.long	kill
	.long	shmget
	.long	shmat
	.long	shmdt
	.long	shmctl
.X64:					# file id
.Fid:
	.long	0
.X65:					# lng actually i/o result
.Lng:
	.long	0
.X66:					# i/o buffer
.Buf:
	.byte	0
	.zero	7
.Msg:					# long message input buffer.
	.byte	0
	.zero	7
	.text
/
/-----	Clear RAM.
/
	movl	$1,%edi
/LOOP	BEG
	jmp	.L70
/LOOP	HDR
.L67:
	movb	$0,.X63(%edi)
	incl	%edi
.L70:
/LOOP	COND
	cmpl	$2097152,%edi
	jl	.L67
/LOOP	END
/
/-----	Conditionally open talker tube in 2nd arg.
/
	movl	12(%ebp),%edx
	movl	8(%edx),%eax		# adr of 2nd string arg.
	cmpb	$45,0(%eax)		# skip if 1st char "-"
	je	.Mode
	pushl	$2
	pushl	%eax
	call	open
	addl	$8,%esp
	movl	%eax,.X64
/
/-----  Check 1st arg which is mode.
/
.Mode:	movl	12(%ebp),%edx
	movl	4(%edx),%eax		# adr of 1st arg string.
	cmpb	$98,0(%eax)		# if ist char is "b"
	jne	.Notb			#   we boot from it...
	pushl	$0			# read only
	pushl	12(%edx)
	call	open
	addl	$8,%esp
	movl	%eax,.Lng
	pushl	$32768			# read nucleus
	pushl	$.X63+1024
	pushl	%eax
	call	read
	addl	$12,%esp
	pushl	.Lng			# close file
	call	close
	popl	%ecx
	jmp	.Run			# KLUDGE should be .Run!
/
.Notb:	cmpb	$116,0(%eax)		# if 1st char is "t"
	je	.Talk			#   we talk.
	jmp	.Done			# Don't know what the bozo wants.
/
/-----	Talker main loop.
/
.Talk:
	call	.Get1
	cmpl	$0,%eax
	jne	.is1
	jmp	.Done			# 00 = Terminate talker.
.is1:	cmpl	$1,%eax
	jne	.is2
	movl	$.Han,.Buf		# 01 - adr = Rqst adr of handle table.
.Snd4:	movl	$4,%eax			# Exit w/4-byte msg.
	call	.Putn
	jmp	.Talk
/
.is2:	cmpl	$2,%eax
	jne	.is3
	movl	$4,%ecx			# 02 adr - cel = Fetch a cell.
	call	.Getn
	movl	.Msg,%edx
	movl	0(%edx),%eax
	movl	%eax,.Buf
	jmp	.Snd4
/
.is3:	cmpl	$3,%eax
	jne	.is4
	movl	$8,%ecx			# 03 adr cel - xx = Store a cell.
	call	.Getn
	movl	.Msg,%edx
	movl	.Msg+4,%eax
	movl	%eax,0(%edx)
.Ack:	movl	$1,%eax
	call	.Putn
	jmp	.Talk
/
.is4:	cmpl	$4,%eax
	jne	.is5
	movl	$4,%ecx			# 04 adr = Call code.
	call	.Getn
	movl	.Msg,%edx
.Run:	movl	$.Han,%eax
	call	.X63+1024+8	# kludge; call nuc entry; call %edx errors out.
/-----	missing code to consider type of return

	cmpl	$0,%eax		# return code 0 means
	je	.Done		#   end execution of talker.
	jmp	.Talk
/
.is5:	cmpl	$5,%eax
	jmp	.Talk
/
/-----	Subroutine to get one char; returned in eax.
/
.Get1:
	pushl	$1
	pushl	$.X66
	pushl	.X64
	call	read
	addl	$12,%esp
	movl	%eax,.X65
	movzbl	.X66,%eax
	ret
/
/-----	Subroutine to get n(ecx) chars to .Msg
/
.Getn:	movl	$.Msg,%edx
.Gt1:	pushl	%ecx
	pushl	%edx
	call	.Get1
	popl	%edx
	popl	%ecx
	movb	%al,0(%edx)
	incl	%edx
	loop	.Gt1
	ret
/
/-----	Subroutine to write buffer; lng in eax.
/
.Putn:
	pushl	%eax
	pushl	$.X66
	pushl	.X64
	call	write
	addl	$12,%esp
	movl	%eax,.X65
	ret
/
/-----	Close files and exit.
/
.Done:
	pushl	.X64
	call	close
	popl	%ecx
	movl	%eax,.X65
/REGAL	0	STATLOC	.X65	4
/REGAL	0	STATLOC	.X64	4
/REGAL	0	PARAM	12(%ebp)	4
/REGAL	0	PARAM	8(%ebp)	4
.L74:
	popl	%edi
	leave
	ret						#0
.L76:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%edi
	jmp	.L75
	.type	main,@function
	.size	main,.-main
	.ident	"acomp: (SCDE) 5.0  04/19/90"
/REGAL	0	EXTERN	_lastbuf	4
