# AffordancesAndSpeech
Code for the experiment in the paper:  
**Language bootstrapping: learning word meanings from perception-action association.**  
*Giampiero Salvi , Luis Montesano, Alexandre Bernardino, José Santos-Victor*  
IEEE Transactions on Systems, Man, and Cybernetics, Part B (Cybernetics) (Volume: 42, Issue: 3, June 2012)  
DOI: 10.1109/TSMCB.2011.2172420  
http://ieeexplore.ieee.org/document/6082460/

The speech data used in the paper can be downloaded here:
https://kth.box.com/s/t94utqu15727ujfagxllhl8me25kqmt0

The ASR code will be added to this repository after cleaning up.

## Contents
`bayesian_net`:
code to train and test a Bayesian network with affordance and word nodes. The main script is `README.m`. The script uses as input a number of bag-of-words text files obtained from the the ASR code that is not included at the moment.

