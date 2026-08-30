# This makefile is used to recompile the documentation LaTeX sources
# and nothing else

LATEXFLAGS = -interaction=nonstopmode -halt-on-error
DOCFILE = doc_src/report.tex
OUTFILE = project_report.pdf
LOGFILE = report.log
AUXFILE = report.aux

.PHONY: all clean

all: report.pdf

report.pdf: $(DOCFILE) 
	pdflatex $(LATEXFLAGS) $(DOCFILE) 
	@while grep -q "Rerun to get" $(LOGFILE) 2>/dev/null; do \
		echo "Rerunning for cross reference"; \
		pdflatex $(LATEXFLAGS) $(DOCFILE); \
	done

clean:
	rm $(LOGFILE) $(AUXFILE) $(OUTFILE) 

