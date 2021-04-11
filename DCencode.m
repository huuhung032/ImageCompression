
function dc_bits = DCencode(coeff, coeff_1)

% coeff = [    16    11    12    14    12    10    16    14    13    14    18    17    16    19    24    40    26 24    22    22    24    49    35    37    29    40    58    51    61    60    57    51    56    55  64    72    92    78    64    68    87    69    55    56    80   109    81    87    95    98   103 104   103    62    77   113   121   112   100   120    92   101   103    99
% ];
% 
% coeff_1 = [    0    0    12    14    12    10    16    14    13    14    18    17    16    19    24    40    26 24    22    22    24    49    35    37    29    40    58    51    61    60    57    51    56    55  64    72    92    78    64    68    87    69    55    56    80   109    81    87    95    98   103 104   103    62    77   113   121   112   100   120    92   101   103    99
% ];
    diff = coeff_1(1) - coeff(1)

    if diff ==0
        cat =0;
        sign = 0;
        len = 2;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [0 0];
    elseif diff == -1
        cat = 1;
        sign = 1;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 0 1 0];
    elseif diff ==1
        cat = 1;
        sign = 0;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 0 1 0];
    elseif diff >= -3 && diff <= -2
        cat =2;
        sign = 1;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 0 1 1];
    elseif diff >= 2 && diff <= 3
        cat = 2;
        sign = 0;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 0 1 1];
    elseif diff >= -7 && diff <= -4
        cat = 3;
        sign = 1;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [1 0 0];
    elseif diff >=4 && diff <= 7
        cat = 3;
        sign = 0;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [1 0 0];
    elseif diff >= -15 && diff<= -8
        cat = 4;
        sign =1;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [1 0 1];
    elseif diff >= 8 && diff<= 15
        cat = 4;
        sign = 0;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [1 0 1];
    elseif diff >= -31 && diff<= -16
        cat = 5;
        sign = 1;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 0];
    elseif diff>= 16 &&diff <= 31
        cat = 5;
        sign = 0;
        len = 3;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 0];
    elseif diff>= -63 && diff<= -32
        cat = 6;
        sign = 1;
        len = 4;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 0];
    elseif diff>= 32 && diff <= 63
        cat = 6;
        sign = 0;
        len = 4;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 0];
    elseif diff >= -127 && diff<= -64
        cat = 7;
        sign =1;
        len = 5;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 0];
    elseif diff>= 64 && diff<= 127
        cat = 7;
        sign = 0;
        len = 5;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 0];
    elseif diff>= -255 && diff<= -128
        cat = 8;
        sign = 1;
        len = 6;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 1 0];
    elseif diff>= 128 && diff<= 255
        cat = 8;
        sign = 0;
        len = 6;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 1 0];
    elseif diff>= -511 && diff<= -256
        cat = 9;
        sign = 1;
        len = 7;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 1 1 0];
    elseif diff>= 256 && diff <= 511
        cat = 9;
        sign = 0;
        len = 7;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 1 1 0];
    elseif diff>= -1023 && diff<= -512
        cat = 10;
        sign = 1;
        len = 8;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 1 1 1 0];
    elseif diff >= 512 && diff <= 1023
        cat = 10;
        sign = 0;
        len = 8;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 1 1 1 0];
    elseif diff >= -2047 && diff <= -1024
        cat = 11;
        sign = 1;
        len = 9;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 1 1 1 1 0];
    elseif diff>= 1024 && diff <= 2047
        cat = 11;
        sign = 0;
        len = 9;
        bits = zeros(1,round(len+cat));
        bits(1:len) = [ 1 1 1 1 1 1 1 1 0];
    end

    
    if len > 0 %diff != 0
        if sign == 0
            value = dec2bin(diff);
            len_add = size(value);
        else 
            value = dec2bin(abs(diff));
            len_add = size(value);
           
        end
       
        if sign == 0
            bits(len+ 1 + len_add(2) - cat: len+cat) = value(:) - 48; %convert ascii to number
        else
            bits(len+ 1 + len_add(2) - cat: len+cat) = 1 - ( value(:) - 48);
        end
    end
    dc_bits = bits;
return

