clear all;
%close all;
clc;

%---------------------------------------%
%             PARAMERETRS               %
%---------------------------------------%
%Sample rate of soundfile
fs = 48000;
%Message to send as HEX data
signalHex = '67676767'


%--------------------------------------%
%      Constants and definitions       %
%--------------------------------------%
% Signal will be coded as RZ (Return to Zero)

setFreqParams;

disp('GENERATED SIGNAL');
disp(strcat('Message: ', signalHex));
disp(strcat('Bandwidth: ',num2str(freq(1,1)),'Hz - ',num2str(freq(noOfChannels,2)),'Hz'));
disp(strcat('Speed rate: ',num2str(floor(noOfChannels/(tOneSig+tBreak))),'b/s'));

%--------------------------------------%
% Signal conversion form hex to freq   %
%--------------------------------------%

signalBin =  hex2bin(signalHex);

pad = mod(2*length(signalBin),noOfChannels);
if pad ~= 0
   signalBin = [signalBin zeros(1,noOfChannels - pad/2)]; 
end

%--------------------------------------%
%             Hamming code             %
%--------------------------------------%
signalBinEncoded = [];
for i=4:4:length(signalBin)
    signalBinEncoded = [signalBinEncoded enc_hamming(signalBin(i-3:i))];
end

%--------------------------------------%
%         Soundfile generation         %
%--------------------------------------%

audioSig = generateAudioSig(signalBinEncoded, tOneSig, tBreak, fs);

t = (0:(length(audioSig)-1))*(1/fs);

fileName = strcat(num2str(noOfChannels),'F',num2str(firstFreq),'S',num2str(freqStep),'T',num2str(tOneSig),'.wav');

%soundsc(audioSig,fs);

audiowrite(fileName,audioSig,fs);
disp(strcat('Saved to file: ',fileName));


  