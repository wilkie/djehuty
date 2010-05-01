
MY_ARCH := $(shell uname)

DC = ldc
OBJCC = gcc
DFLAGS = 

# can be changed
PLATFORM = WINDOWS

LFLAGS_LINUX = -Iplatform/unix -L-lX11 -L-lc -L-lm -L-lrt -L-lcairo -L-lpango-1.0 -L-lpangocairo-1.0 -L-lGL -L-llua5.1 -L-lncurses -J./tests
LFLAGS_MAC = -lobjc -framework Cocoa -framework Foundation -framework OpenGL -lncurses -llua5.1
LFLAGS_WIN = -Iplatform/win

ifeq (${MY_ARCH},MINGW32_NT-5.1)
	OBJEXT = .obj
	PLATFORM = WINDOWS
else
ifeq (${MY_ARCH},MINGW32_NT-6.0)
	OBJEXT = .obj
	PLATFORM = WINDOWS
else
ifeq (${MY_ARCH},MINGW32_NT-6.1)
	OBJEXT = .obj
	PLATFORM = WINDOWS
else
	OBJEXT = .o
	PLATFORM = NIX
endif
endif
endif

DFILES_PLATFORM_MAC = platform/osx/platform/application.d platform/osx/scaffold/system.d platform/osx/scaffold/thread.d platform/osx/scaffold/time.d platform/osx/scaffold/console.d platform/osx/platform/definitions.d platform/osx/common.d platform/osx/main.d platform/osx/scaffold/opengl.d platform/osx/scaffold/graphics.d platform/osx/scaffold/file.d platform/osx/scaffold/socket.d platform/osx/scaffold/window.d platform/osx/scaffold/color.d platform/osx/scaffold/menu.d platform/osx/scaffold/wave.d platform/osx/scaffold/view.d platform/osx/scaffold/directory.d platform/osx/gui/apploop.d binding/c.d binding/ncurses/ncurses.d platform/osx/scaffold/tui.d platform/osx/platform/vars/tui.d platform/osx/platform/vars/file.d platform/unix/common.d platform/osx/platform/vars/thread.d platform/osx/platform/vars/directory.d platform/osx/platform/vars/view.d platform/osx/platform/vars/semaphore.d platform/osx/platform/vars/condition.d platform/osx/platform/vars/window.d
OBJC_FILES = platform/osx/objc/window.m platform/osx/objc/app.m platform/osx/objc/view.m

