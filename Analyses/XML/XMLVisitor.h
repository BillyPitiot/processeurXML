#ifndef XMLVISITOR_H_
#define XMLVISITOR_H_

class XMLTag;
class XMLPCDATA;

typedef enum {
    VISITOR_PRINT, VISITOR_XSLT, VISITOR_DTDVALIDATION
} VISITOR_TYPE;

class XMLVisitor {
    public:
        XMLVisitor(VISITOR_TYPE type);
        virtual bool visitXMLTag(XMLTag* tag) = 0;
        virtual bool visitXMLPCDATA(XMLPCDATA* pcdata) = 0;
    private:
        VISITOR_TYPE type;
};

#endif
