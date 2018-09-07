HB                   = 	\harbour_bcc7\

HBINCLUDE            = 	\harbour_bcc7\include
FWINCLUDE            = 	\fwh1801\include
GTINCLUDE            = 	.\include

HBLIB                = 	\harbour_bcc7\lib
FWLIB                = 	\fwh1801\lib

RESOURCE             = 	.\resource

BORLAND              = 	\bcc73
BORLANDLIB           = 	\bcc73\lib

IMG2PDFLIB           = 	\img2Pdf

OBJ                  = 	obj1801

SOURCEPRG            = 	.\Servicio;
SOURCEC 				   =	.\C

PPO 					   = 	ppo1801

EXE 					   = 	bin\$Servicio.exe

TARGETPRG 				= Servicio.prg
TARGETOBJ 				= Servicio.obj

.path.prg      		=	.\$(SOURCEPRG)
.path.c       			=	.\$(SOURCEC)
.path.obj      		=	.\$(OBJ)

PRG            		=  \
Servicio.prg 				\
BaseController.prg 		\
BaseService.prg 			\
Status_Controller.prg 	\
Status_Service.prg 		\

OBJS            		=	\
Servicio.obj 				\
BaseController.obj 		\
BaseService.obj         \
Status_Controller.obj 	\
Status_Service.obj      \

.PRG.OBJ:
  	$(HB)\Bin\Harbour $? /n /p$(PPO)\$&.ppo /w1 /b /i$(HBINCLUDE) /o$(OBJ)\$&.c
  	$(BORLAND)\Bin\Bcc32 -c -tWM -I$(HBINCLUDE) -o$(OBJ)\$& $(OBJ)\$&.c

$(EXE)                  : $( PRG:.PRG=.OBJ )

.C.OBJ:
  	$(BORLAND)\Bin\Bcc32 -c -tWM -DHB_API_MACROS -I$(HBINCLUDE) -o$(OBJ)\$& $<

$(EXE)                  : $( C:.C=.OBJ )

$(EXE) 						: $(OBJS)
  	$(BORLAND)\Bin\iLink32 @&&|
  	-Gn -mt -aa -Tpe -s -r -m -V4.0   		+
(BORLAND)\lib\c0w32.obj        			+
$(OBJ)\Servicio.obj 				 			+
$(OBJ)\BaseController.obj 					+
$(OBJ)\BaseService.obj         			+
$(OBJ)\Status_Controller.obj 				+
$(OBJ)\Status_Service.obj
$<,$*
$(HBLIB)\ssleay32.lib               	+
$(HBLIB)\libeay32.lib               	+ 
$(HBLIB)\gtwin.lib               		+ 
$(HBLIB)\gtwvg.lib               		+ 
$(HBLIB)\hbmisc.lib                		+ 
$(HBLIB)\hbrdd.lib               		+ 
$(HBLIB)\rddntx.lib              		+
$(HBLIB)\rddcdx.lib              		+
$(HBLIB)\rddfpt.lib              		+
$(HBLIB)\hbsix.lib               		+ 
$(HBLIB)\hbusrrdd.lib            		+ 
$(HBLIB)\hbdebug.lib             		+
$(HBLIB)\hbcommon.lib            		+
$(HBLIB)\b32\rddads.lib          		+
$(HBLIB)\ace32.lib               		+
$(BORLANDLIB)\cw32mt.lib         		+ 
$(BORLANDLIB)\uuid.lib           		+ 
$(BORLANDLIB)\import32.lib       		+ 
$(BORLANDLIB)\ws2_32.lib         		+ 
$(BORLANDLIB)\psdk\odbc32.lib    		+
$(BORLANDLIB)\psdk\nddeapi.lib   		+
$(BORLANDLIB)\psdk\iphlpapi.lib  		+
$(BORLANDLIB)\psdk\msimg32.lib   		+
$(BORLANDLIB)\psdk\psapi.lib     		+ 
$(BORLANDLIB)\psdk\rasapi32.lib  		+
$(BORLANDLIB)\psdk\gdiplus.lib   		+
$(BORLANDLIB)\psdk\urlmon.lib    		+
$(BORLANDLIB)\psdk\shell32.lib,
|