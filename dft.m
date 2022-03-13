function [F,X] = dft(x,fs)
  
  N = length(x);
  T=0:N-1; %wektor czasu dla wartoœci N
  K=0:N-1; %wektor indeksów/numerów pr¹¿ków dla k
  delta_f= fs/N; %rozdzielczoœæ w widmie - pierwsza harmoniczna
  F=K*delta_f; %wektor czêstotliwoœci w Hz
  #disp(['Rozdzielczoœæ widma ',num2str(delta_f),' Hz']);
  DN=exp(-1j*2*pi*K'*T/N);
  X=DN*x';
  
endfunction