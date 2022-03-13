clear all;
close all;
clc;

%--------------------------------------%
%             Record import            %
%--------------------------------------%

[recordedAudio,recAudFs] = audioread('andr1try.wav');

%--------------------------------------%
%      Signal decoding parameters      %
%--------------------------------------%

frag_length = 0.08;
#TODO Threshold to db scale!
threshold = 2;

%Frequencies of signal states: 1 (High), -1 (Low)
lowStateFreq = 21000;
highStateFreq = 21500;

disp('RECORDED SIGNAL');
disp(['Sampling frequency ',num2str(recAudFs),' Hz']);
disp(['Frame length ',num2str(frag_length),' s']);

%--------------------------------------%
%              Signal decoding         %
%--------------------------------------%

[t_fmaxV,fmaxV] = segFft(frag_length,recordedAudio,recAudFs,threshold);

resBin = [];
oldVal = 0;
delta_f = 1 / frag_length;
disp(['Frequency resolution ',num2str(delta_f),' Hz']);

for i=1:length(fmaxV)
  val = fmaxV(i);
   if val < oldVal - delta_f || val > oldVal + delta_f
     if val != 0
      if val <= lowStateFreq + delta_f && val >= lowStateFreq - delta_f
        resBin = [resBin 0];  
      endif
      if val <= highStateFreq + delta_f && val >= highStateFreq - delta_f
        resBin = [resBin 1];    
      endif
     endif
   endif
   oldVal = val;
endfor

%--------------------------------------%
% Signal conversion form freq to hex   %
%--------------------------------------%

resHex = bin2hex(resBin);
disp(['Decoded Data: ',resHex]);



figure
stem(t_fmaxV,fmaxV);





