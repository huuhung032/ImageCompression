%coeff = [    16    0    0    14    0    0    0    0    13    0    0    17    0    0    0    0    26 0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  64    72    0    0    0    0    0    0    55    56    80   0    0    0    0    0   0 0   0    62    0   113   121   0   0   0    0   0   0    0
%];
function ad_bits = ACencode(coeff)
    %coeff = [	 -18    -5    -6    -1    -1    -2     0     0     0    -1     0     0     1     0     0     0     0     0     0     0     0     0	0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
    %hid = coeff;
    len = size(coeff);
    coeff = coeff(2:len(2));
    s = 1;
    k = 1;
    p = zeros(len(2),2);
    while k <= len(2) -1
        count = 0;
        if coeff(k) ~= 0
            p(s,:) = [0, coeff(k)];
            k = k +1;
            s = s+1;
        elseif coeff(k) == 0 
            while coeff(k) == 0 && k < len(2) -1

                count  = count+1;
                if count == 15
                    break;
                end
                k = k +1;
            end
            p(s,:) = [count, coeff(k)];
            k = k +1;
            count = 0;
            s = s+1;
        end
    end

    p = p(1:s-1,:);
    s = s-1;
    len = 8;
    cur = 1;
    sum = 0;
    for k = 1:s
        k;
        pair = p(k,:);
        diff = pair(2);
        if diff ==0
            cat =0;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff == -1
            cat = 1;
            sign = 1;
            bits = zeros(1,round(len+cat));
        elseif diff ==1
            cat = 1;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff >= -3 && diff <= -2
            cat =2;
            sign = 1;
            bits = zeros(1,round(len+cat));
        elseif diff >= 2 && diff <= 3
            cat = 2;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff >= -7 && diff <= -4
            cat = 3;
            sign = 1;
            bits = zeros(1,round(len+cat));
        elseif diff >=4 && diff <= 7
            cat = 3;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff >= -15 && diff<= -8
            cat = 4;
            sign =1;
            bits = zeros(1,round(len+cat));
        elseif diff >= 8 && diff<= 15
            cat = 4;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff >= -31 && diff<= -16
            cat = 5;
            sign = 1;
            bits = zeros(1,round(len+cat));
        elseif diff>= 16 &&diff <= 31
            cat = 5;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff>= -63 && diff<= -32
            cat = 6;
            sign = 1;
            bits = zeros(1,round(len+cat));
        elseif diff>= 32 && diff <= 63
            cat = 6;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff >= -127 && diff<= -64
            cat = 7;
            sign =1;
            bits = zeros(1,round(len+cat));
        elseif diff>= 64 && diff<= 127
            cat = 7;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff>= -255 && diff<= -128
            cat = 8;
            sign = 1;
            bits = zeros(1,round(len+cat));
        elseif diff>= 128 && diff<= 255
            cat = 8;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff>= -511 && diff<= -256
            cat = 9;
            sign = 1;
            bits = zeros(1,round(len+cat));
        elseif diff>= 256 && diff <= 511
            cat = 9;
            sign = 0;
            bits = zeros(1,round(len+cat));
        elseif diff>= -1023 && diff<= -512
            cat = 10;
            sign = 1;
            bits = zeros(1,round(len+cat));
        elseif diff >= 512 && diff <= 1023
            cat = 10;
            sign = 0;
            bits = zeros(1,round(len+cat));
        end

        if cat ==0
            if k == s
                bits = [ 0 0 0 0 0 0 0 0];
            elseif pair(1) == 15
                bits = [1 1 1 1 0 0 0 0 ];
            end
        else
            r_bin = dec2bin(pair(1));
            len_r = size(r_bin);
            s_bin = dec2bin(cat);
            len_s = size(s_bin);
            bits(4 - len_r(2) +1:4) = r_bin(:) - 48;
            bits(8 - len_s(2) +1:8) = s_bin(:) - 48;
            if sign == 0
                value = dec2bin(diff);
                len_add = size(value);
            elseif sign == 1
                value = dec2bin(abs(diff));
                len_add = size(value);
                
            end
            if sign == 1
                bits(8 +1: len+cat) = 1 - (value(:) - 48); %convert ascii to number
            else 
                bits(8 +1: len+cat) =  (value(:) - 48);
            end
            
        end
        cur = sum+1;
        sum = sum + len +cat;
        ad_bits(cur:sum) = bits(:);
        k = k +1;
    end
    ad_bits = ad_bits(1:sum);
return 