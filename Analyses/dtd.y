%{
using namespace std;
#include <stack>
#include <list>
#include <cstring>
#include <cstdio>
#include <cstdlib>


void yyerror(char *msg);
int yywrap(void);
int yylex(void);
%}

%union { 
   char *s; 
   }

%token ELEMENT ATTLIST CLOSE OPENPAR CLOSEPAR COMMA PIPE FIXED EMPTY ANY PCDATA AST QMARK PLUS CDATA
%token <s> NAME TOKENTYPE DECLARATION STRING
%%

main: dtd                           
    ;
dtd: dtd ATTLIST NAME 
     att_definition CLOSE            
   | dtd element
   | /* empty */                     
   ;

element
: ELEMENT NAME contenu CLOSE
;
contenu
: EMPTY
| ANY
| mixed
| children
;
mixed
:OPENPAR PCDATA contenu_mixed CLOSEPAR
;
contenu_mixed
:contenu_mixed PIPE NAME
|PIPE NAME
|/*empty*/
;
children
: sequence_ou_choix cardinalite
;
cardinalite
: QMARK
| AST
| PLUS
| /*empty*/
;
sequence_ou_choix
: sequence
| choix
;
sequence
:OPENPAR liste_sequence CLOSEPAR
;
liste_sequence
: item
| liste_sequence COMMA item
;
item
: NAME cardinalite
| children
;
choix
: OPENPAR liste_choix_plus CLOSEPAR
;
liste_choix_plus
: liste_choix PIPE item
;
liste_choix
: liste_choix PIPE item
| item
;
att_definition
: att_definition attribut
| /* empty */
;
attribut
: NAME att_type defaut_declaration
;
att_type
: CDATA    
| TOKENTYPE
| type_enumere
;

type_enumere
: OPENPAR liste_enum_plus CLOSEPAR
;
liste_enum_plus
: liste_enum PIPE item_enum
;
liste_enum
: item_enum               
| liste_enum PIPE item_enum
;
item_enum
: NAME
;
defaut_declaration
: DECLARATION 
| STRING     
| FIXED STRING 
;
%%

