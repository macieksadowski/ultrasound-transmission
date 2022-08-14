function signalBin = hex2bin(signalHex)
        
keySet = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
valueSet = {
  [0 0 0 0],
  [0 0 0 1],
  [0 0 1 0],
  [0 0 1 1],
  [0 1 0 0],
  [0 1 0 1],
  [0 1 1 0],
  [0 1 1 1],
  [1 0 0 0],
  [1 0 0 1],
  [1 0 1 0],
  [1 0 1 1],
  [1 1 0 0],
  [1 1 0 1],
  [1 1 1 0],
  [1 1 1 1]};
hex2binMap = containers.Map(keySet,valueSet);  


  signalBin =  [];

  
  
  for i=1:length(signalHex)
    signalBin = [signalBin hex2binMap(signalHex(i))];
  end
   
end

