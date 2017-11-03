

# creates lattice from grammar definition using HTK
grammar.lat: grammar.grm
	HParse $< $@

# coverts lattice to pdf for illustration
grammar.pdf: grammar.lat
	tools/lat2pdf $<

# creates list of words from grammar
word.lst: grammar.grm
	tools/gram2wlist.pl $< > $@

sentence_sample.txt: grammar.lat word.lst
	HSGen -n 1000 $^ > $@
