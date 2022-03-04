clear all;
close all;
clc;

frequencyMap = containers.Map(
{0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x9,0xA,0xB,0xC,0xD,0xE,0xF
},
{261.6,293.7,329.6,370.0,392.0,440.0,493.9,523.3,587.3,659.3,698.5,784.0, 880.0,987.8,1046.5,1174.7
}
);


##
## 0  c1  261.6
## 1  d1  293.7
## 2  e1  329.6
## 3  f1  370.0
## 4  g1  392.0
## 5  a1  440.0
## 6  h1  493.9
## 7  c2  523.3
## 8  d2  587.3
## 9  e2  659.3
## A  f2  698.5
## B  g2  784.0
## C  a2  880.0
## D  h2  987.8
## E  c3  1046.5
## F  d3  1174.7



signal = [0x0,0x4,0x7,0xB,0x0,0x0,0x0,0x1,0x0,0x0,0x1,0x7,0x0,0x4,0x7,0xB];
length(signal)
signalFreq = zeros(length(signal),1);



for i = 1:length(signalFreq)
  
    signalFreq(i) = frequencyMap(signal(i));
  
end




%Parametry symulacji
tempo = 100;
f_nad = tempo / 60;

tone_perc_dur = 0.5;

t_beat = 1 / f_nad;
t_sygn = tone_perc_dur * 1 / f_nad
t_sil = (1-tone_perc_dur) * 1/f_nad


f_s = 10^4;
t_s = 1/f_s;


A_1 = 1;


t = (0:t_beat*f_s-1)*t_s;
t_sign_vect = (0:t_sygn*f_s-1)*t_s;
F = (0:t_beat*f_s/2-1) * (f_s/t_beat*f_s);

resultSig = [];
resT = [];

silence = zeros(1,uint8(t_sil*f_s));

for i=1:4:length(signalFreq)-3
  
  s_1 = A_1 * sin(2*pi*signalFreq(i)*t_sign_vect);
  s_2 = A_1 * sin(2*pi*signalFreq(i+1)*t_sign_vect);
  s_3 = A_1 * sin(2*pi*signalFreq(i+2)*t_sign_vect);
  s_4 = A_1 * sin(2*pi*signalFreq(i+3)*t_sign_vect);
  s_sum = s_1 + s_2 + s_3 + s_4;
  resultSig = [resultSig silence s_sum];
  resT = [resT t];
  if i==5
    sig2analyse = s_sum;
  endif
end

soundsc(resultSig,f_s);
audiowrite('res.wav',resultSig,f_s);

%Rysowanie wykresów
figure(1);
plot(resT,resultSig);
%hold on;
%plot(t,s_2);
%hold off;


%figure(2);
%plot(t,s_sum);

S = abs(fft(sig2analyse) / (N/2));
S = S(1:(N/2));

figure(3);
stem(F,S);



%Próba dekodowania




