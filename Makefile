
PROG=	yasslEWS

all:
	@echo "make (linux|bsd|solaris|mac|windows|mingw|ios)"

# Possible COPT values: (in brackets are rough numbers for 'gcc -O2' on i386)
# -DHAVE_MD5		- use system md5 library (-2kb)
# -DNDEBUG		- strip off all debug code (-5kb)
# -DDEBUG		- build debug version (very noisy) (+7kb)
# -DNO_CGI		- disable CGI support (-5kb)
# -DNO_SSL		- disable SSL functionality (-2kb)
# -DCONFIG_FILE=\"file\" - use `file' as the default config file
# -DHAVE_STRTOUI64	- use system strtoui64() function for strtoull()
# -DSSL_LIB=\"libssl.so.<version>\" - use system versioned SSL shared object
# -DCRYPTO_LIB=\"libcrypto.so.<version>\" - use system versioned CRYPTO so


##########################################################################
###                 UNIX build: linux, bsd, mac, rtems
##########################################################################

CFLAGS = -W -Wall -std=c99 -pedantic -O2 $(COPT)
MAC_SHARED = -flat_namespace -bundle -undefined suppress
LINFLAGS = -ldl -pthread $(CFLAGS)
LIB = _$(PROG).so
CC = g++

# Make sure that the compiler flags come last in the compilation string.
# If not so, this can break some on some Linux distros which use
# "-Wl,--as-needed" turned on by default  in cc command.
# Also, this is turned in many other distros in static linkage builds.
linux:
	$(CC) yasslEWS.c -shared -fPIC -fpic -o $(LIB) $(LINFLAGS)
	$(CC) yasslEWS.c main.c -o $(PROG) $(LINFLAGS)

bsd:
	$(CC) yasslEWS.c -shared -pthread -fpic -fPIC -o $(LIB) $(CFLAGS)
	$(CC) yasslEWS.c main.c -pthread -o $(PROG) $(CFLAGS)

mac:
	$(CC) yasslEWS.c -pthread -o $(LIB) $(MAC_SHARED) $(CFLAGS)
	$(CC) yasslEWS.c main.c -pthread -o $(PROG) $(CFLAGS)

solaris:
	gcc yasslEWS.c -pthread -lnsl \
		-lsocket -fpic -fPIC -shared -o $(LIB) $(CFLAGS)
	gcc yasslEWS.c main.c -pthread -lnsl -lsocket -o $(PROG) $(CFLAGS)


##########################################################################
###                 iOS build: Apple TV 2
##########################################################################

SDKVER=    4.3
DEVROOT=   /Developer/Platforms/iPhoneOS.platform/Developer
SDKROOT=   $(DEVROOT)/SDKs/iPhoneOS$(SDKVER).sdk
IOS_CC=    /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc-4.2
IOSFLAGS=  -I$(SDKROOT)/usr/lib/gcc/arm-apple-darwin10/4.2.1/include/ \
    -I$(SDKROOT)/usr/include -I$(DEVROOT)/usr/include \
    --sysroot=$(SDKROOT) \
    -isystem $(SDKROOT)/usr/lib/gcc/arm-apple-darwin10/4.2.1/include/ \
    -isystem $(SDKROOT)/usr/include -isystem $(DEVROOT)/usr/include
IOS_CFLAGS=   -W -Wall -std=c99 -arch armv7 -pedantic -O2 \
    -fomit-frame-pointer $(COPT)
IOS_LDFLAGS=  -L$(SDKROOT)/usr/lib/system 

ios:
	$(IOS_CC) $(IOSFLAGS) $(IOS_CFLAGS) $(IOS_LDFLAGS) yasslEWS.c main.c -pthread -o $(PROG)

###########################################################################
###            WINDOWS build: Using Visual Studio or Mingw
##########################################################################

# Using Visual Studio 6.0. To build yasslEWS:
#  o  Set VC variable below to where VS 6.0 is installed on your system
#  o  Set CYA to where CyaSSL source directory is on your system
#  o  Set SDK to where Microsoft Platform SDK Lib is located on your system:
#     (ex: "C:\Program Files\Microsoft Platform SDK\Lib")
#  o  Run "PATH_TO_VC6\bin\nmake windows"

