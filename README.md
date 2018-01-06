# bas-2.5-plus
2018 version of BAS 2.4 ANSI BASIC interpreter by Michael Haardt - moira.de (cpmtools fame)

This file is supplimentary to the **BAS** project, 
last edited: Jan 6 2018

Here _plus_ means version 2.5 and later (bas-2.* == bas-2.5-plus). **BAS** v2.4 was last updated in 2015, but I have been unable to get are response from Michaels email address, so considering the bug fixes and changes made we continue development here.

# binaries
All binary objects present in the repo are compiled on a RPi2 with gcc-6.1.0, on a customised (mostly console only) SD card image of PipaOS 5.0 with minimal X-Windows (for Chromium Browser on VT8).

# additions
Various command line options have been added, including 265 colors (works with **$TERM** _fbterm_ & _xterm-256colors_) and the ability to pre-execute "./autoexec.bas" in the current directory on startup. Almost all extensions to **BAS 2.4** are supplied in **BAS-2.5-pw** (including MSX, Amstrad, etc), unless they are generic then they are also added to  **BAS-2.5** (eg. MERGE, CHAIN). Bug fixes are applied to both **BAS-2.5** and **BAS-2.5-pw**. **BAS-2.5-pw** is 100% backwards compatible with **BAS-2.5**, but also contains additional extension and _BAS_ _manual_ sub-sections:

  * man bas - full manual, updated, as per v2.4
  * man bas_statements - only "statements"
  * man bas_functions - only "functions"
  * man bas_direct - "statements" that only work in "direct mode"
  * man bas_files - only file related "statements" and "functions"
  * man bas_matrix - only matrix related "statements" and "functions"
  * man bas_msx_compatability - changes, workarounds and fixes for MSX-BASIC source code.

**BAS-2.5** will move to v2.6 when a suitable solutions has been found for the 80 column bug below.

# bugs
There are a couple of minor quirks, which some people may see as bugs, but the only real "quirk" at the moment is the 80 column print bug. The internal buffer of both files and screen (file #0) is initialized to "width 80". The screen can be updated by importing tyhe **$COLUMNS** environment variable, but this does not affect the width of file output. According to the manual:

> **print** without **using** will advance to the next line if the value of the expression no longer fits into the current line.
> A semicolon concatenates the output while a comma puts the values in columns.
> A trailing semicolon suppresses printing a trailing newline.

This (originally) was intended to allow wordwrap without programatic intervention or logic being required.

According to usage tests, this _also_ applies to file output, not just screen output, and with an un-adjusted "width" you will find that when using standard **print #n,"string";**, the buffer is only output when >= width or 80 charcters. **print #n,"string>80"** will also show this _quirk_. Because the strings are longer than >=80 characters an NL/CR is inserted _BEFORE_ the string.

For unknown line lengths, the workaround is to _NOT_ use:

> open "file.ext" for output as #n

This means using one of the following, combined with a function to write the string to file one character at a time:

> open "file.ext" for random as #n

or

> open "file.ext" for binary as #n

One _bug_ that does exist is that **environ** **entry$** _CANNOT_ set strings, but _CAN_ set integers.

# future
Because I use **BAS** on a Raspberry Pi, I have plans to include **BBC** **BASIC** style _inline_ _assembler_. I also currently have available an "inline z80 core", and I am looking at ways to include roms, and exit back to the interpreter. I have already put in place the ability to use the **option** statement to allow upto 64 kilobytes of ram to be allocated, and _thence_ (ie. not yet) the use of **PEEK** and **POKE** in that range. This will be extended (after some thought) to the use of **INP** and **OUT** to access the RPi GPIO pins.

I also have a range of _assistant_ scripts and programs that allow **BAS** to use other BASIC extensions via the _SHELL_ statement. Some of these are targeted at the framebuffer device (**/dev/fb0**). At the moment my framebuffer code is highly intelligent about the pixel (color) format, however any use of a library (SDL, SDL2, etc) is being considered only as a fork of **BAS-2.5** or **BAS-2.5-pw**. Direct framebuffer access may be included at a future date.

The command line scripts are available in the project https://github.com/paulwratt/ShellBASIC

The _fork_ will be available in the project https://github.com/paulwratt/ShellBASIC-shbasic

There will also be available a "shell script replacements" project https://github.com/paulwratt/bas-commands

A specific "terminal device" is being considered, after an initial development of "linux-256colors" kernel terminal replacement. We are looking at integrating the _xterm_ style VT102/VT440 and Tektronix 4014 as "screen options", with some extension to allow programatic changing of fonts, and the DEC standard that allows more than 2 fonts to be loaded (or used).

Most of these will only be include in **BAS-2.5-pw**. The GPIO code will be placed in such a way as to make it usable (or assignable) on non-RPi systems as well, and will eventually be included in **BAS-2.5**.

OK, thats enough for now.