DFILES_PLATFORM_UNIX = platform/unix/platform/application.d platform/unix/scaffold/system.d platform/unix/scaffold/thread.d platform/unix/scaffold/time.d platform/unix/scaffold/console.d platform/unix/platform/definitions.d platform/unix/common.d binding/cairo/cairo.d binding/x/Xlib.d binding/x/X.d platform/unix/main.d platform/unix/scaffold/opengl.d platform/unix/scaffold/graphics.d platform/unix/scaffold/file.d platform/unix/scaffold/socket.d platform/unix/scaffold/window.d platform/unix/scaffold/color.d platform/unix/scaffold/menu.d platform/unix/scaffold/wave.d platform/unix/scaffold/view.d platform/unix/scaffold/directory.d platform/unix/gui/apploop.d platform/unix/gui/osbutton.d binding/c.d binding/ncurses/ncurses.d platform/unix/scaffold/tui.d platform/unix/platform/vars/tui.d
DFILES_PLATFORM_WIN = binding/win32/gdipluscolormatrix.d binding/win32/gdiplusinit.d binding/win32/gdiplusmem.d binding/win32/gdiplusbase.d binding/win32/gdiplusflat.d binding/win32/gdiplusstringformat.d binding/win32/gdiplusmetafile.d binding/win32/gdipluslinecaps.d binding/win32/gdiplusimagecodec.d binding/win32/gdiplusgpstubs.d binding/win32/gdiplusfontfamily.d binding/win32/gdiplusfontcollection.d binding/win32/gdiplusfont.d binding/win32/gdiplusenums.d binding/win32/gdiplustypes.d binding/win32/gdiplusregion.d binding/win32/gdipluscolor.d binding/win32/gdiplusbitmap.d binding/win32/gdipluseffects.d binding/win32/gdipluscachedbitmap.d binding/win32/gdipluspath.d binding/win32/gdiplusbrush.d binding/win32/gdipluspen.d binding/win32/gdiplusgraphics.d binding/win32/ws2def.d binding/win32/winsock2.d binding/win32/inaddr.d binding/win32/mmsystem.d  binding/win32/wincon.d binding/win32/winbase.d binding/win32/winuser.d binding/win32/windef.d binding/win32/wingdi.d platform/win/platform/application.d platform/win/platform/vars/tui.d platform/win/scaffold/tui.d platform/win/scaffold/system.d platform/win/main.d platform/win/common.d platform/win/platform/vars/menu.d platform/win/platform/vars/view.d platform/win/platform/vars/semaphore.d platform/win/platform/vars/mutex.d platform/win/platform/vars/region.d platform/win/platform/vars/library.d platform/win/platform/vars/wave.d platform/win/platform/vars/pen.d platform/win/platform/vars/brush.d platform/win/platform/vars/window.d platform/win/platform/vars/file.d platform/win/platform/vars/directory.d platform/win/platform/vars/font.d platform/win/platform/vars/socket.d platform/win/scaffold/console.d platform/win/platform/definitions.d platform/win/scaffold/wave.d platform/win/scaffold/directory.d platform/win/scaffold/graphics.d platform/win/scaffold/thread.d platform/win/scaffold/menu.d platform/win/scaffold/window.d platform/win/scaffold/view.d platform/win/scaffold/color.d platform/win/scaffold/file.d platform/win/scaffold/socket.d platform/win/gui/osbutton.d platform/win/scaffold/time.d platform/win/widget.d platform/win/scaffold/opengl.d platform/win/widget.d platform/win/gui/apploop.d
DFILES_PLATFORM_XOMB = platform/xomb/main.d platform/xomb/common.d platform/xomb/scaffold.d platform/xomb/vars.d platform/xomb/console.d platform/xomb/definitions.d platform/xomb/scaffolds/wave.d platform/xomb/scaffolds/graphics.d platform/xomb/scaffolds/thread.d platform/xomb/scaffolds/menu.d platform/xomb/scaffolds/window.d platform/xomb/scaffolds/view.d platform/xomb/scaffolds/color.d platform/xomb/scaffolds/file.d platform/xomb/scaffolds/socket.d platform/xomb/scaffolds/app.d platform/xomb/scaffolds/time.d platform/xomb/oscontrolinterface.d

