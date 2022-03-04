function hex = bin2hex(bin)
  
    hex = [];
    for i=4:4:length(bin)
      hex = strcat(hex,dec2hex(bin2dec(strcat(mat2str(bin(i-3)),mat2str(bin(i-2)),mat2str(bin(i-1)),mat2str(bin(i))))));
    endfor  
endfunction