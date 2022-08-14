function msg_encoded = enc_hamming(msg)
    msg_encoded = msg;

    k = 4;%# of message bits per block

    if length(msg) ~= k
        disp(['Message length incorrect! Is (',num2str(length(msg)),'), should be (',num2str(k),')']);
        return;
    end

    G = [1 1 1 0 0 0 0 1;
         1 0 0 1 1 0 0 1;
         0 1 0 1 0 1 0 1;
         1 1 0 1 0 0 1 0];

    %ENCODER%
    msg_encoded = mod(msg*G,2);%Encode message
    
end