DFILES_ANALYZING = analyzing/debugger.d
DFILES_CORE = core/locales/en_us.d core/locales/fr_fr.d core/date.d core/locale.d core/variant.d core/list.d core/exception.d core/event.d core/library.d core/system.d core/random.d core/regex.d core/arguments.d core/definitions.d core/application.d core/time.d core/timezone.d core/unicode.d core/endian.d core/stream.d core/string.d core/main.d core/color.d
DFILES_GUI = gui/container.d gui/trackbar.d gui/radiogroup.d gui/progressbar.d gui/togglefield.d gui/listfield.d gui/listbox.d gui/vscrollbar.d gui/hscrollbar.d gui/button.d gui/textfield.d gui/window.d gui/widget.d gui/application.d
DFILES_UTILS = utils/stack.d utils/linkedlist.d utils/fibonacci.d utils/heap.d
DFILES_PARSING = parsing/d/trees.d parsing/d/addexprunit.d parsing/d/andexprunit.d parsing/d/assignexprunit.d parsing/d/blockstmtunit.d parsing/d/switchstmtunit.d parsing/d/casestmtunit.d parsing/d/defaultstmtunit.d parsing/d/breakstmtunit.d parsing/d/continuestmtunit.d parsing/d/gotostmtunit.d parsing/d/returnstmtunit.d parsing/d/volatilestmtunit.d parsing/d/throwstmtunit.d parsing/d/postfixexprlistunit.d parsing/d/cmpexprunit.d parsing/d/conditionalexprunit.d parsing/d/declarationunit.d parsing/d/expressionunit.d parsing/d/importdeclunit.d parsing/d/isexprunit.d parsing/d/lexer.d parsing/d/logicalandexprunit.d parsing/d/logicalorexprunit.d parsing/d/moduledeclunit.d parsing/d/moduleunit.d parsing/d/mulexprunit.d parsing/d/nodes.d parsing/d/orexprunit.d parsing/d/parser.d parsing/d/postfixexprunit.d parsing/d/primaryexprunit.d parsing/d/shiftexprunit.d parsing/d/staticunit.d parsing/d/declaratorunit.d parsing/d/declaratorsuffixunit.d parsing/d/declaratortypeunit.d parsing/d/tokens.d parsing/d/enumdeclunit.d parsing/d/typeunit.d parsing/d/enumbodyunit.d parsing/d/aggregatedeclunit.d parsing/d/aggregatebodyunit.d parsing/d/classbodyunit.d parsing/d/templatebodyunit.d parsing/d/interfacebodyunit.d parsing/d/classdeclunit.d parsing/d/interfacedeclunit.d parsing/d/constructorunit.d parsing/d/destructorunit.d parsing/d/parameterlistunit.d parsing/d/functionbodyunit.d parsing/d/staticifunit.d parsing/d/versionunit.d parsing/d/debugunit.d parsing/d/unittestunit.d parsing/d/parameterunit.d parsing/d/basictypeunit.d parsing/d/statementunit.d parsing/d/pragmastmtunit.d parsing/d/staticassertunit.d parsing/d/foreachstmtunit.d parsing/d/scopedstmtunit.d parsing/d/forstmtunit.d parsing/d/typedeclarationunit.d parsing/d/unaryexprunit.d parsing/d/xorexprunit.d parsing/ast.d parsing/lexer.d parsing/token.d parsing/parser.d parsing/options.d parsing/cfg.d parsing/parseunit.d
DFILES = djehuty.d
DFILES_BINARY_CODECS = decoders/binary/decoder.d decoders/binary/base64.d decoders/binary/yEnc.d decoders/binary/deflate.d decoders/binary/zlib.d
DFILES_IMAGE_CODECS = decoders/image/decoder.d decoders/image/all.d decoders/image/bmp.d decoders/image/png.d decoders/image/gif.d decoders/image/jpeg.d
DFILES_AUDIO_CODECS = decoders/audio/decoder.d decoders/audio/all.d decoders/audio/mp2.d decoders/audio/mp3.d decoders/audio/wav.d decoders/audio/mp3Huffman.d decoders/audio/mpegCommon.d
DFILES_GRAPHICS = graphics/path.d graphics/gradient.d graphics/bitmap.d graphics/view.d graphics/graphics.d graphics/convexhull.d graphics/region.d graphics/brush.d graphics/font.d graphics/pen.d
DFILES_NETWORKING = networking/http.d networking/telnet.d networking/irc.d networking/ftp.d
DFILES_IO = io/file.d io/directory.d io/console.d io/audio.d io/wavelet.d io/socket.d
DFILES_RESOURCE = resource/sound.d resource/image.d resource/resource.d resource/menu.d
DFILES_CODEC = decoders/decoder.d
DFILES_HASHES = hashes/digest.d hashes/all.d hashes/md5.d hashes/sha1.d hashes/sha224.d hashes/sha256.d
DFILES_CONSOLE = console/prompt.d
DFILES_TUI = tui/filebox.d tui/container.d tui/dialog.d tui/window.d tui/application.d tui/widget.d tui/telnet.d tui/buffer.d tui/vt100.d tui/listbox.d tui/textfield.d tui/label.d tui/textbox.d tui/codebox.d tui/tabbox.d
DFILES_SCRIPTING = scripting/lua.d
DFILES_BINDING = binding/opengl/gl.d binding/opengl/glu.d binding/lua.d
DFILES_INTERFACES = interfaces/container.d
DFILES_MATH = math/currency.d math/fixed.d math/integer.d math/common.d math/vector.d math/matrix.d math/mathobject.d
DFILES_OPENGL = opengl/window.d opengl/texture.d opengl/light.d
DFILES_SPECS = specs/test.d
DFILES_TESTING = testing/dspec.d testing/support.d testing/logic.d
DFILES_SYNCH = synch/atomic.d synch/condition.d synch/barrier.d synch/mutex.d synch/semaphore.d synch/thread.d synch/timer.d

