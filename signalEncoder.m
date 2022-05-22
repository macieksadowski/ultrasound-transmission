clear all;
##close all;
clc;

%--------------------------------------%
%      Constants and definitions       %
%--------------------------------------%
% Signal will be coded as RZ (Return to Zero)

disp('GENERATED SIGNAL');

%Frequencies of signal states: 1 (High), -1 (Low)
lowStateFreq = 20000;
highStateFreq = 20500;

%Length of one pulse (and evt. length of zero between pulses)
% In seconds
tOneSig = 0.2
tBreak = tOneSig;

%Sample rate of soundfile
fs = 44100



%--------------------------------------%
% Signal conversion form hex to freq   %
%--------------------------------------%

signalHex = "A2"
signalBin =  hex2bin(signalHex);
signalFreq = bin2freq(signalBin,lowStateFreq,highStateFreq);

%--------------------------------------%
%         Soundfile generation         %
%--------------------------------------%

tSigLen = (tOneSig+tBreak)*length(signalFreq)

ts= 1/fs;

tOneSigV = 0:ts:tOneSig;
tBreakV = 0:ts:tBreak;

lowStateSine = sin(2*pi*lowStateFreq*tOneSigV);
highStateSine = sin(2*pi*highStateFreq*tOneSigV);
breakSig = zeros(1,tBreak/ts);

audioSig = [];

for i=1:length(signalBin)
  if signalBin(i) == 1
    audioSig = [audioSig highStateSine];
  else
    audioSig = [audioSig lowStateSine];
  endif
  audioSig = [audioSig breakSig];
endfor

t = 0:ts:length(audioSig);

audiowrite('res.wav',audioSig,fs);
  
%soundsc(audioSig,fs);