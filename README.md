# bas-2.5-plus
2018 version of BAS 2.4 ANSI BASIC interpreter by Michael Haardt - moira.de (cpmtools fame)

edited: Jan 6 2018

Here _plus_ means version 2.5 and later. V2.4 was last updated in 2015, but I have been unable to get are response from Michaels email address, so considering the bug fixes and changes made we continue development here.

# additions
Various command line options, including, 265 colors, and the ability to pre-execute "./autoexec.bas" in the current directory on startup. Almost all extensions to **BAS 2.4** are supplied in **BAS-2.5-pw** (including MSX, Amstrad, etc), unless they are generic. Bug fixes are applied to both **BAS-2.5** and **BAS-2.5-pw**. **BAS-2.5-pw** is 100% backwards compatible with **BAS-2.5** but also contains _BAS_ _manual_ subsections:

  * man bas - full manual, updated, as per v2.4
  * man bas_statements - only "statements"
  * man bas_functions - only "functions"
  * man bas_files - only file related "statements" and "functions"
  * man bas_matrix - only matrix related "statements" and "functions"
  * man bas_msx_compatability - changes, workarounds and fixes for MSX-BASIC source code.

**BAS** will move to v2.6 when a suitable solutions has been found for the 80 column bug (see below).

# bugs
There are a couple of minor quirks, which some may see as bugs, but the only real "quirk" atm is the 80 column print bug. The internal buffer of both screen and files is initialized to "width 80". The screen can be updated buy importind "COLUMNS" environment variable, but this does not affect the width of file output. According to the manual:

> **print** without **using** will advance to the next line if the value of the expression no longer fits into the current line.
> A semicolon concatenates the output while a comma puts the values in columns.
> A trailing semicolon suppresses printing a trailing newline.

According to usage tests this _also_ applies to file output, not just screen output, and with an un-adjusted "width" you will find that using standard **print #n,"string";**, the buffer is only output when >= width or 80 charcters. Even a standard **print #n,"string>80"** will also show this _quirk_. Because the strings are longer than >=80 characters an NL/CR is inserted _BEFORE_ the string.

The workaround is to _NOT_ use for unknown line lengths:

> open "file.ext" for output as #n

This means using one of the following, with a function to write the string to file, one character at a time:

> open "file.ext" for random as #n

or

> open "file.ext" for binary as #n

# future
Because I use **BAS** on a Raspberry Pi, I have plans to include BBC BASIC style "inline assembler". I currently have available an "inline z80 core". I have already put inplace the ability to use the **option** statement to allow upto 64 kilibytes of ram to be allocated, and _thence_ the use of **PEEK** and **POKE** in that range. This will be extended (after somme thought) to the use of **INP** and **OUT** to access the RPi GPIO pins. Most of these will only be include in **BAS-2.5-pw**. The GPIO code will be placed in such a way as to make it usable (or assignable) on non-RPi systems as well.

I also have a range of "assistant" scripts and programs that allow **BAS** to use other BASIC extensions via the _SHELL_ statement. Some of these are targeted at the **/dev/fb0** (framebuffer) device. At the moment the framebuffer code is highly intelligent about the pixel (color) format, however any use of a library (SDL, SDL2, etc) is being considered only as a fork of **BAS-2.5** or **BAS-2.5-pw**.

A specific "terminal device" is being considered, after an initial development of "linux-256colors" kernel terminal replacement. We are looking at integrating the _xterm_ style VT102/VT440 and Tektronix 4014 as "screen options", with some extension to allow programatic changing of fonts, and the DEC standard that allows more than 2 fonts to be loaded (or used).


OK, thats enough for now.