DFILES_RSC =

OBJS_CORE = $(DFILES:.d=.o) $(DFILES_RESOURCE:.d=.o) $(DFILES_IO:.d=.o) $(DFILES_SYNCH:.d=.o) $(DFILES_PARSING:.d=.o) $(DFILES_OPENGL:.d=.o) $(DFILES_TUI:.d=.o) $(DFILES_ANALYZING:.d=.o) $(DFILES_SCRIPTING:.d=.o) $(DFILES_BINDING:.d=.o) $(DFILES_SPECS:.d=.o) $(DFILES_TESTING:.d=.o) $(DFILES_MATH:.d=.o) $(DFILES_GRAPHICS:.d=.o) $(DFILES_HASHES:.d=.o) $(DFILES_RSC:.d=.o) $(DFILES_NETWORKING:.d=.o) $(DFILES_INTERFACES:.d=.o) $(DFILES_UTILS:.d=.o) $(DFILES_CONSOLE:.d=.o) $(DFILES_BINARY_CODECS:.d=.o) $(DFILES_CODEC:.d=.o) $(DFILES_IMAGE_CODECS:.d=.o) $(DFILES_AUDIO_CODECS:.d=.o) $(DFILES_CORE:.d=.o) $(DFILES_GUI:.d=.o) $(DFILES_PARSERS:.d=.o)

OBJS_MAC = $(OBJS_CORE) $(DFILES_PLATFORM_MAC:.d=.o) $(OBJC_FILES:.m=.o)

OBJS_LINUX = $(OBJS_CORE) $(DFILES_PLATFORM_UNIX:.d=.o)

OBJS_WIN = $(OBJS_CORE:.o=.obj) $(DFILES_PLATFORM_WIN:.d=.obj)

OBJS_XOMB = $(OBJS_CORE:.o=_xomb.obj) $(DFILES_PLATFORM_XOMB:.d=_xomb.obj)

TOOLS_DSPEC = tools/dspec/main.d tools/dspec/feeder.d tools/dspec/filelist.d tools/dspec/ast.d tools/dspec/parser.d tools/dspec/parseunit.d tools/dspec/output.d
TOOLS_DSCRIBE = tools/dscribe/main.d tools/dscribe/lexer.d
TOOLS_TESTS = runtests.d

EXAMPLES_TUITETRIS = examples/TuiTetris/app.d examples/TuiTetris/gamewindow.d examples/TuiTetris/tetris.d examples/TuiTetris/gamecontrol.d

EXAMPLES_MOREDUCKS = examples/MoreDucks/MoreDucks.d

EXAMPLES_SNAKE = examples/Snake/app.d examples/Snake/constants.d examples/Snake/game.d examples/Snake/posn.d examples/Snake/snake.d examples/Snake/win.d

libdeps_linux: $(OBJS_LINUX)
	@echo ">> framework compilation complete. <<"

libdeps_mac: $(OBJS_MAC)
	@echo ">> framework compilation complete. <<"

libdeps_win: $(OBJS_WIN)
	@echo ">> framework compilation complete. <<"

libdeps_xomb: $(OBJS_XOMB)
	@echo ">> framework compilation complete. <<"

# compile D files
%.o: %.d
	@echo \-\-\-\> $<
ifeq (${MY_ARCH},Darwin)
	@$(DC) $< $(DFLAGS) -mtriple=i386-apple-darwin10 -d-version=PlatformOSX -c -of$@ -O3 -J./tests -I./platform/osx 
else
ifeq ($(PLATFORM),"WINDOWS")
else
		@$(DC) $< $(DFLAGS) -d-version=PlatformLinux -c -of$@ -O3 -J./tests -I./platform/unix
endif
endif

%_xomb.obj: %.d
	@echo \-\-\-\> $<
ifeq (${MY_ARCH},Darwin)
else
ifeq ($(PLATFORM),WINDOWS)
	@dmd.exe -w -c -of$@ -J./tests -version=PlatformXOmB -unittest $<
