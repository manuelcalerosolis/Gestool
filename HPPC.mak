HB=\xHarbourPPC
HBINCLUDE=\xHarbourPPC\Include
HBLIB=\xHarbourPPC\Lib

FWINCLUDE=\fwppc\Include
FWLIB=\fwppc\Lib

RESOURCE=.\Resource

BORLAND=\vce
BORLANDLIB=\vce\lib\arm

OBJ 			= 		ObjPpc
SOURCEPRG 		= 		Prg
SOURCEC 		=		C

.path.prg       = 		.\$(SOURCEPRG)
.path.c       	= 		.\$(SOURCEC)
.path.obj       = 		.\$(OBJ)

PRG             =       \
Factu.prg               \

OBJS            =       \
Factu.obj               \

.PRG.OBJ:
   $(HB)\Bin\Harbour $< /n /p /es2 /D__PDA__ /D__PDAPRE__ /i$(FWINCLUDE) /i$(HBINCLUDE) /o$(OBJ)\$&.c
   $(BORLAND)\bin\clarm -W3 -c /DARM /DUNICODE /D__PDA__ /D__PDAPRE__ /I$(HBINCLUDE) /I\vce\include\arm /I..\include /Fo$(OBJ)\$&.obj $(OBJ)\$&.c

Factu.Exe      : $( PRG:.PRG=.OBJ )

.C.OBJ:
   $(BORLAND)\bin\clarm -W3 -c /DARM /DUNICODE /D__PDA__ /D__PDAPRE__ /I$(HBINCLUDE) /I\vce\include\arm /I..\include /Fo$(OBJ)\$&.obj $&.c

Factu.Exe      : $( C:.C=.OBJ )

Factu.Exe: $(RESOURCE)\GstPda.Res $(OBJS)
   $(BORLAND)\Bin\Link @&&|
$(OBJ)\Factu.obj
$(FWLIB)\FiveCE.lib
$(FWLIB)\FiveCEC.lib
$(HBLIB)\rtl.lib
$(HBLIB)\vm.lib
$(HBLIB)\gtgui.lib
$(HBLIB)\lang.lib
$(HBLIB)\macro.lib
$(HBLIB)\rdd.lib
$(HBLIB)\dbfntx.lib
$(HBLIB)\dbfcdx.lib
$(HBLIB)\dbffpt.lib
$(HBLIB)\hbsix.lib
$(HBLIB)\debug.lib
$(HBLIB)\common.lib
$(HBLIB)\pp.lib
$(HBLIB)\codepage.lib
$(HBLIB)\hbpcre.lib
$(BORLANDLIB)\coredll.lib
$(BORLANDLIB)\corelibc.lib
$(BORLANDLIB)\aygshell.lib
$(BORLANDLIB)\ws2.lib
$(BORLANDLIB)\mfcce400.lib
$(BORLANDLIB)\ole32.lib
$(BORLANDLIB)\oleaut32.lib
$(BORLANDLIB)\olece400.lib
$(BORLANDLIB)\uuid.lib
$(BORLANDLIB)\ceshell.lib
$(BORLANDLIB)\commctrl.lib
$(BORLANDLIB)\wininet.lib
$(RESOURCE)\GstPda.Res
$(RESOURCE)\MenuPda.Res
$(RESOURCE)\GstImage1.Res
$(RESOURCE)\GstImage2.Res
| /SUBSYSTEM:WINDOWSCE,4.20 /MACHINE:ARM