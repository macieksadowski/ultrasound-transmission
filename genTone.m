function sample = genTone(freq,toneLength,breakLength,fadeLength,sampleRate)
  
  N = (toneLength + 2 * breakLength) * sampleRate;
  Nbreak = breakLength * sampleRate;
  Nsig = N - 2 * Nbreak;
  sample = zeros(1,N);
  filterStep = 1.0 / (fadeLength * Nsig);
  angle = 0;
  increment = 2 * pi * freq / sampleRate;

  iSig = 0;
  
  for i=1:N
    
    filterVal = 1;
    if i > Nbreak && i < N - Nbreak
      if i < Nbreak + fadeLength * Nsig
        filterVal = filterStep * iSig;
      elseif i > Nbreak + (1.0 - fadeLength) * Nsig
        filterVal = -1.0 * filterStep * (iSig - Nsig);        
      endif
      sample(i) = filterVal * sin(angle);
      angle += increment;
      iSig++;
    endif
    
  endfor
  
  
endfunction
