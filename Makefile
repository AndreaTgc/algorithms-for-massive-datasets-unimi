# This makefile is used to recompile the documentation LaTeX sources
# and nothing else

DOCFILE = docsrc/report.typ 
OUTFILE = report.pdf

.PHONY: all clean

all: report.pdf

report.pdf: $(DOCFILE) 
	typst compile $(DOCFILE) $(OUTFILE) 

clean:
	rm $(OUTFILE)


