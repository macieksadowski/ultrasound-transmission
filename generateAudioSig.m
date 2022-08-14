function audioSig = generateAudioSig(signalBin, tOneSig, tBreak, fs)

    %--------------------------------------%
    %         Soundfile generation         %
    %--------------------------------------%

    setFreqParams;
    
    ts= 1/fs;

    tOneSigV = 0:ts:tOneSig;
    tBreakV = 0:ts:tBreak;

%     audioSig = zeros(1,length(tBreakV));
    audioSig = [];
    
    for i=1:length(signalBin)/noOfChannels

      oneTactSig = zeros(1,length(tOneSigV)+length(tBreakV)-1);
      for j=1:noOfChannels
          ind = noOfChannels*(i-1)+ j;
        curFreq = freq(j, signalBin(ind) + 1);
        oneTactSig = oneTactSig + (1/noOfChannels * genTone(curFreq, tOneSig, tBreak / 2.0, 0.05, fs));      
      end
      audioSig = [audioSig oneTactSig];

    end
    audioSig = [audioSig zeros(1,length(tBreakV))];
end
 