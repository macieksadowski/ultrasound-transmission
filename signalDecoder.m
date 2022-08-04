 clear all;
close all;
clc;

%--------------------------------------%
%             Record import            %
%--------------------------------------%

%[recordedAudio,fs] = audioread('testAnd01.wav');


fs = 48000;
recorder = audiorecorder(fs, 8, 1, 1);


%--------------------------------------%
%      Signal decoding parameters      %
%--------------------------------------%



## frag_length = 1/30;
%Frag length must be set corresponding to length of  one pulse in transmitted signal
% Approx. frag_length = tOneSig / 3

%Better results, when delta_R given corresponding to searched values, instead of setting frag_length\
%BUT 1 / delta_R = frame_length and because of that its important to consider adequate value
delta_R = 50;

#TODO Threshold to db scale!
threshold = 1.0;
delta_f = 10;

setFreqParams;

disp('RECORDED SIGNAL');
disp(['Sampling frequency ',num2str(fs),' Hz']);
disp(['Frame length ',num2str(1 / delta_R),' s']);

disp(['Frequency resolution ',num2str(delta_R),'Hz, ','DFT resolution ',num2str(delta_f),'Hz']);


%--------------------------------------%
%              Signal decoding         %
%--------------------------------------%


high_pass_filter_freq = min(freq(1,:))-delta_f;

Nfft = fs / delta_f;

resHex=[];
sigBin=[];

vals = zeros(1,noOfChannels);
oldVals = vals;

breakInd = 0;
figShown = 0;
elapsedTime = 0;

count = 0; % count how many time the while was executed

while elapsedTime < 5

  count ++;
  
  elapsedTime = 1/ delta_R * count;
  
  recordblocking(recorder, 1 / delta_R);
  
  frag = getaudiodata(recorder);
  
  %Zero padding
  frag = [frag;zeros(Nfft-length(frag),1)];
  
  
  %Execute fft on selected samples
  f = (0:Nfft/2-1)*fs/Nfft;
  X = abs(fft(frag,Nfft));
  X = X(1:(Nfft/2));
   
  %Apply filter on fft results
  X = X .* (f > high_pass_filter_freq)';
  
  valFound = 1;
  valChanged = 0;
  
  %Iterate for every transmission's channel
  for j=1:noOfChannels
    
    %Analyse only in range of frequencies used by current channel
    Xtmp = X .* (f > freq(j,1) - delta_f)';
    Xtmp = Xtmp .* (f < freq(j,2) + delta_f)';
    
    [Amax,fmax] = max(Xtmp);

    if Amax > threshold
      vals(j) = f(fmax);
    else
      vals(j) = 0;
      valFound = 0;
      continue
    endif
    
    %If value of frequency is different from its value in previous step
    if vals(j) < oldVals(j) - delta_f || vals(j) > oldVals(j) + delta_f
      valChanged = 1;
      oldVals = vals;
    endif
  
   
  endfor

  vals;
  
  if any(vals) == 0
    breakInd = 1;
  endif
  
  %If found searched frequencies on all channels
  if valFound == 1 && valChanged == 1 && breakInd == 1
  
  if figShown == 0
    figure
    stem(f,X);  
    xlim([freq(1,1)-delta_R freq(noOfChannels,2)+delta_R]);
    figShown = 1;
  endif
  
    resBin = [];
    for j=1:noOfChannels
   
      %If in range of low state freq
      if vals(j) <= freq(j,1) + delta_f && vals(j) >= freq(j,1) - delta_f
        resBin = [resBin 0];       
      %If in range of high state freq
      elseif vals(j) <= freq(j,2) + delta_f && vals(j) >= freq(j,2) - delta_f
        resBin = [resBin 1];  
      else
        break
      endif
      
      
      
    endfor

    if length(resBin) == noOfChannels
      resBin;
      sigBin = [sigBin resBin];  
      breakInd = 0;
    endif
    

  endif
 
  if(length(sigBin > 0)) 
    resHex = bin2hex(sigBin);
    disp(['Decoded Data: ',resHex]);
  endif
  
  

endwhile
disp('--> Deleting Recorder Object')
stop(recorder);











