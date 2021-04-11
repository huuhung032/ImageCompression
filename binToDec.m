function dec = binToDec(bin, n)
    dec  =0;
    i = 1;
    for i=1:n
        dec = dec + bin(i) * 2^(n-i);
    end
return