
all: slides.png complete_net.mp4

slides.pdf: slides.tex
	pdflatex $<
	pdflatex $<

# this creates by side effect slides-x.pdf
slides.png: slides.pdf
	convert -density 300 $< -geometry 1280x720 -quality 100 $@
	touch $@

complete_net.pdf: complete_net.tex
	pdflatex $<

complete_net.png: complete_net.pdf
	mkdir -p complete_net
	convert -density 300 $< -geometry 1280x720 -quality 100 complete_net/complete_net-%03d.png
	touch $@

complete_net.mp4: complete_net.png
	rm $@
	avconv -framerate 25 -f image2 -i complete_net/complete_net-%03d.png -c:v h264 -crf 1 $@

clean:
	rm -r complete_net
	rm slides-*.png
	rm *.aux *.log *.nav *.out *.snm *.toc
