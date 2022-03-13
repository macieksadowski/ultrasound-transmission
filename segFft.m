function [t_fmaxV,fmaxV] = segFft(frag_length,signal,fs,threshold)

t_fmaxV = [];
fmaxV = [];
fV = [];

step = floor(frag_length * fs);
for i = 1:step:length(signal) * fs;
  if i+step > length(signal)
    break;
  else
    t_fmaxV = [t_fmaxV i/fs];
    frag  = signal(i:i+step-1);
  endif;
  
  Nfft = length(frag);
  
  %[f,X] = dft(frag,fs);
  %f = f(1:(Nfft/2));
  %X = abs(X);
  
  f = (0:Nfft/2-1)*fs/Nfft;
  X = abs(fft(frag,Nfft));
  X = X(1:(Nfft/2));
  
  [Amax,fmax] = max(X);
  if Amax < threshold
    fmaxV = [fmaxV 0];
  else
    fmaxV = [fmaxV f(fmax)];
  endif
  fV = [fV f(fmax)];
endfor

%stem(t_fmaxV,fV);

endfunction