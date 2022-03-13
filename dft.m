function [F,X] = dft(x,fs)
  
  N = length(x);
  T=0:N-1; %wektor czasu dla warto�ci N
  K=0:N-1; %wektor indeks�w/numer�w pr��k�w dla k
  delta_f= fs/N; %rozdzielczo�� w widmie - pierwsza harmoniczna
  F=K*delta_f; %wektor cz�stotliwo�ci w Hz
  #disp(['Rozdzielczo�� widma ',num2str(delta_f),' Hz']);
  DN=exp(-1j*2*pi*K'*T/N);
  X=DN*x';
  
endfunction