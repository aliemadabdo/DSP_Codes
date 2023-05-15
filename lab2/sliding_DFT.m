x = [1, -4, 3, 8, 2, 7, 3, 5, 1, 8];
N = 5;
W1 = fft(x, N);
X = zeros(length(x)- N + 1, N);
X(1,:) = W1;
k = [0 : N-1];

for n = 2 : 1 : length(x)- N + 1
   X(n,:) = (X(n-1,k+1) - x(n-1) + x(n-1+N)).*exp(1i*2*pi*k/N);
   X
end
X

