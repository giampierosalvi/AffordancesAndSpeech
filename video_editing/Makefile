
all: slides.png

slides.pdf: slides.tex
	pdflatex $<
	pdflatex $<

# this creates by side effect slides-x.pdf
slides.png: slides.pdf
	convert -density 300 $< -geometry 1280x720 -quality 100 $@
	touch $@

