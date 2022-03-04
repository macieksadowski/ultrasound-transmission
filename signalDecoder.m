clear all;
close all;
clc;

%--------------------------------------%
%             Record import            %
%--------------------------------------%

[recordedAudio,recAudFs] = audioread('resRec2.wav');

%--------------------------------------%
%      Signal decoding parameters      %
%--------------------------------------%

%Frequencies of signal states: 1 (High), -1 (Low)
lowStateFreq = 18000;
highStateFreq = 18500;

disp('RECORDED SIGNAL');
recAudFs
threshold = 2
err = 40
frag_length = 0.08

%--------------------------------------%
%              Signal decoding         %
%--------------------------------------%

[t_fmaxV,fmaxV] = segFft(frag_length,recordedAudio,recAudFs,threshold);

resBin = [];
oldVal = 0;

for i=1:length(fmaxV)
  val = fmaxV(i);
   if val < oldVal - err || val > oldVal + err
     if val != 0
      if val < lowStateFreq + err && val > lowStateFreq - err
        resBin = [resBin 0];  
      endif
      if val < highStateFreq + err && val > highStateFreq - err
        resBin = [resBin 1];    
      endif
     endif
   endif
   oldVal = val;
endfor

%--------------------------------------%
% Signal conversion form freq to hex   %
%--------------------------------------%

resHex = bin2hex(resBin)



figure
stem(t_fmaxV,fmaxV);





