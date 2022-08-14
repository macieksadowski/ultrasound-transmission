clear all;
%close all;
clc;
setFreqParams;

%---------------------------------------%
%             PARAMERETRS               %
%---------------------------------------%

%Set a decoding mode:
% * offline - for decoding a record
% * online - for decoding from audio input
mode = 'offline';

%Case offline mode - specify audio file name
fileName = '32F18000S40T0.05-R.wav';

%TODO Threshold to db scale!
threshold = 5;

%Size of FFT
Nfft = 2^12;

%--------------------------------------%
%             Record import            %
%--------------------------------------%
if mod(Nfft,2) ~= 0
    disp('Nfft must be a power of 2! Decoder Stopped!');
    return
end

if strcmp(mode,'online')
    fs = 44100;
    recorder = audiorecorder(fs, 8, 1, 1);   
elseif strcmp(mode,'offline')
    [recordedAudio,fs] = audioread(fileName);
else 
    disp('Unknown mode. Decoder stopped!');
    return
end

N = ceil(tOneSig*fs);
delta_R = fs / N;
delta_f = delta_R;
high_pass_filter_freq = min(freq(1,:))-delta_f;

disp('RECORDED SIGNAL');
disp(['Sampling frequency ',num2str(fs),' Hz']);
disp(['Frame length ',num2str(1 / delta_R),' s']);
disp(['Frequency resolution ',num2str(delta_R),'Hz, ','DFT resolution ',num2str(delta_f),'Hz']);

%--------------------------------------%
%              Signal decoding         %
%--------------------------------------%

resHex=[];
sigBin=[];

vals = zeros(1,noOfChannels);
oldVals = vals;

breakInd = 0;
elapsedTime = 0;

count = 0; % count how many time the while loop was executed

i = N;
while true
    
    if elapsedTime > 3
        break;
    end
    
    if strcmp(mode,'offline') && i+N > length(recordedAudio)
         break;
    end
  
  count = count + 1;
  
  elapsedTime = 1/ delta_R * count;
  
  if strcmp(mode,'offline')
    frag  = recordedAudio(i-(N-1): i);
  else 
      recordblocking(recorder, 1 / delta_R);  
      frag = getaudiodata(recorder);
  end
  
  %Hamming window
  w = hamming(N);
  frag = frag .* w;
  
  %Execute fft on selected samples
  f = (0:Nfft/2)*(fs/Nfft);
  X = abs(fft(frag,Nfft));
  X = X(1:(Nfft/2+1));
  
  %Apply filter on fft results
  X = X .* (f > high_pass_filter_freq)';
  
  %Iterate for every transmission's channel
  valFound = 1;
  valChanged = 0;  
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
    end
    %If value of frequency is different from its value in previous step
    if vals(j) < oldVals(j) - delta_f || vals(j) > oldVals(j) + delta_f
      valChanged = 1;
      oldVals = vals;
    end
  end
  
  %Check if pause between pulses detected
  if any(vals) == 0
    breakInd = 1;
    oldVals = vals;
  end
  
  %If found searched frequencies on all channels
  if valFound == 1 && valChanged == 1 && breakInd == 1

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
      end

    end

    if length(resBin) == noOfChannels
      resBin;
      sigBin = [sigBin resBin];  
      breakInd = 0;
    end
   
  end
 
  if ~isempty(sigBin) && mod(length(sigBin),8) == 0 
    sigBin;
    sigBinDecoded = [];
    for ii=8:8:length(sigBin)
        decoded = secded(sigBin(ii-7:ii));
        if length(decoded) > 4
            disp('Errors in signal');
            return
        else
            sigBinDecoded = [sigBinDecoded decoded];
        end
        
        
    end
    resHex = bin2hex(sigBinDecoded);
    disp(['Decoded Data: ',resHex]);
  end
  
  i = i + N;

end
  
if strcmp(mode,'online')
    disp('--> Deleting Recorder Object');
    stop(recorder);
end










