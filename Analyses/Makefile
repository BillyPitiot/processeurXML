CXX=g++
CXXFLAGS=-Wall -IXML -IDTD -IDTD/Exceptions -I. -D_GLIBCXX_DEBUG #-D DEBUG
SRC_C=lex.xml_.c xml.tab.c lex.dtd_.c dtd.tab.c
OBJS_C=$(SRC_C:.c=.c.o)
SRC_CPP=$(shell find -name "*.cpp" | xargs -l1 basename | xargs)
OBJS_CPP=$(SRC_CPP:.cpp=.cpp.o)
VPATH=XML DTD DTD/Exceptions
OBJDIR=obj
BINDIR=bin

all: analyse

.PHONY : all

lex.xml_.c: xml.l
	@echo " * " Generating XML scanner...
	@flex  -Pxml_ xml.l

xml.tab.c: xml.y
	@echo " * " Generating XML parser...
	@bison -pxml_ --debug --verbose --defines=yy.tab_xml.h xml.y

lex.dtd_.c:	
	@echo " * " Generating DTD scanner...	
	@flex  -Pdtd_ dtd.l

dtd.tab.c:
	@echo " * " Generating DTD parser...
	@bison -pdtd_ --debug --verbose --defines=yy.tab_dtd.h dtd.y

analyse: $(OBJS_CPP) $(OBJS_C)
	@mkdir -p $(BINDIR)
	@g++ -g -DYYDEBUG=1 $(OBJS_CPP) $(OBJS_C) $(CPPFLAGS) -o $(BINDIR)/test
	@echo "=========================================="
	@echo " * " Finished. Executable file: $(BINDIR)/test

clean:
	@echo " * " Cleaning...
	@rm -rf *.tab.c lex.*.c *.tab.h *.output
	@rm -f *.o
	@echo " * " Cleaned.

%.cpp.o: %.cpp
	@echo " * " Building $@...
	@$(CXX) -g -c $(CXXFLAGS) $< -o $@

%.c.o: %.c
	@echo " * " Building $@...
	@$(CXX) -g -c $(CXXFLAGS) $< -o $@

test:
	./bin/test
