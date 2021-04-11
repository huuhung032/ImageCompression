Y= imread('lena.jpg');
% Y = I;
[h, w] = size(Y);
r = h/8;
c = w/8;
s = 1;
q50 = [16 11 10 16 24 40 51 61;
       12 12 14 19 26 58 60 55;
       14 13 16 24 40 57 69 56;
       14 17 22 29 51 87 80 62;
       18 22 37 56 68 109 103 77;
       24 35 55 64 81 104 113 92;
       49 64 78 87 103 121 120 101;
       72 92 95 98 112 100 103 99];
   ok=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
%    COMPRESSION
for i=1:r
    e = 1;
    for j=1:c
        block = Y(s:s+7,e:e+7);
        cent = double(block) - 128;
        for m=1:8
            for n=1:8
                if m == 1
                    u = 1/sqrt(8);
                else
                    u = sqrt(2/8);
                end
                if n == 1
                    v = 1/sqrt(8);
                else
                    v = sqrt(2/8);
                end
                comp = 0;
                for x=1:8
                    for y=1:8
                        comp = comp + cent(x, y)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
                    end
                end
                  F(m, n) = v*u*comp;
              end
          end
          for x=1:8
              for y=1:8
                  cq(x, y) = round(F(x, y)/q50(x, y));
              end
          end
          Q(s:s+7,e:e+7) = cq;
          e = e + 8;
      end
      s = s + 8;
  end
count=1;
s=1;
for i=1:r
    e = 1;
    for j=1:c
        blk = Q(s:s+7,e:e+7); 
        zigzag=ZigZagscan(blk);
        zigzag_stream(count:count+63) =zigzag;
        count=count+64;
        e = e + 8;
      end
      s = s + 8;
end

count1=1;
sz=size(zigzag_stream);
x=sz(2)/64;
sz1=0;
dem=1;
for i=1:x
    if(i==1)
      for j=1:64
          oldz(j)=0;
      end
    end
    zz=zigzag_stream(count1:count1+63);
    dcbit=DCencode(oldz,zz);
    oldz=zz;
    acbit=ACencode(zz);
    sdc=size(dcbit);
    sac=size(acbit);
    bits(1+sz1:sz1+sdc(2))=dcbit(:);
    bits(sz1+sdc(2)+1:sz1+sdc(2)+sac(2))=acbit(:);
    sz1=sz1+sdc(2)+sac(2);
    count1=count1+64;
    si(dem)=sdc(2)+sac(2);
    dem=dem+1;
end
size_bits=size(bits);
down=0;
dem1=1;
count2=1
for i=1:size_bits(2)
    if(down==size_bits(2))
        break
    end
    base=bits(1+down:size_bits(2));
    base1=coeffdecode(base);
    down=down+si(dem1);
    dem1=dem1+1;
    zizi(count2:count2+63)=base1;
    if(count2>1)
        zizi(count2)=zizi(count2)+zizi(count2-64);
    end
    count2=count2+64;
end
count3=1;
s=1;
for i=1:r
    e = 1;
    for j=1:c
        z1=zizi(count3:count3+63);
        bk=izigzag(z1,8,8);
        Q2(s:s+7,e:e+7)=bk;
        count3=count3+64;
        e = e + 8;
      end
      s = s + 8;
end
% % % % % % % % % % % % % % %     
% % DECOMPRESSION
% % % % % % % 
s = 1;
for i=1:r
    e = 1;
    for j=1:c
        cq = Q2(s:s+7,e:e+7);
        for x=1:8
            for y=1:8
                DQ(x, y) = q50(x, y)*cq(x, y); 
            end
        end
        for x = 1:8
        for y = 1:8
            comp = 0;
            for m = 1:8
                for n = 1:8
                    if m == 1
                        u = 1/sqrt(2);
                    else
                        u = 1;
                    end
                    if n == 1
                        v = 1/sqrt(2);
                    else
                        v = 1;
                    end
                    
                    comp = comp + u*v*DQ(m, n)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
                end
            end
           bf(x, y) =  round((1/4) *comp + 128);           
        end
        end
           Org(s:s+7,e:e+7) = bf;
           e = e + 8;
      end
      s = s + 8;
    end
  imshow(uint8(Org))
  figure
  imshow(Y);

