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
1. Download the script file [Pinyin.ahk](https://atextor.de/assets/Pinyin.ahk).
1. From your download folder, move the file Pinyin.ahk to your desktop. This
   way, you can easily access it after a reboot.
1. On your desktop, double-click the Pinyin.ahk file.
1. Now, you can use shortcuts to enter vowels with tone marks as described above: To enter `ā`, (a
   in the first tone), press <kbd>AltGr</kbd> + <kbd>a</kbd>, followed by <kbd>AltGr</kbd> +
   <kbd>1</kbd>.

<table class="colortable">
    <colgroup>
        <col width="20%" />
        <col width="20%" />
        <col width="10%" />
        <col width="5em" />
        <col width="20%" />
        <col width="20%" />
        <col width="10%" />
    </colgroup>
    <thead>
        <tr class="header">
            <th>First press...</th>
            <th>then press...</th>
            <th>to get</th>
            <th class="spacer"></th>
            <th>First press...</th>
            <th>then press...</th>
            <th>to get</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="color1"><kbd>AltGr</kbd>+<kbd>a</kbd></td>
            <td class="color1"><kbd>AltGr</kbd>+<kbd>1</kbd></td>
            <td class="color1">ā</td>
            <td class="spacer"></td>
            <td class="color4"><kbd>AltGr</kbd>+<kbd>i</kbd></td>
            <td class="color4"><kbd>AltGr</kbd>+<kbd>1</kbd></td>
            <td class="color4">ī</td>
        </tr>
        <tr>
            <td class="color1"><kbd>AltGr</kbd>+<kbd>a</kbd></td>
            <td class="color1"><kbd>AltGr</kbd>+<kbd>2</kbd></td>
            <td class="color1">á</td>
            <td class="spacer"></td>
            <td class="color4"><kbd>AltGr</kbd>+<kbd>i</kbd></td>
            <td class="color4"><kbd>AltGr</kbd>+<kbd>2</kbd></td>
            <td class="color4">í</td>
        </tr>
        <tr>
            <td class="color1"><kbd>AltGr</kbd>+<kbd>a</kbd></td>
            <td class="color1"><kbd>AltGr</kbd>+<kbd>3</kbd></td>
            <td class="color1">ǎ</td>
            <td class="spacer"></td>
            <td class="color4"><kbd>AltGr</kbd>+<kbd>i</kbd></td>
            <td class="color4"><kbd>AltGr</kbd>+<kbd>3</kbd></td>
            <td class="color4">ǐ</td>
        </tr>
        <tr>
            <td class="color1"><kbd>AltGr</kbd>+<kbd>a</kbd></td>
            <td class="color1"><kbd>AltGr</kbd>+<kbd>4</kbd></td>
            <td class="color1">à</td>
            <td class="spacer"></td>
            <td class="color4"><kbd>AltGr</kbd>+<kbd>i</kbd></td>
            <td class="color4"><kbd>AltGr</kbd>+<kbd>4</kbd></td>
            <td class="color4">ì</td>
        </tr>
        <tr>
            <td class="color2"><kbd>AltGr</kbd>+<kbd>o</kbd></td>
            <td class="color2"><kbd>AltGr</kbd>+<kbd>1</kbd></td>
            <td class="color2">ō</td>
            <td class="spacer"></td>
            <td class="color5"><kbd>AltGr</kbd>+<kbd>u</kbd></td>
            <td class="color5"><kbd>AltGr</kbd>+<kbd>1</kbd></td>
            <td class="color5">ū</td>
        </tr>
        <tr>
            <td class="color2"><kbd>AltGr</kbd>+<kbd>o</kbd></td>
            <td class="color2"><kbd>AltGr</kbd>+<kbd>2</kbd></td>
            <td class="color2">ó</td>
            <td class="spacer"></td>
            <td class="color5"><kbd>AltGr</kbd>+<kbd>u</kbd></td>
            <td class="color5"><kbd>AltGr</kbd>+<kbd>2</kbd></td>
            <td class="color5">ú</td>
        </tr>
        <tr>
            <td class="color2"><kbd>AltGr</kbd>+<kbd>o</kbd></td>
            <td class="color2"><kbd>AltGr</kbd>+<kbd>3</kbd></td>
            <td class="color2">ǒ</td>
            <td class="spacer"></td>
            <td class="color5"><kbd>AltGr</kbd>+<kbd>u</kbd></td>
            <td class="color5"><kbd>AltGr</kbd>+<kbd>3</kbd></td>
            <td class="color5">ǔ</td>
        </tr>
        <tr>
            <td class="color2"><kbd>AltGr</kbd>+<kbd>o</kbd></td>
            <td class="color2"><kbd>AltGr</kbd>+<kbd>4</kbd></td>
            <td class="color2">ò</td>
            <td class="spacer"></td>
            <td class="color5"><kbd>AltGr</kbd>+<kbd>u</kbd></td>
            <td class="color5"><kbd>AltGr</kbd>+<kbd>4</kbd></td>
            <td class="color5">ù</td>
        </tr>
        <tr>
            <td class="color3"><kbd>AltGr</kbd>+<kbd>e</kbd></td>
            <td class="color3"><kbd>AltGr</kbd>+<kbd>1</kbd></td>
            <td class="color3">ē</td>
            <td class="spacer"></td>
            <td class="color6"><kbd>AltGr</kbd>+<kbd>ü</kbd></td>
            <td class="color6"><kbd>AltGr</kbd>+<kbd>1</kbd></td>
            <td class="color6">ǖ</td>
        </tr>
        <tr>
            <td class="color3"><kbd>AltGr</kbd>+<kbd>e</kbd></td>
            <td class="color3"><kbd>AltGr</kbd>+<kbd>2</kbd></td>
            <td class="color3">é</td>
            <td class="spacer"></td>
            <td class="color6"><kbd>AltGr</kbd>+<kbd>ü</kbd></td>
            <td class="color6"><kbd>AltGr</kbd>+<kbd>2</kbd></td>
            <td class="color6">ǘ</td>
        </tr>
        <tr>
            <td class="color3"><kbd>AltGr</kbd>+<kbd>e</kbd></td>
            <td class="color3"><kbd>AltGr</kbd>+<kbd>3</kbd></td>
            <td class="color3">ě</td>
            <td class="spacer"></td>
            <td class="color6"><kbd>AltGr</kbd>+<kbd>ü</kbd></td>
            <td class="color6"><kbd>AltGr</kbd>+<kbd>3</kbd></td>
            <td class="color6">ǚ</td>
        </tr>
        <tr>
            <td class="color3"><kbd>AltGr</kbd>+<kbd>e</kbd></td>
            <td class="color3"><kbd>AltGr</kbd>+<kbd>4</kbd></td>
            <td class="color3">è</td>
            <td class="spacer"></td>
            <td class="color6"><kbd>AltGr</kbd>+<kbd>ü</kbd></td>
            <td class="color6"><kbd>AltGr</kbd>+<kbd>4</kbd></td>
            <td class="color6">ǜ</td>
        </tr>
    </tbody>
</table>

## Adapt to work with other keyboard layouts

Although the solution was developed for German keyboard users and therefore uses the
<kbd>AltGr</kbd> key, which is not present on all keyboard layouts (e.g., US layout), you can adapt
the solution to use for example <kbd>Alt</kbd>+<kbd>Shift</kbd> instead. In the Pinyin.ahk script
file, replace `<^>!` with one or more other [hotkey modifier
symbols](https://www.autohotkey.com/docs/Hotkeys.htm#Symbols) to change the hotkey. Also, if you use
a keyboard that has no native `ü` key, you'll want to change the two lines:

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
