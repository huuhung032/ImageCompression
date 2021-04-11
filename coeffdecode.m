%bits = [1     0     0     1     0     1		 0     0     1     0     0     1     0     0     1     1     1     0     0     1     0     0     0     1     0     0     1     1     0     1     0     0     1     0     0     1	0     1     1     0     0     0     1     0     1     0     0     0     1     0     1     1     1     0     1     0     1     1     1     1     0     0     0     0     0     0	1     0     0     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     1     1     1     1     0     0     1     0     0     0     0     1	1     0     0     1     1     0     1     1     0     1     1     1     0     0     0     0     0     1     1     0     1     1     1     0     0     0     0     0     0     0	0     1     1     1     1     0     1     0     0     0     0     1     0     0     0     0     1     1     0     1     1     1     1     1     0     0     0     0     1     0	1     1     1     1     1     1     0     0     0     1     0     0     0     0     0     1     1     1     1     1     1     1     0     0     1     0     0     0     0     0 	0     0     0
%];


    %% DC coefficient decode %%
    % % % % % % % % % % % % % %
    function coeff = coeffdecode(bts)
    %bts = [1    0   1   1   1   0   1   0     0     0     0     0     0     1     1     0     1     0     0     0     0     0     0     0     1     1     0     0     1      0     0     0     0     0     0     0     1     0     0     0     0     0     0     0     0     1     0     0     0     0     0	0     0     1     0     0     1     0     0     1     1     0     0     0     1     0     0     0     1     0     0     0     0     1     1     1     1     1     1     0     0     0     0     1     1     1     1     0     0     0     0     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0];
    cat_dc = -1;
    while cat_dc < 0
        %choose 10 as threshold
        if bts(1:2) == [0 0]
            cat_dc = 0;
            len = 2;
            break;
        elseif bts(1:3) == [0 1 0] 
            cat_dc = 1;
            len = 3;
            break;
        elseif  bts(1:3) == [0 1 1]
            cat_dc = 2;
            len = 3;
            break;
        elseif  bts(1:3) == [1 0 0]
            cat_dc = 3;
            len = 3;
            break;
        elseif bts(1:3) == [1 0 1]
            cat_dc = 4;
            len = 3;
            break;
        elseif bts(1:3) == [1 1 0]
            cat_dc = 5;
            len = 3;
            break;
        elseif bts(1:4) == [1 1 1 0]
            cat_dc = 6;
            len = 4;
            break;
        elseif bts(1:5) == [1 1 1 1 0]
            cat_dc = 7;
            len = 5;
            break;
        elseif bts(1:6) == [1 1 1 1 1 0]
            cat_dc = 8;
            len = 6;
            break;
        elseif bts(1:7) == [1 1 1 1 1 1 0]
            cat_dc = 9;
            len = 7;
            break;
        elseif bts(1:8) == [1 1 1 1 1 1 1 0]
            cat_dc = 10;
            len = 8;
            break;
        elseif bts(1:9) == [1 1 1 1 1 1 1 1 0]
            cat_dc =11;
            len = 9;
            break;
        end
    end

    if bts(len+1) == 1
        sign = 0;
    else sign = 1;
    end

    dc_value = bts(len+1:len+cat_dc);
    if sign == 1
        sizd = size(dc_value);
        for v=1:sizd(2)
            if dc_value(v) ==0
                dc_value(v) =1;
            else dc_value(v) =0
            end
        end
    end
    dc = binToDec(dc_value, cat_dc);
    if sign == 1
        dc = dc * (-1);
    end

    % % AC coefficients decoder  % % %
    % % % % % % % % % % % % % % % % %
    isdone = 0;
    k = len+cat_dc+1; % start ad_bits
    s = 1;
    ads = 1:63;
    while isdone < 10
        ad_header = bts(k:k+7);
        if ad_header == [0 0 0 0 0 0 0 0]
            for i=s:63
                ads(i) = 0;
            end
            isdone = 12;
        elseif ad_header == [1 1 1 1 0 0 0 0]
            for i=s:s+14
                ads(i) = 0;
            end
            s = s +15;
            k = k +8;
           % k = k + 8 +2; %remember you encode value 0 too. it takes 2 bits to encode 0, so the step is 8 + 2, not 8.
        else
            r_bin = ad_header(1:4);
            s_bin = ad_header(5:8);

            count = binToDec(r_bin, 4);
            for i=1:count
                ads(s+i -1) = 0;
            end
            s = s + count;
            size_ac = binToDec(s_bin, 4);
            value_ac = bts(k+8:k+8+size_ac-1);
            if value_ac(1) == 0
                sign_a = 1;
            elseif value_ac(1) ==1
                sign_a = 0;
            end
            size_ac;
            if sign_a == 1
                for v=1:size_ac
                    if value_ac(v) ==0
                        value_ac(v) =1;
                    else value_ac(v) =0;
                    end
                end
            end
            
            ac = binToDec(value_ac, size_ac);
            if sign_a == 1
                ac = ac *(-1);
            end
            ads(s) = ac;
            s = s +1;
            if s == 64
                isdone = 12;
            end
            k = k +8 + size_ac;
        end
        
 
    end

    coeff = 1:64;
    coeff(1) = dc;
    coeff(2:64) = ads(:);
    %coeff(1) = dc + pr;
    rldc = dc ;
    %DCTdecompress(coeff, rldc);
return

