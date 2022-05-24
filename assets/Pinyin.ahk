#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

<^>!a::return
#If, A_PriorHotkey = "<^>!a"
<^>!1::Send, ā
<^>!2::Send, á
<^>!3::Send, ǎ
<^>!4::Send, à
#If

<^>!e::return
#If, A_PriorHotkey = "<^>!e"
<^>!1::Send, ē
<^>!2::Send, é
<^>!3::Send, ě
<^>!4::Send, è
#If

<^>!i::return
#If, A_PriorHotkey = "<^>!i"
<^>!1::Send, ī
<^>!2::Send, í
<^>!3::Send, ǐ
<^>!4::Send, ì
#If

<^>!o::return
#If, A_PriorHotkey = "<^>!o"
<^>!1::Send, ō
<^>!2::Send, ó
<^>!3::Send, ǒ
<^>!4::Send, ò
#If

<^>!u::return
#If, A_PriorHotkey = "<^>!u"
<^>!1::Send, ū
<^>!2::Send, ú
<^>!3::Send, ǔ
<^>!4::Send, ù
#If

<^>!ü::return
#If, A_PriorHotkey = "<^>!ü"
<^>!1::Send, ǖ
<^>!2::Send, ǘ
<^>!3::Send, ǚ
<^>!4::Send, ǜ
#If
