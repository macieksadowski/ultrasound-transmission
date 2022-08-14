%-----------------------------------------%
%               PARAMERETRS               %
%-----------------------------------------%

%Number of transmission channels      
noOfChannels = 32;

%Frequencies will be generated from first frequency ascending with given step
firstFreq = 18000;
freqStep = 40;


%-----------------------------------------%
%      AUTO CALCULATED. DO NOT MODIFY!    %
%-----------------------------------------%

%Length of one pulse (and evt. length of zero between pulses)
tOneSig = 2/freqStep;
tBreak = 2*tOneSig;

%Frequencies of signal states: 1 (High), -1 (Low) for each Bit Line:

freq = zeros(noOfChannels,2);

for i=0:noOfChannels-1
  freq(i+1,1) = firstFreq + i * 2 * freqStep;
  freq(i+1,2) = firstFreq + freqStep + i * 2 * freqStep;
end


