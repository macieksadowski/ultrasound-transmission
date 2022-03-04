function signalFreq = bin2freq(signalBin,lowStateFreq,highStateFreq)

  signalFreq = [];

  for i=1:length(signalBin)
    if signalBin(i) == 0
      curFreq = lowStateFreq;
    else
      curFreq = highStateFreq;
    endif
    signalFreq = [signalFreq curFreq];
  endfor
  
endfunction