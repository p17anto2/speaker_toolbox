NAME=protasi

all: compile

compile:
	pdflatex $(NAME).tex
	mv $(NAME).pdf ../

view: compile
	evince ../$(NAME).pdf &

clean:
	rm *.blg *.bbl *.aux *.log *.out
