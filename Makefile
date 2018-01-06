srcdir=		.

prefix=		/usr
exec_prefix=	${prefix}
datarootdir=	${prefix}/share
localedir=	${datarootdir}/locale

CC=		/usr/local/gcc-6.1.0/bin/gcc-6.1.0
RANLIB=		ranlib
CFLAGS=		-O2 -pipe -Wall -Wshadow -Wbad-function-cast -Wmissing-prototypes -Wstrict-prototypes -Wcast-align -Wcast-qual -Wpointer-arith -Wwrite-strings -Wmissing-declarations -Wnested-externs -Wundef -pedantic -fno-common
CPPFLAGS=	 -DLOCALEDIR=\"$(localedir)\"
LDFLAGS=	
LIBS=		-lcurses -lm 

CATALOGS=	de.mo

all:		bas all-po-no
all-po-no:
all-po-yes:	$(CATALOGS)

bas:		main.o libbas.a getopt.o getopt1.o
		$(CC) -o $@ $(LDFLAGS) main.o libbas.a getopt.o getopt1.o $(LIBS)

token.c:	token.l token.h
		flex -i -t token.l >token.c

libbas.a:	auto.o bas.o fs.o global.o token.o program.o \
		str.o value.o var.o
		rm -f $@
		ar cq $@ auto.o bas.o fs.o global.o token.o program.o \
		str.o value.o var.o
		ranlib libbas.a

cppcheck:
		cppcheck $(CPPFLAGS) -q --enable=all .

install-po:	install-po-no
install-po-no:
install-po-yes:	$(CATALOGS)
		for cat in $(CATALOGS); do \
		  dir=$(localedir)/`basename $$cat .mo`/LC_MESSAGES; \
		  [ -d $$dir ] || /usr/bin/install -c -m 755 -d $$dir; \
		  /usr/bin/install -c -m 644 $$cat $$dir/bas.mo; \
		done

check:		bas
		for i in test/test*; do ./$$i || break; done

install:	all
		/usr/bin/install -c -m 755 -d ${exec_prefix}/bin
		/usr/bin/install -c bas ${exec_prefix}/bin/bas
		/usr/bin/install -c -m 755 -d ${exec_prefix}/lib
		/usr/bin/install -c -m 644 libbas.a ${exec_prefix}/lib/libbas.a
		ranlib ${exec_prefix}/lib/libbas.a
		/usr/bin/install -c -m 755 -d ${datarootdir}/man/man1
		/usr/bin/install -c -m 644 bas.1 ${datarootdir}/man/man1/bas.1
		make install-po

.c.o:
		$(CC) -c $(CPPFLAGS) $(CFLAGS) $<

.SUFFIXES:	.po .mo

.po.mo:
		msgfmt -o $@ $<

*.po:		bas.pot
		for cat in *.po; do \
		  if msgmerge $$cat bas.pot -o $$cat.tmp; then \
		    mv -f $$cat.tmp $$cat; \
		  else \
		    echo "msgmerge for $$cat failed!"; \
		    rm -f $$cat.tmp; \
		  fi; \
		done

bas.pot:	[a-b]*.[ch] [e-s]*.[ch] v*.[ch]
		xgettext --add-comments --keyword=_ [a-b]*.[ch] [e-s]*.[ch] v*.[ch] && test -f messages.po && mv messages.po $@

bas.pdf:	bas.1
		groff -Tps -t -man bas.1 | ps2pdf - $@

#{{{script}}}#{{{ clean
clean:
		rm -f *.out core token.c *.o libbas.a *.mo
#}}}
#{{{ distclean
distclean:	clean
		rm -rf autom4te.cache bas config.cache config.h config.log config.status configure.lineno Makefile bas.1 test/runbas
#}}}
#{{{ tar
tar:		bas.pdf distclean
		(b=`pwd`; b=`basename $$b`; cd ..; tar zcvf $$b.tar.gz $$b/LICENSE $$b/INSTALL $$b/Makefile.in $$b/README $$b/NEWS $$b/configure $$b/install-sh $$b/test $$b/[a-z]*.*)
#}}}
#{{{ dependencies
auto.o:	auto.c config.h auto.h programtypes.h var.h value.h str.h token.h autotypes.h program.h
bas.o:	bas.c config.h getopt.h auto.h programtypes.h var.h value.h str.h token.h autotypes.h \
	 program.h bas.h error.h fs.h global.h statement.c statement.h
fs.o:	fs.c config.h fs.h str.h
getopt.o:	getopt.c config.h getopt.h
getopt1.o:	getopt1.c config.h getopt.h
global.o:	global.c config.h auto.h programtypes.h var.h value.h str.h token.h autotypes.h \
	 program.h bas.h error.h fs.h global.h
main.o:	main.c config.h getopt.h bas.h
program.o:	program.c config.h auto.h programtypes.h var.h value.h str.h token.h autotypes.h \
	 program.h error.h fs.h
statement.o:	statement.c config.h statement.h
str.o:	str.c config.h str.h
token.o:	token.c config.h auto.h programtypes.h var.h value.h str.h token.h autotypes.h \
	 program.h statement.h
value.o:	value.c config.h error.h value.h str.h
var.o:	var.c config.h error.h var.h value.h str.h
#}}}
