function [Tx_signal,BER] = sinc_modulator_new(N,Tb,Rb,bit_stream,BPSK_Up,AWGN)

sinc_filter = sinc([-N:Tb:N-Tb]);

Tx_signal = conv(BPSK_Up,sinc_filter,'same') + AWGN;
Tx_signal_reshaped = reshape(Tx_signal,Rb,N).';

%Getting recived signal

Rx_signal = zeros(1,N);
for i = 1:N
    if Tx_signal_reshaped(i) < 0
        Rx_signal(i) = 0;
    else
        Rx_signal(i) = 1;
    end
end

%Calculating Bit error rate

Errored_bits = 0;
for i = 1:N
    if bit_stream(i) ~= Rx_signal(i)
        Errored_bits = Errored_bits + 1;
    end
end

BER = Errored_bits/N;
end