% BN: Wrapper to BNT to implement the affordance and word experiments
% See paper at DOI: 10.1109/TSMCB.2011.2172420
%
% Files
%   BNEnterNodeEvidence             - BNEnterNodeEvidence: enter hard or soft evidence to the model
%   BNEnterWordEvidence             - BNEnterWordEvidence: enter word evidence
%   BNGetWordProbs                  - BNGetWordProbs: returns probabilities of each word in the model
%   BNHardPredictionAccuracy        - BNHardPredictionAccuracy: evaluates prediction of answers from questions
%   BNLearnParameters               - BNLearnParameters: creates a Bayesian net and learns the parameters
%   BNLearnStructure                - BNLearnStructure: learns the structure of the Bayesian network 
%   BNLearnStructureNoAffordance    - BNLearnStructureNoAffordance: learns the structure of the Bayesian network 
%   BNLoadData                      - BNLoadData: loads data into BN object
%   BNResetEvidence                 - BNResetEvidence: resets all evidence in netobj and netobj.engine
%   BNSetDefaults                   - BNSetDefaults sets default values for affordance and word experiment
%   BNShowCurrentEvidence           - BNShowCurrentEvidence: human readable report on current evidence
%   BNSoftPredictionAccuracy        - 
%   BNTestBestPrediction            - tests how often the best prediction of the network is among the human
%   BNTestPrediction                - test predictions by summing the marginal probability over all cases
%   BNWhichNode                     - BNWhichNode: returns node index from node name
%   BNWhichNodeValue                - BNWhichNodeValue: returns node value index from value name
%   createBN                        - createBN: creates Bayesian Network from definition file
%   dag2dot                         - returns a string containing a directd acyclic graph definition in
%   dagdiff2dot                     - DAG2DOT returns a string containing a directd acyclic graph definition in
%   dot2lang                        - gererates a graph file using dot.
%   learn_partial_struct_K2         - LEARN_PARTIAL_STRUCT_K2, modified version of LEARN_STRUCT_K2 (see below)
%   make_action_object_select_table - 
%   make_improve_asr_table          - 
%   make_report                     - 
%   multikron                       - multikron: multidimensional Kronecker product
%   print2pdf                       - print2pdf Prints to pdf with bounding box (uses eps2pdf)
%   ReadInstructionsJudgements      - assuming data in the format (for each line):
%   rotateticklabel                 - rotates tick labels
%   roundn                          - - round to the nth digit