else
endif
endif

%.obj: %.d
	@echo \-\-\-\> $<
ifeq (${MY_ARCH},Darwin)
else
ifeq ($(PLATFORM),WINDOWS)
	@dmd.exe -w -c -of$@ -J./tests $(DFLAGS) -version=PlatformWindows -I. -Iplatform/win -unittest $<
else
endif
endif

# compile Objective-C files
%.o: %.m
	@echo \-\-\-\> \(objc\) $<
ifeq (${MY_ARCH},Darwin)
	@$(OBJCC) $(OBJCFLAGS) -m32 -c $< -o $@ -O3
else
endif

$(DFILES_SPECS):
	touch $(DFILES_SPECS)

# initiates the compilation of the main framework
lib:
	@echo compiling framework... Target: ${MY_ARCH}
ifeq (${MY_ARCH},Darwin)
	@echo OS X detected...
	@make libdeps_mac
else
ifeq ($(PLATFORM),WINDOWS)
	@echo Windows detected...
	@make libdeps_win
else
	@echo UNIX detected...
	@make libdeps_linux
endif
endif



app: libdeps_xomb

	@echo compiling test program...
ifeq (${MY_ARCH},MINGW32_NT-6.0)
	@lib -c -p64 djehutyxomb.lib $(OBJS_XOMB) $(LFLAGS_WIN)
endif
ifeq (${MY_ARCH},MINGW32_NT-6.1)
	@lib -c -p64 djehutyxomb.lib $(OBJS_XOMB) $(LFLAGS_WIN)
endif

	@echo linking...
ifeq (${MY_ARCH},MINGW32_NT-6.0)
	@dmd.exe -w -version=PlatformXOmB -unittest app.d djehutyxomb.lib
endif
ifeq (${MY_ARCH},MINGW32_NT-6.1)
	@dmd.exe -w -version=PlatformXOmB -unittest app.d djehutyxomb.lib
endif





# compiles the library framework, and then the test app
all: lib

	@echo linking...
ifeq (${MY_ARCH},Darwin)
	@$(DC) winsamp.d $(DFLAGS) -mtriple=i386-apple-darwin10 -d-version=PlatformOSX -c -ofwinsamp.o -O3 -J./tests -I./platform/osx 
	@$(OBJCC) -m32 $(OBJS_MAC) winsamp.o -o winsamp $(LFLAGS_MAC) -ltango
else
ifeq ($(PLATFORM),WINDOWS)
	dmd.exe -w -version=PlatformWindows winsamp.d $(OBJS_WIN) $(LFLAGS_WIN)
else
	@$(DC) $(LFLAGS_LINUX) -d-version=PlatformLinux winsamp.d $(OBJS_LINUX)
endif
endif

dspec: lib

	@echo compiling DSpec and linking...
ifeq (${MY_ARCH},Darwin)
	#@$(DC) $(LFLAGS_MAC) -o winsamp winsamp.o $(OBJS_MAC)
	for i in ${TOOLS_DSPEC}; do $(DC) "$${i}" $(DFLAGS) -mtriple=i386-apple-darwin10 -d-version=PlatformOSX -c -of$${i}.o -O3 -J./tests -I./tools/dspec -I./platform/osx; done
	$(OBJCC) -m32 $(OBJS_MAC) `ls tools/dspec/*.o` -o dspec $(LFLAGS_MAC) -ltango
else
ifeq ($(PLATFORM),WINDOWS)
	@dmd.exe -w -version=PlatformWindows -ofdspec.exe $(TOOLS_DSPEC) $(OBJS_WIN) $(LFLAGS_WIN)
else
	@$(DC) $(LFLAGS_LINUX) -ofdspec -d-version=PlatformLinux $(TOOLS_DSPEC) $(OBJS_LINUX)
endif
endif

dscribe: lib

	@echo compiling DScribe and linking...
ifeq (${MY_ARCH},Darwin)
	#@$(DC) $(LFLAGS_MAC) -o winsamp winsamp.o $(OBJS_MAC)
