What This Module Does.

An overview of the multimedia module's role and abilities.

@h Prerequisites.
The multimedia module is a part of the Inform compiler toolset. It is
presented as a literate program or "web". Before diving in:
(a) It helps to have some experience of reading webs: see //inweb// for more.
(b) The module is written in C, in fact ANSI C99, but this is disguised by the
fact that it uses some extension syntaxes provided by the //inweb// literate
programming tool, making it a dialect of C called InC. See //inweb// for
full details, but essentially: it's C without predeclarations or header files,
and where functions have names like |Tags::add_by_name| rather than just |add_by_name|.
(c) This module uses other modules drawn from the compiler (see //structure//), and also
uses a module of utility functions called //foundation//.
For more, see //foundation: A Brief Guide to Foundation//.

@h Now in glorious Technicolor.
This module consists only of three independent plugins, and even those are
very similar to each other:

(*) //External Files// is a plugin for reading and writing files;
(*) //Figures// for displaying images; and
(*) //Sound Effects// for playing music or other sounds.
