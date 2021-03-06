#include <iostream>
#include <vector>
#include <XMLTag.h>
#include <XMLPCDATA.h>
#include <XMLValidateWithDTDVisitor.h>
#include <DTDElement.h>
#include <DTD.h>
#include <DTDAttribute.h>
#include <DTDRule.h>

using namespace std;

DTD::DTD() {
	elements = new vector<DTDElement*>();
	validate_visitor = new XMLValidateWithDTDVisitor();
	validate_visitor->setDTD(this);
}

void DTD::addElement(DTDElement* element) {
    if(getElementByName(element->getName()) == NULL)
        elements->push_back(element);
    else
        ;//throw ElementAlreadyDefinedException
}

vector<DTDElement*>* DTD::getElements() {
    return elements;
}

DTDElement* DTD::getElementByName(string name) {
    for (unsigned int i = 0; i < elements->size(); i++) {
        if ((*elements)[i]->getName() == name)
            return (*elements)[i];
    }
    return NULL;
}

bool DTD::validate(XMLNode* node) {
    XMLTag *tag;
    XMLPCDATA *pcdata;
    vector<XMLNode *>* children;
    if ( node == NULL )
        return true;
    switch (node->getType()) {
        case NODE_XMLTAG:
            tag = static_cast<XMLTag*> (node);
            children = tag->getChildren();
            for (unsigned int i = 0; i < children->size(); i++)
                validate((*children)[i]);
            try {
                return tag->accept(validate_visitor);
            }
            catch(exception &e) {
                cout << "[ERROR] " << e.what() << endl;
                return false;
            }
            break;
        case NODE_XMLPCDATA:
            pcdata = static_cast<XMLPCDATA*>(node);
            pcdata->accept(validate_visitor);
            return true;
            break;
        default:
            return false;
            break;
    }
}

void DTD::print ()
// Print the DTD
//    <!ELEMENT a (b | (c,d,e)+ )>
//    <!ATTLIST a PCDATA #IMPLIED >
{
    DTDRule* rule;
    for ( unsigned int i=0; i < elements->size(); i++ )
    {
        cout << "<!ELEMENT " << (*elements)[i]->getName() << " ";
        // Print the rule
        rule =  (*elements)[i]->getRule();
        if(rule == NULL) {
#ifdef DEBUG
            cout << "[PRINT] NULL rule detected for element '"
                 << (*elements)[i]->getName() << "'." << endl;
#endif
        }
        else
            rule->print();
        cout << " >" << endl;
        // print the attribute list
        vector<DTDAttribute *> * attributes = (*elements)[i]->getAttributes();
        if ( !attributes->empty())
        {
            cout << "<!ATTLIST " << (*elements)[i]->getName();
            for ( unsigned int attI=0; attI < attributes->size(); attI++ )
            {
                cout << endl << "\t" << (*attributes)[attI]->getName()
                     << " " << (*attributes)[attI]->getData()
                     << " " << (*attributes)[attI]->getFlag();
            }
            cout << " >" << endl;
        }
    }
}
