NAME=protasi

all: compile

compile:
	pdflatex $(NAME).tex
	pdflatex $(NAME).tex
	mv $(NAME).pdf ../

view: compile
	evince ../$(NAME).pdf &

clean:
	rm *.aux *.log *.out
