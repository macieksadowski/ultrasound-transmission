clear all;
close all;
%clc;

%--------------------------------------%
%      Constants and definitions       %
%--------------------------------------%
% Signal will be coded as RZ (Return to Zero)

setFreqParams;

disp('GENERATED SIGNAL');

%Length of one pulse (and evt. length of zero between pulses)
% In seconds
tOneSig = 0.05
tBreak = 0.05

%Sample rate of soundfile
fs = 48000

%--------------------------------------%
% Signal conversion form hex to freq   %
%--------------------------------------%

signalHex = "4D616369656A205361646F77736B6900"


##signalHex = "A0";

signalBin =  hex2bin(signalHex);

%--------------------------------------%
%         Soundfile generation         %
%--------------------------------------%

ts= 1/fs;

tOneSigV = 0:ts:tOneSig;
tBreakV = 0:ts:tBreak;

breakSig = zeros(1,tBreak/ts);

audioSig = [];

bytePos = 1;

for i=1:length(signalBin)/noOfChannels
  
  oneTactSig = zeros(1,length(tOneSigV)-1+length(tBreakV)-1);
  for j=1:noOfChannels
    if signalBin(bytePos) == 0
      curFreq = freq(j,1);
    elseif signalBin(bytePos) == 1
      curFreq = freq(j,2);
    endif
    bytePos++;
    oneTactSig = oneTactSig .+ (1/noOfChannels * genTone(curFreq, tOneSig, tBreak / 2.0, 0.01, fs));      
  endfor
  audioSig = [audioSig oneTactSig];
  
endfor

t = (0:(length(audioSig)-1))*ts;

fileName = strcat(num2str(noOfChannels),'F',num2str(firstFreq),'S',num2str(freqStep),'T',num2str(tOneSig),'.wav')

audiowrite(fileName,audioSig,fs);



  