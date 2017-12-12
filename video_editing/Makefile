TTS = /home/giampi/Documents/simple-google-tts/simple_google_tts


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
	rm -f $@
	avconv -framerate 25 -f image2 -i complete_net/complete_net-%03d.png -c:v h264 -crf 1 $@

action_nodes.pdf: action_nodes.tex
	pdflatex $<

action_nodes.png: action_nodes.pdf
	mkdir -p action_nodes
	convert -density 300 $< -geometry 1280x720 -quality 100 action_nodes/action_nodes-%03d.png
	touch $@

action_nodes.mp4: action_nodes.png
	rm -f $@
	avconv -framerate 25 -f image2 -i action_nodes/action_nodes-%03d.png -c:v h264 -crf 1 $@

sentences.done: sentences.txt
	$(TTS) en `pwd`/$<

playground.png: original_video.mp4
	avconv -i original_video.mp4 -ss 15.0 -frames:v 1 $@

clean:
	rm -r complete_net
	rm slides-*.png
	rm *.aux *.log *.nav *.out *.snm *.toc
