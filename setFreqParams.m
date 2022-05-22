
%Number of transmission channels      
noOfChannels = 16;

%Frequencies will be generated from first frequency ascending with given step
freqStep = 50
firstFreq = 21000;


%Frequencies of signal states: 1 (High), -1 (Low) for each Bit Line:

freq = zeros(noOfChannels,2);

for i=0:noOfChannels-1
  freq(i+1,1) = firstFreq + i * 2 * freqStep;
  freq(i+1,2) = firstFreq + freqStep + i * 2 * freqStep;
endfor


