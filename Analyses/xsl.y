%{

using namespace std;
#include <cstring>
#include <string>
#include <cstdio>
#include <cstdlib>

#include "commun.h"
#include "yy.tab_xsl.h"
#include "XML/XMLNode.h"
#include "XML/XMLTag.h"
#include "XML/XMLAttr.h"
#include "XML/XMLPCDATA.h"
#include "analyse.h"

XMLTag * xsl_root;
XMLTag * xsl_current;

%}

%union {
   char * s;
   ElementName * en;  /* le nom d'un element avec son namespace */
}

%token EQ SLASH CLOSE END CLOSESPECIAL DOCTYPE
%token <s> ENCODING VALUE DATA COMMENT NAME NSNAME
%token <en> NSSTART START STARTSPECIAL

%type <s> debut

%%

document
 : refXSL declarations element misc_seq_opt 
 ;
refXSL
 : STARTSPECIAL NAME EQ VALUE NAME EQ VALUE CLOSESPECIAL
|/*empty*/
;
misc_seq_opt
 : misc_seq_opt misc
 | /*empty*/
 ;
misc
 : COMMENT		
 ;

declarations
 : declaration
 | /*empty*/
 ;
 
declaration
 : DOCTYPE debut NAME VALUE CLOSE
 ;
debut
: NAME
|NSNAME
;
element
 : start
   empty_or_content
 ;
start
 : START
    {
        if (xsl_current == NULL )
        {
            xsl_root = new XMLTag($1->second);
            xsl_current = xsl_root;
        }
        else
        {
            XMLTag * newTag = new XMLTag($1->second);
            xsl_current->add_child( newTag );
            xsl_current = newTag;
        }
    }
 | NSSTART
    {
        if (xsl_current == NULL )
        {
            xsl_root = new XMLTag($1->second);
            xsl_current = xsl_root;
        }
        else
        {
            XMLTag * newTag = new XMLTag($1->second);
            xsl_current->add_child( newTag );
            xsl_current = newTag;
        }
    };
empty_or_content
 : SLASH CLOSE { xsl_current = xsl_current->get_parent(); }
 | attributes 
   close_content_and_end 
   name_or_nsname_opt CLOSE 
 ;
attributes
: attributes single_attribute
| /*empty*/
;
single_attribute
: debut EQ VALUE
    {
        XMLAttr * newAttr = new XMLAttr( $1, $3 );
        xsl_current->add_attr( newAttr );
    };
name_or_nsname_opt 
 : NAME     
 | NSNAME  
 | /* empty */
 ;
close_content_and_end
 : CLOSE			
   content 
   END { xsl_current = xsl_current->get_parent(); }
 ;
content 
 : content DATA	{ XMLPCDATA * newData = new XMLPCDATA( $2 ) }
 | content misc        
 | content element      
 | /*empty*/         
 ;
%%


