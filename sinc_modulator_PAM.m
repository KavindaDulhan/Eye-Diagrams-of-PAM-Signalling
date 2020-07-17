function [Tx_signal,BER] = sinc_modulator_PAM(N,Tb,Rb,bit_stream,PAM_Up,AWGN)

sinc_filter = sinc([-N:Tb:N-Tb]);

Tx_signal = conv(PAM_Up,sinc_filter,'same') + AWGN;
Tx_signal_reshaped = reshape(Tx_signal,Rb,N).';

%Getting recived signal

Rx_signal = zeros(1,2*N);
for i=1:2:2*N
    n = int16((i+1)/2);
    if Tx_signal_reshaped(n) > 1
        Rx_signal(i) = 1;
        Rx_signal(i+1) = 0;
    elseif Tx_signal_reshaped(n) <= 1 && Tx_signal_reshaped(n)> 0
        Rx_signal(i) = 1;
        Rx_signal(i+1) = 1;
    elseif Tx_signal_reshaped(n) < 0 && Tx_signal_reshaped(n)>= -1
        Rx_signal(i) = 0;
        Rx_signal(i+1) = 1;
    elseif Tx_signal_reshaped(n) < -1
        Rx_signal(i) = 0;
        Rx_signal(i+1) = 0;
    end
end

%Calculating Bit error rate

Errored_bits = 0;
for i = 1:2*N
    if bit_stream(i) ~= Rx_signal(i)
        Errored_bits = Errored_bits + 1;
    end
end

BER = Errored_bits/(2*N);
end