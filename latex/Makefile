NAME=protasi

all: compile

compile:
	pdflatex $(NAME).tex
	# bibtex $(NAME).aux
	# pdflatex $(NAME).tex
	# pdflatex $(NAME).tex

view: compile
	evince $(NAME).pdf &

clean:
	rm *.blg *.bbl *.aux *.log *.out
