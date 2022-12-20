clear
close all
C8
%%
%Block divide

grayImg = imread('gray_Img.PNG');       %Reading image

[rows ,cols] = size(grayImg);            %Get number of rows and columns of the image           

paddedRows = N*ceil(rows/N);            %Number of rows divisible by 8
paddedCols = N*ceil(cols/N);            %Number of columns divisible by 8

paddedImg=zeros(paddedRows ,paddedCols);
paddedImg(1:rows,1:cols)= grayImg;      %Divisible by 8 image with zero padding

% ---->>>>>reshape fn needs low level implementation <<<<<---------
block8by8 = reshape(paddedImg,N,N,[]);  %The 8x8 blocks of the image 
%block8by8(5,5,1450)                    %An example for the block 1450 fifth row fifth column

[x ,y ,numberOfBlocks]=size(block8by8);

DctOfTheBlock =zeros(N,N,numberOfBlocks); %could be discarded and use the varaible "block8by8" directly

%loop on all blocks to apply DCT with C8 on them                                          
for i=1:numberOfBlocks
    DctOfTheBlock(:,:,i)= C_8*block8by8(:,:,i)*(C_8.'); %A^=CN*A*CN(transpose)
end
disp(DctOfTheBlock);
%%
%Quantization
%A Standard Quantization Matrix for 50% quality 
r=input("Enter Scaling factor  ") %used  to change quantization level
q_mtx =     [16 11 10 16 24 40 51 61; 
            12 12 14 19 26 58 60 55;
            14 13 16 24 40 57 69 56; 
            14 17 22 29 51 87 80 62;
            18 22 37 56 68 109 103 77;
            24 35 55 64 81 104 113 92;
            49 64 78 87 103 121 120 101;
            72 92 95 98 112 100 103 99];

q = rescale(q_mtx,r,numberOfBlocks,DctOfTheBlock)

%%
%Rescaling 
R = rescaling(q,r,q_mtx,numberOfBlocks)

%%
%IDCT

%%
%Merging 

%%functions
function quantized_dct = rescale(x,y,n,dct)
    T=y.*x
    for k=1:n
        quantized_dct(:,:,k)= round(dct(:,:,k) ./ T); 
    end
    disp(quantized_dct);      
end 

function rescaled_dct = rescaling(y,r,q,n)
  T=r.*q;
  for k=1:n
    rescaled_block8by8(:,:,k) = y(:,:,k) .* T;
  end
  disp(rescaled_block8by8);
end

