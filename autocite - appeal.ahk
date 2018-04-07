#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui,+AlwaysOnTop

; goal is to put in case info and automatically produce cite and then have citation for TOA put in afterwards.
; Send any questions, suggestions, or comments to (rsuriprog@gmail.com).

; start by bringing up text box to enter necessary info

MsgBox INSTRUCTIONS:`nPress Win+1 to enter case information, then Win+2 to paste citation into document.`n`nLast edited circa 2012 by a now-defunct law practice.  Citation style may be out-of-date or otherwise inaccurate. This program is only suggested for Ohio appellate-level case citations.`n`nIMPORTANT: Your cursor must be in a text field before pasting a citation or your computer will behave unpredictably.`n`nThis program may be distributed freely.`n`n.
 
Loop{
; this should clear all values.  Use ListVars to copy and paste new variables here.

	#1::
	CaseNo = 
	DistNo =
	FirstParty =  
	MainCitation =  
	Official =
	Pinpoint =
	Secondary =  
	SecondParty = 
	Supreme =  
	Unofficial = 
	Unpublished =
	WebciteNo1 =
	WebciteNo2 =
	Year =
	; ListVars


	Gui, Add, Checkbox, vWebcite, Click here if webcite (2002 or later);
	;Gui, Add, Checkbox, v2002, Click here if pre-2002 case ;
	Gui, Add, Checkbox, vUnpublished, Click here if unpublished (no official reporter) ;
	Gui, Add, Checkbox, vSupreme, Click here if Ohio Supreme Court ; 


	Gui, Add, Button, default, OK1  ; The label ButtonOK (if it exists) will be run when the button is pressed.
	Gui, Show,, Check all that apply
	return  ; End of auto-execute section. The script is idle until the user does something.

	GuiClose1:
	ButtonOK1:
	Gui, Submit  ; Save the input from the user to each control's associated variable.
	Gui, Destroy ; gets rid of window to prevent appearing again later and causing error.
Gui,+AlwaysOnTop
	Gui, Add, Text,, First Party:
	Gui, Add, Text,,  
	Gui, Add, Text,, Second Party:
	if Unpublished=0
	Gui, Add, Text,, Official Citation (e.g. "### Ohio App.3d ###"):
	if Webcite = 1
	{
		Gui, Add, Text,, Webcite:
	}
	if Unpublished = 1
	{
		Gui, Add, Text,, Case No. (omit district):
	}
	if (Webcite=0 or Unpublished=0)
	{
		Gui, Add, Text,, Unofficial/WL/Lexis citation(s) :
	}
	if (Supreme = 0)
	{
		Gui, Add, Text,, District (e.g. "8th"):
	}
	Gui, Add, Text,, Pinpoint (omit paragraph symbol): ; add paragraph symbol in actual cite later
	if (Webcite = 0 and Unpublished = 0)
	{
		Gui, Add, Text,, Year:
	}
	if Webcite = 0 
	{
		if Unpublished = 1
		{
			Gui, Add, Text,, Month (abr.) date and year:
		}
	}

	; Gui, Add, Text,, Type "clear" here to clear file:


	Gui, Add, Edit, vFirstParty ym  ; The ym option starts a new column of controls.
	Gui, Add, Text,, v.
	Gui, Add, Edit, vSecondParty ;
	if Unpublished = 0
	Gui, Add, Edit, vOfficial ;
	if Webcite = 1
	{
		Gui, Add, Edit, w40 vWebciteNo1 ;
		Gui, Add, Text, x+5, -Ohio-
		Gui, Add, Edit, x+5 w40 vWebciteNo2 ;
		
	}
	If Unpublished = 1
	{
		Gui, Add, Edit, xm+230 y+7 vCaseNo ;
	}
	if (Webcite=0 or Unpublished=0)
	{
		Gui, Add, Edit, xm+230 y+7 vUnofficial  ;
	}
	if (Supreme = 0)
12	{
		Gui, Add, Edit, vDistNo ;
	}
	Gui, Add, Edit, vPinpoint ;
	if Webcite = 0
	{
		Gui, Add, Edit, vYear ;
	}
	; Gui, Add, Edit, vDistNo ;

	Gui, Add, Button, default, OK2  ; The label ButtonOK (if it exists) will be run when the button is pressed.
	Gui, Show,, Enter info then press Win+2 to paste citation
	return  ; End of auto-execute section. The script is idle until the user does something.

	GuiClose2:
	ButtonOK2:
	Gui, Submit  ; Save the input from the user to each control's associated variable.
	Gui, Destroy ; allows multiple submissions, maybe

	; try to store citation info in a database somewhere if possible

	FileAppend, %FirstParty% %SecondParty% %MainCitation% %Secondary% %Pinpoint% %Year% %DistNo%, %A_WorkingDir%\cites\%FirstParty%.acf 
	; idea is to save each citation as its own file, then call those later

	; then bring up box to say to put cursor in spot, and type out citation
	return

	#2::
	KeyWait LWin ;
	KeyWait = ;

	Sleep 250 ; needed to allow win key to be release and avoid disaster
	Parties=%FirstParty%
	if SecondParty is not space
		Parties=%Parties% v. %SecondParty%
	SendInput ^i%Parties%^i
	if CaseNo is not space
	SendInput {,} %DistNo% Dist. No. %CaseNo%
	if Official is not space
	SendInput {,} %Official%
	if WebciteNo1 is space ; REMOVE FOR FIELD CITE
	{
		if Pinpoint is not space  
		{
			if Unpublished = 0
			{
				SendInput {,}{Space}%Pinpoint% 
			}
		}
	}
	if WebciteNo1 is not space
	SendInput {,} %WebciteNo1%-Ohio-%WebciteNo2%
	if Unofficial is not space
	SendInput {,} %Unofficial%
	if WebciteNo1 is space ; REMOVE FOR FIELD CITE
	{	
		if Pinpoint is not space
		{	
			if Unpublished = 1
			{
				SendInput {,} %Pinpoint%
			}
		}
	}
	if WebciteNo1 is not space ; REMOVE FOR FIELD CITE
	{
		if Pinpoint is not space
		{
			SendInput {,}{Space}{U+00B6}%Pinpoint%
		}
	}
	if DistNo is not space 
	{
		if Year is space
		{
			if CaseNo is space
			{
				SendInput {Space}(%DistNo% Dist.)
			}
		}
	}
	if Year is not space
	{
		if DistNo is not space
		{
			if CaseNo is space
			{
				SendInput {Space}(%DistNo% Dist. %Year%)
			}
			else
			{
				SendInput {Space}(%Year%)
			}
		}
		else
		{
			SendInput {Space}(%Year%)
		}
	}
	SendInput .


	; enter citation in field in word

	SendInput ^* ;this puts in symbol mode
	SendInput ^{F9}
	Sleep 100
	SendInput TA \l "
	SendInput ^i%FirstParty%^i
	if SecondParty is not space
		SendInput ^i{Space}v. %SecondParty%^i
	if CaseNo is not space
	SendInput {,} %DistNo% Dist. No. %CaseNo%
	if Official is not space
	SendInput {,} %Official%
	if WebciteNo is not space
	SendInput {,} %WebciteNo%
	if Unofficial is not space
	SendInput {,} %Unofficial%
	if DistNo is not space 
	{
		if Year is space
		{
			if CaseNo is space
			{
				SendInput {Space}(%DistNo% Dist.)
			}
		}
	}
	if Year is not space
	{
		if (DistNo is not space and CaseNo is space)
		{
			SendInput {Space}(%DistNo% Dist. %Year%)
		}
		else
		{
			SendInput {Space}(%Year%)
		}
	}
	SendInput .
	SendInput " \s "
	SendInput %FirstParty% 
	SendInput " \c 1 
	SendInput ^*

	; done
	return

}

;	Reload

