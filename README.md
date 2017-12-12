# AffordancesAndSpeech
Code for the experiment in the paper:  
**Language bootstrapping: learning word meanings from perception-action association.**  
*Giampiero Salvi , Luis Montesano, Alexandre Bernardino, José Santos-Victor*  
IEEE Transactions on Systems, Man, and Cybernetics, Part B (Cybernetics) (Volume: 42, Issue: 3, June 2012)  
DOI: 10.1109/TSMCB.2011.2172420  
http://ieeexplore.ieee.org/document/6082460/
Open access version:
https://arxiv.org/abs/1711.09714

### Illustration of the experiments
The experiments were performed using the Baltazar humanoid robot, partly at Istituto Superior Tecnico, Lisbon, Portugal and partly at KTH Royal Institute of Technology, Stockholm, Sweden.
[![Illustration of the experiments reproduced with the iCub](https://img.youtube.com/vi/O6mdFL5aH6M/0.jpg)](https://youtu.be/O6mdFL5aH6M)

## Data
The speech data used in the paper can be downloaded here:
https://kth.box.com/s/t94utqu15727ujfagxllhl8me25kqmt0

Only the recordings from speakers `m03` and `f08` where used in the experiments.

The ASR code will be added to this repository after cleaning up.

## Changes
The code has been updated in November 2017 to support new studies. The main difference are:
* support for soft evidence
* code to generate written descriptions of experiments according to a formal grammar given a probability distribution of words estimated by the affordance-word model.

The code should be backward compatible to the 2012 experiment.

## Contents
`bayesian_net`:
code to train and test a Bayesian network with affordance and word nodes. The main script is `README.m`. The script uses as input a number of bag-of-words text files obtained from the the ASR code that is not included at the moment.

`word2sent`:
definition of the context-free formal grammar to generate sentences from probability distribution over words.
