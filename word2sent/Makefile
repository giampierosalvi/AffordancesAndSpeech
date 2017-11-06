# commands to generate sentences from a grammar definition
# require HTK and dot for illustrating the grammar graph

# creates lattice from grammar definition using HTK
grammar.lat: grammar.grm
	HParse $< $@


# coverts lattice to dot for illustration
grammar.dot: grammar.lat
	tools/lat2dot $< > $@

# coverts dot to pdf for illustration
grammar.pdf: grammar.dot
	dot -Tpdf $< > $@

# creates list of words from grammar
word.lst: grammar.grm
	tools/gram2wlist.pl $< > $@

sentence_sample.txt: grammar.lat word.lst
	HSGen -n 1000 $^ > $@
