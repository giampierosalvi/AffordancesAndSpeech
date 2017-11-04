# word2sent
The scripts in this directory can be used to create a context-free formal grammar and to use it to generate sentences. The grammar definition in [HTK](http://htk.eng.cam.ac.uk/) format is in `grammar.grm`.

* `make grammar.lat`: creates a graph of the grammar in HTK lattice format
* `make grammar.pdf`: creates a visual representation of the grammar
* `make sentence_sample.txt`: generates 1000 sentences from the grammar randomly