VC=	    z:
CYA=	y:
SDK=    x:
#DBG=	/Zi /DDEBUG /Od
DBG=	/DNDEBUG /O1
CL=	cl /MD /TC /nologo $(DBG) /Gz /W3 /DNO_SSL_DL
GUILIB=	user32.lib shell32.lib
LINK=	/link /incremental:no /libpath:$(VC)\lib /libpath:$(SDK) \
    /subsystem:windows ws2_32.lib advapi32.lib cyassl.lib

CYAFL = /c /I $(CYA) /D _LIB /D OPENSSL_EXTRA /D _WIN32

CYASRC= \
	$(CYA)/src/internal.c \
	$(CYA)/src/io.c \
	$(CYA)/src/keys.c \
	$(CYA)/src/ssl.c \
	$(CYA)/src/tls.c \
	$(CYA)/ctaocrypt/src/aes.c \
	$(CYA)/ctaocrypt/src/arc4.c \
	$(CYA)/ctaocrypt/src/asn.c \
	$(CYA)/ctaocrypt/src/coding.c \
	$(CYA)/ctaocrypt/src/asm.c \
	$(CYA)/ctaocrypt/src/misc.c \
	$(CYA)/ctaocrypt/src/memory.c \
	$(CYA)/ctaocrypt/src/des3.c \
	$(CYA)/ctaocrypt/src/dh.c \
	$(CYA)/ctaocrypt/src/dsa.c \
	$(CYA)/ctaocrypt/src/ecc.c \
	$(CYA)/ctaocrypt/src/hc128.c \
	$(CYA)/ctaocrypt/src/hmac.c \
	$(CYA)/ctaocrypt/src/integer.c \
	$(CYA)/ctaocrypt/src/md4.c \
	$(CYA)/ctaocrypt/src/md5.c \
	$(CYA)/ctaocrypt/src/pwdbased.c \
	$(CYA)/ctaocrypt/src/rabbit.c \
	$(CYA)/ctaocrypt/src/random.c \
	$(CYA)/ctaocrypt/src/ripemd.c \
	$(CYA)/ctaocrypt/src/rsa.c \
	$(CYA)/ctaocrypt/src/sha.c \
	$(CYA)/ctaocrypt/src/sha256.c \
	$(CYA)/ctaocrypt/src/sha512.c \
	$(CYA)/ctaocrypt/src/tfm.c

cyassl:
	$(CL) $(CYASRC) $(CYAFL) $(DEF)
	lib *.obj /out:cyassl.lib

windows:
	rc win32\res.rc
	$(CL) main.c yasslEWS.c /I $(CYA) /GA $(LINK) win32\res.res \
		$(GUILIB) /out:$(PROG).exe
	$(CL) yasslEWS.c /I $(CYA) $(LINK) /DLL /DEF:win32\dll.def /out:_$(PROG).dll

# Build for Windows under MinGW
#MINGWDBG= -DDEBUG -O0
MINGWDBG= -DNDEBUG -Os
#MINGWOPT= -W -Wall -mthreads -Wl,--subsystem,console $(MINGWDBG) -DHAVE_STDINT
MINGWOPT= -W -Wall -mthreads -Wl,--subsystem,windows $(MINGWDBG)
mingw:
	windres win32\res.rc win32\res.o
	gcc $(MINGWOPT) yasslEWS.c -lws2_32 \
		-shared -Wl,--out-implib=$(PROG).lib -o _$(PROG).dll
	gcc $(MINGWOPT) yasslEWS.c main.c win32\res.o -lws2_32 -ladvapi32 \
		-o $(PROG).exe


##########################################################################
###            Manuals, cleanup, test, release
##########################################################################

man:
	groff -man -T ascii yasslEWS.1 | col -b > yasslEWS.txt
	groff -man -T ascii yasslEWS.1 | less

# "TEST=unit make test" - perform unit test only
# "TEST=embedded" - test embedded API by building and testing test/embed.c
# "TEST=basic_tests" - perform basic tests only (no CGI, SSI..)
test: do_test
do_test:
	perl test/test.pl $(TEST)

release: clean
	F=yasslEWS-`perl -lne '/define\s+YASSLEWS_VERSION\s+"(\S+)"/ and print $$1' yasslEWS.c`.tgz ; cd .. && tar --exclude \*.hg --exclude \*.svn --exclude \*.swp --exclude \*.nfs\* -czf x yasslEWS && mv x yasslEWS/$$F

clean:
	rm -rf *.o *.core $(PROG) *.obj *.so $(PROG).txt *.dSYM *.tgz
