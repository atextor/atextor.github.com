---
layout: post
title:  "The Quest for the Next Generation Power User Interface"
date:   2012-04-20 16:55:23 +0200
---
{::comment}
vim: set fo=aw2tq, tw=120, spelllang=en
{:/comment}
[This post was updated on 2015-03-13 to change the URL to the 'niveau' tool, which was moved from Google Code to GitHub.]

## Introduction

I love the command line. They say, if you do something for a decade or longer, you become really good at it. In 2000, I 
started using Linux and the command line extensively. Other powerful tools exist beside the command line interface 
(CLI), e.g., certain file managers. In everyday use for me, though, the CLI is well-proven and the versatility given by 
the modularity of the commands, pipelines, integrated scripting (i.e., Bash on-liners) and the awesomeness of tools such 
as find, screen, ssh and numerous others makes it superior to alternative interfaces. I can't get that with a regular 
file manager. If you are a developer or power user and regularly use a CLI, you probably know what I mean.

It is the flexibility of the commands and the powerful recombination possibilities of simple commands that makes it 
great for me, not so much the dull text output. In fact, in a "Next Generation Power User Interface" (NGPUI) I would 
like to have a much richer display capability. Even something very simple such as sorting holiday photos is very easy 
using a graphical file manager, yet cumbersome on the CLI, even if you can pattern match file names etc., just because 
you don't have thumbnails. Of course the idea to graphically augment the command line interface or replace it by a 
better alternative altogether is nothing new. Yet, for some reason, I have found no solution that satisfies my 
requirements. In this post, I want to clarify my requirements for a "better" command line interface, review existing 
approaches to one, and explore paths that could lead to what I think is the CLI/CLI-successor that every developer and 
power users wants (although they don't know it yet ;-)).

## The requirements

What do I envision for the NGPUI? It should be a logical successor to a terminal emulator, where you type your commands. 
It should not be limited to text output though. Regular command line tools should run in it as well as new tools that 
use the graphical capabilities, such as ls with thumbnails.

### 1) Keyboard superiority
It should be controlled exclusively by keyboard. It's kind of obvious when you think about the typical CLI, but I want 
to state it explicitly. If you design an interface specifically with keyboard input in mind, you will necessarily think 
about how you make it accessible in a fast way. Watch a ten years vim[^1] user edit a text file and you'll understand.

### 2) Compatibility, Non-Intrusiveness
It should be compatible with what we already have, i.e., what applications can do in a modern terminal. This is a 
crucial point, because it's not only a text area where you append line after line, but there are also ANSI escape codes 
to move the cursor or change colors, there are things like ncurses and screen, text wrapping, wide characters, different 
fonts / proper Unicode support, visual bells, etc.. Whatever the NGPUI is, all of the above must work. Nobody would 
seriously use it if the existing applications don't work in it, or you would need to patch your favorite text editor 
just to work with it - you can't rewrite everything.

### 3) Rich Display Capability
Whatever that means, it should be more powerful than... text. First of all, it should be possible to display images. If 
this also means animations, embedded videos or websites etc. - I don't know. For now, I would be happy to see thumbnails 
for my photos. It might be necessary that the display is asynchronous - think typing ls and you get a table of files and 
you can already type the next command while the thumbnails in the table are still loading and gradually appear. Also, 
typing wildcards or regexes and dynamically seeing a preview of what files are affected before you even execute the 
command would be awesome.

## Approaching the problem
There are basically three ways to approach the problem:
1. Take something that already displays graphics (such as a browser/html renderer) and add functionality to it to run 
normal CLI applications
2. Take something that already runs normal CLI applications (i.e., a terminal emulator such as urxvt, gnome-terminal, 
etc.) and add functionality to display graphics
3. Display graphics separately from the actual terminal.
All three approaches might work, and all have different advantages and disadvantages (flexibility, amount of work to 
implement, practicality, portability).

### Existing software
For (1), you should check out Steven Wittens' [TermKit](http://acko.net/blog/on-termkit/). It uses a WebKit renderer as 
a graphical display and several JavaScript libraries to create a hybrid command line/graphical user interface. It also 
has a more advanced data model for pipes. Altogether, it looks very promising. Unfortunately it is not a VT100 emulator, 
which means things like vim and screen will never run in it. If you'd like to try it in Linux, 
[here](http://blog.easytech.com.ar/2011/05/21/playing-with-termkit-with-chrome/) is a Blog post that explains how. I 
don't know if there are other similar projects, but I wouldn't be surprised.
When I searched for normal terminals that support graphics (2), I stumbled over this extract from a manpage in the [Arch 
Linux Wiki](https://wiki.archlinux.org/index.php/Rxvt-unicode) on rxvt-unicode (urxvt):

> COLORS AND GRAPHICS - If graphics support was enabled at compile-time, rxvt can be queried with ANSI escape sequences 
> and can address individual pixels instead of text characters. Note the graphics support is still considered beta code.

I searched the urxvt website, man page, help output and google to find out how to activate this mystical graphics mode. 
It turns out that, even though the quote was on the urxvt wiki page, this functionality is in fact only present in rxvt, 
and was removed in urxvt. I wouldn't want to use rxvt for its lack of unicode support (and other nice features in urxvt, 
such as the perl extensions), but this looks promising.

[![Graphics in rxvt 1]({{ "/assets/rxvt-graphics1.png" | prepend: site.baseurl }})]({{ "/assets/rxvt-graphics1.png" | prepend: site.baseurl }})
[![Graphics in rxvt 2]({{ "/assets/rxvt-graphics2.png" | prepend: site.baseurl }})]({{ "/assets/rxvt-graphics2.png" | prepend: site.baseurl }})

It seems that no other terminal emulator has a comparable feature.

Regarding (3), the most popular possibility is embedding a terminal into a file manager. I have tried [Nautilus 
Terminal](http://www.addictivetips.com/ubuntu-linux-tips/nautilus-terminal-embed-linux-terminal-to-nautilus-file-browser/), 
but I assume a similar thing is available for Konqueror as well. The Nautilus Terminal even automatically `cd`s into the 
directory when you click a folder, but not vice-versa. Also, you cannot choose where the terminal resides, it's always 
above the folder view. If there were some way for the terminal to tell the folder view what to display or highlight, and 
this could be scripted, this *might* evolve into something useful. Right now, it's barely better than a drop-down 
console such as kuake or just a hotkey switch to my 1st desktop, where my terminal window lives.

[![Nautilus Terminal]({{ "/assets/nautilus-terminal.png" | prepend: site.baseurl }})]({{ "/assets/nautilus-terminal.png" | prepend: site.baseurl }})

### Doing something about it

None of the existing options fulfills all the requirements (rxvt graphics come close to be forged into something really 
useful, but rxvt lacks unicode support). So I started playing around and write some software.

My first attempt was to follow approach (3) and create a graphical display that lives detached from the actual terminal 
and can show thumbnails and other information that the terminal cannot show. The big advantage is that it can be used 
with all combinations of terminal emulators and shells, so regardless if you're a fan of urxvt like me or Konsole, or 
bash or zsh, it can be used. The result is the prototypical implementation of 
[Niveau](https://github.com/atextor/niveau/), the "Niveau visualization engine". You open it as a separate window beside 
your regular terminal emulator and it displays, e.g., a graphical directory listing. It is only a display without input 
capabilities that is updated when the content in the terminal changes.

[![Niveau]({{ "/assets/niveau.png" | prepend: site.baseurl }})]({{ "/assets/niveau.png" | prepend: site.baseurl }})

The way it works is as follows: In the terminal you start `script -f /tmp/niveau-pipe`, which copies all the displayed 
content of your terminal into a pipe in real-time, from where it is read by Niveau. Niveau then parses the prompt via a 
regular expression, extracts the current directory from it, and displays the directory contents using a HTML 
renderer[^2]. It uses a template engine, so the display can be freely configured using HTML and CSS.
As a proof-of-concept, it does work well. For everyday use, though, I found it to be too cumbersome. For large 
directories it's slow (could be improved in the implementation), but more importantly, I found it confusing to switch my 
attention between the two windows all the time. This means, this is not the long-term solution I'm looking for.


I briefly investigated approach (1) to see how much work it would be to implement a full-fledged terminal emulator in, 
say, JavaScript so it could run inside WebKit or similar. By looking at the rxvt and urxvt sources and skimming over the 
amount of standards I would need to implement, I refused the idea for now.

So, (2) it is! How do I get graphics into the terminal? Note that at this point I had not discovered the rxvt graphics 
mode. The first try was to abuse Unicode "drawing" characters to output images on a 256-color capable terminal, a tool I 
call [icat](https://github.com/atextor/icat) (image cat):

[![icat]({{ "/assets/icat.png" | prepend: site.baseurl }})]({{ "/assets/icat.png" | prepend: site.baseurl }})

It was a fun experiment to figure out how to do this (dithering 16/32 bit colors to the 256 colors of terminals), but I 
did not find better Unicode characters for drawing than the half-character-blocks. Obviously, this is also no perfect 
solution for the original problem, as the blocks are way to big.

The next logical step was to teach a terminal graphics capabilities (I still did not know about rxvt's graphics mode 
then!). I would have preferred a solution that does not only run on Linux but on Windows and Mac as well, and took a 
look at [Terminator](http://software.jessies.org/terminator/), a terminal emulator written in Java (which also means I 
could have hacked it in Scala! Yay!). But first the UTF-8 support did not at all work as advertised, see a comparison of 
Terminator with urxvt on the [UTF-8-demo.txt](http://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt):

[![Terminator vs URxvt with UTF-8]({{ "/assets/terminator-urxvt-utf8.png" | prepend: site.baseurl }})]({{ "/assets/terminator-urxvt-utf8.png" | prepend: site.baseurl }})

Then I tried to switch to my favorite terminal font, [Terminus](http://terminus-font.sourceforge.net/), which resulted 
in:

[![Terminator with Terminus font]({{ "/assets/terminator-terminus.png" | prepend: site.baseurl }})]({{ "/assets/terminator-terminus.png" | prepend: site.baseurl }})

For this reason, Terminator was out of the question and I took urxvt as my new target, one of the best, if not the best 
terminal emulator out there. Even if it meant dealing with C++ ;-). The source code is very much optimized for text 
display, as I found out while digging through it. I invented a schema for encoding pixel data in terminal escape codes 
and added support for that in urxvt, and voilà:

[![URxvt with graphics]({{ "/assets/urxvt-graphics.png" | prepend: site.baseurl }})]({{ "/assets/urxvt-graphics.png" | prepend: site.baseurl }})

(Note that the icat command in the screenshot is not the one I linked earlier, but a special version to work with the 
urxvt hack.) Interestingly, the rxvt graphics support also works with custom escape codes, but does not encode pixel 
data but rather drawing primitives such as drawing a line. The urxvt graphics mode looks nice on a screenshot, but is 
very broken when the text in the terminal scrolls. A lot more changes to the code would be needed to make this 
practical.

### What now

The quest is not at its end, and there are several ways to go from here. I'll probably not develop Niveau any further, 
because it's too impractical. One good way seems to be to take hints from the rxvt graphics mode to improve my own urxvt 
graphics mode. In the meantime I'll keep TermKit on the radar. Maybe there are other projects or approaches I've missed?

* * *

[^1]: Or any other powerful text editor of course. Although vim > `*`. 
[^2]: I'm aware that this could also be achieved with a prompt function. The idea was to read other content from the terminal as well, e.g., what you're currently typing.

