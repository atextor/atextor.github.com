---
layout: post
title:  "How to type Pinyin with tone marks in Windows"
date:   2022-05-24 05:30:00 +0200
---
{::comment}
vim: set fo=aw2tq, tw=120, spelllang=en
{:/comment}

Learners of the Chinese language early on learn about [Pinyin](https://en.wikipedia.org/wiki/Pinyin):

> Hanyu Pinyin (simplified Chinese: 汉语拼音; traditional Chinese: 漢語拼音; pinyin: hànyǔ pīnyīn),
  very often shortened to just pinyin, is the official romanization system for Standard Mandarin
  Chinese in Mainland China, and to some extent, in Taiwan and Singapore.

Among other things, pinyin can be used on a computer to enter Chinese characters, e.g., with pinyin
input, you type latin characters to get a pop-up where you can select the proper character.

It is, however, surprisingly difficult to directly enter vowels with pinyin tone marks themselves.
In Windows, the [Microsoft
Pinyin](https://en.naneedigital.com/article/how_to_type_pinyinwith_tone_marks_in_windows_10)
keyboard or a separate software such as [PinyinTones](https://www.pinyintones.com/) can be used.
With both, you'll type a syllable with the tone's number afterwards, e.g. typing _ni3 hao3_ will turn
into _nǐ hǎo_. This works, but can be cumbersome if you prefer to add the tone directly on the
corresponding character when you type it.

Here is a solution which will add keyboard shortcuts for tones instead: If you follow the
instructions below, you can use shortcuts to directly enter vowels with tone marks: To enter _ā_, (a
in the first tone), press <kbd>AltGr</kbd> + <kbd>a</kbd>, followed by <kbd>AltGr</kbd> +
<kbd>1</kbd>, and so on, for the other tones and vowels. The solution itself works independently
from system language or active Windows keyboard layout. This is intended for German keyboard users,
see below if you use a different layout.

1. Install [Autohotkey](https://www.autohotkey.com/), a free software for automating Windows using
   hotkeys. You can find installation and set up instructions
   [here](https://www.autohotkey.com/docs/Tutorial.htm#s11).
1. Follow the [Autohotkey tutorial to create a script
   file](https://www.autohotkey.com/docs/Tutorial.htm#s12). Use the following as script content:

   ```autohotkey
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
   #If, A_PriorHotkey = "<^>!e"
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
   ```

1. Save the script and double-click it to start it.
1. Now, you can use shortcuts to enter vowels with tone marks as described above: To enter `ā`, (a
   in the first tone), press <kbd>AltGr</kbd> + <kbd>a</kbd>, followed by <kbd>AltGr</kbd> +
   <kbd>1</kbd>.

## Adapt to work with other keyboard layouts

Although the solution was developed for German keyboard users and therefore uses the
<kbd>AltGr</kbd> key, which is not present on all keyboard layouts (e.g., US layout), you can adapt
the solution to use for example <kbd>Alt</kbd>+<kbd>Shift</kbd> instead. Replace `<^>!` with one or
more other [hotkey modifier symbols](https://www.autohotkey.com/docs/Hotkeys.htm#Symbols) to change
the hotkey. Also, if you use a keyboard that has no native `ü` key, you'll want to change the two
lines:

   ```autohotkey
   <^>!ü::return
   #If, A_PriorHotkey = "<^>!ü"
   ```

into

   ```autohotkey
   <^>!v::return
   #If, A_PriorHotkey = "<^>!v"
   ```

instead to use <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>v</kbd> instead of
<kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>ü</kbd>.

Please go [here](https://github.com/atextor/atextor.github.com/issues/8) to
comment this article.