else
ifeq ($(PLATFORM),WINDOWS)
	@dmd.exe -w -version=PlatformWindows -ofdscribe.exe $(TOOLS_DSCRIBE) $(OBJS_WIN) $(LFLAGS_WIN)
else
	@$(DC) $(LFLAGS_LINUX) -ofdscribe -d-version=PlatformLinux $(TOOLS_DSCRIBE) $(OBJS_LINUX)
endif
endif

tuitetris: lib

	@echo compiling TuiTetris example and linking...
ifeq (${MY_ARCH},Darwin)
	for i in ${EXAMPLES_TUITETRIS}; do $(DC) "$${i}" $(DFLAGS) -mtriple=i386-apple-darwin10 -d-version=PlatformOSX -c -of$${i}.o -O3 -J./tests -I./examples/TuiTetris -I./platform/osx; done
	$(OBJCC) -m32 $(OBJS_MAC) `ls examples/TuiTetris/*.o` -o tuitetris $(LFLAGS_MAC) -ltango
else
ifeq ($(PLATFORM),WINDOWS)
	@dmd.exe -w -version=PlatformWindows -oftuitetris.exe $(EXAMPLES_TUITETRIS) $(OBJS_WIN) $(LFLAGS_WIN)
else
	@$(DC) $(LFLAGS_LINUX) -oftuitetris -d-version=PlatformLinux $(EXAMPLES_TUITETRIS) $(OBJS_LINUX)
endif
endif

moreducks: lib

	@echo compiling More Ducks example and linking...
ifeq (${MY_ARCH},Darwin)
	for i in ${EXAMPLES_MOREDUCKS}; do $(DC) "$${i}" $(DFLAGS) -mtriple=i386-apple-darwin10 -d-version=PlatformOSX -c -of$${i}.o -O3 -J./tests -I./examples/MoreDucks -I./platform/osx; done
	$(OBJCC) -m32 $(OBJS_MAC) `ls examples/MoreDucks/*.o` -o moreducks $(LFLAGS_MAC) -ltango
else
ifeq ($(PLATFORM),WINDOWS)
	@dmd.exe -w -version=PlatformWindows -ofmoreducks.exe $(EXAMPLES_MOREDUCKS) $(OBJS_WIN) $(LFLAGS_WIN)
else
	@$(DC) $(LFLAGS_LINUX) -ofmoreducks -d-version=PlatformLinux $(EXAMPLES_MOREDUCKS) $(OBJS_LINUX)
endif
endif

snake: lib

	@echo compiling snake example and linking...
ifeq (${MY_ARCH},Darwin)
	#@$(DC) $(LFLAGS_MAC) -o snake $(OBJS_MAC)
else
ifeq ($(PLATFORM),WINDOWS)
	@dmd.exe -w -version=PlatformWindows -ofsnake.exe $(EXAMPLES_SNAKE) $(OBJS_WIN) $(LFLAGS_WIN)
else
	@$(DC) $(LFLAGS_LINUX) -ofsnake -d-version=PlatformLinux $(EXAMPLES_SNAKE) $(OBJS_LINUX)
endif
endif

tests: lib
	@echo compiling Test Suite...
ifeq (${MY_ARCH},Darwin)
	@$(DC) runtests.d $(DFLAGS) -mtriple=i386-apple-darwin10 -d-version=PlatformOSX -c -ofruntests.o -O3 -J./tests -I./platform/osx 
	@$(OBJCC) -m32 $(OBJS_MAC) runtests.o -o runtests $(LFLAGS_MAC) -ltango
else
ifeq ($(PLATFORM),WINDOWS)
	@dmd.exe -w -version=PlatformWindows -ofruntests.exe $(TOOLS_TESTS) $(OBJS_WIN) $(LFLAGS_WIN)
else
	@$(DC) $(LFLAGS_LINUX) -ofruntests -d-version=PlatformLinux $(TOOLS_TESTS) $(OBJS_LINUX)
endif
endif



clean:
ifeq (${MY_ARCH},Darwin)
	rm -f $(OBJS_MAC)
else
ifeq ($(PLATFORM),WINDOWS)
	rm -f $(OBJS_WIN)
else
	rm -f $(OBJS_LINUX)
endif
endif
