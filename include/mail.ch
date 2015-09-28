// FiveWin - Windows MAPI - mail services - xBase Commands

#ifndef _MAIL_CH
#define _MAIL_CH

//----------------------------------------------------------------------------//

#xcommand DEFINE MAIL [<oMail>] ;
             [ SUBJECT <cSubject> ] ;
             [ TEXT <cText> ] ;
             [ TYPE <cType> ] ;
             [ DATE <dDate> ] ;
             [ TIME <cTime> ] ;
             [ CONVERSATION <cConversation> ] ;
             [ <rec: RECEIPT> ] ;
             [ <user: FROM USER> ] ;
             [ FILES <cFileName1> ,<cDescript1> ;
                 [,<cFileNameN> ,<cDescriptN> ] ] ;
             [ ORIGIN <cOrigin> [,<cOriginAddress>] ] ;
             [ TO <cTarget1> [,<cTargetAddress1>] ;
                [,<cTargetN> [,<cTargetAddressN>] ] ] ;
       => ;
          [ <oMail> := ] TMail():New( <cSubject>, <cText>, <cType>,;
             <cConversation>, <dDate>, <cTime>, <.rec.>, <.user.>,;
             [ \{<cOrigin>, <cOriginAddress>\} ],;
             \{ [ \{<cTarget1>,<cTargetAddress1>\} ] ;
                [,\{<cTargetN>,<cTargetAddressN>\} ] \},;
             \{ [ \{<cFileName1>,<cDescript1>\} ] ;
                [,\{<cFileNameN>,<cDescriptN>\} ] \} )

#xcommand ACTIVATE MAIL <oMail> => <oMail>:Activate()

#xcommand SEND MAIL <oMail> => <oMail>:Activate()

//----------------------------------------------------------------------------//

#endif
