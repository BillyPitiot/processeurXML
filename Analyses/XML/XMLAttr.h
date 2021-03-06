#ifndef _XMLATTR_
#define _XMLATTR_

#include <string>

class XMLAttr {
    public:
        XMLAttr(std::string name, std::string value = "");
        std::string getName();
        std::string getValue();
    private:
        std::string name;
        std::string value;
};

#endif
