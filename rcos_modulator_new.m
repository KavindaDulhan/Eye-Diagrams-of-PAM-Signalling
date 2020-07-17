function [Tx_signal,BER] = rcos_modulator_new(N,Tb,Rb,bit_stream,BPSK_Up,alpha,AWGN)

%Creating sinc filter
sinc_filter = sinc([-N:Tb:N-Tb]);

%Creating raised cosine filter
cosNum = cos(alpha*pi*[-N:Tb:N-Tb]);
cosDen = (1-(2*alpha*[-N:Tb:N-Tb]).^2);
cosDenZero = find(abs(cosDen)<10^-10);
cosOp = cosNum./cosDen;
cosOp(cosDenZero) = pi/4;

gt_alpha = sinc_filter.*cosOp;

Tx_signal = conv(BPSK_Up,gt_alpha,'same') + AWGN;
Tx_signal_reshaped = reshape(Tx_signal,Rb,N).';

Rx_signal = zeros(1,N);
for i = 1:N
    if Tx_signal_reshaped(i) < 0
        Rx_signal(i) = 0;
    else
        Rx_signal(i) = 1;
    end
end

Errored_bits = 0;
for i = 1:N
    if bit_stream(i) ~= Rx_signal(i)
        Errored_bits = Errored_bits + 1;
    end
end

BER = Errored_bits/N;

end