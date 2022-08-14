function msg_decoded = secded(msg)
    msg_decoded = msg;

    n = 8;%# of codeword bits per block

    if length(msg) ~= n
        disp(['Message length incorrect! Is (',num2str(length(msg)),'), should be (',num2str(n),')']);
        return;
    end

    H = [1 0 1 0 1 0 1 0;
         0 1 1 0 0 1 1 0;
         0 0 0 1 1 1 1 0;
         1 1 1 1 1 1 1 1];

    % DECODER%
    R = [0 0 1 0 0 0 0 0;
         0 0 0 0 1 0 0 0;
         0 0 0 0 0 1 0 0;
         0 0 0 0 0 0 1 0];

    syndrome = mod(msg * H',2);



    if sum(syndrome) == 0
       msg_decoded = msg;
    else
       %Check parity bit
        if mod(sum(msg(1:length(msg)-1)),2) ~= msg(end)
            %Find position of the error in codeword (index)
            find = 0;
            for ii = 1:n

                    if ~find
                        errvect = zeros(1,n);
                        errvect(ii) = 1;

                        search = mod(errvect * H',2);
                        if search == syndrome
                            find = 1;
                            index = ii;
                        end
                    end

            end
            disp(['Position of error in codeword=',num2str(index)]);
            correctedcode = msg;
            correctedcode(index) = mod(msg(index)+1,2)%Corrected codeword
            msg_decoded=correctedcode;
        else
            disp('Double error detected!');
            return
        end 
    end

    msg_decoded = mod(msg_decoded * R',2);
end






