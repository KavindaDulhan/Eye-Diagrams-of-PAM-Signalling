% TASK 1

close all;
clear all;

%Generating random BPSK symbols

N = 1000; %Length of the bit stream
Tb = 0.01; %Time of a bit duration
Rb = 1/Tb; %Bit rate
fs = 100; %sampling frequency
t_1 = 0:Tb/fs:N*Tb-Tb/fs; %time array
t_2 = 0:2*Tb/fs:N*Tb-2*Tb/fs;
t_sampled_1 = t_1(1:fs:(length(t_1) - 1)); %sampled t array with sampling frequency
t_sampled_2 = t_1(1:2*fs:(length(t_1) - 1));

bit_stream = rand(1,N)>0.5; %Random binary bit stream 
BPSK_symbols = 2*(bit_stream)-1; %BPSK symbol stream

BPSKUpsampled = [BPSK_symbols;zeros(Rb-1,length(BPSK_symbols))];
BPSK_Up = BPSKUpsampled(:).'; %sampling BPSK symbols

%Plotting bit stream and BPSK symbol train

figure;
subplot(2,1,1)
stairs(t_sampled_1,bit_stream);
xlabel('Time (s)')
ylabel('Amplitude')
title('Transmit bit stream')
xlim([0 0.5])
ylim([-0.2 1.2])

subplot(2,1,2)
stem(t_sampled_1,BPSK_symbols,'filled');
xlabel('Time (s)')
ylabel('Amplitude')
title('BPSK symbol stream')
xlim([0 0.5])
ylim([-1.2 1.2])

%Generating transmit signal with sinc pulse and without AWGN

[Tx_signal1,BER1] = sinc_modulator_new(N,Tb,Rb,bit_stream,BPSK_Up,0);

%Plotting transmitted impulse train

figure;
plot(t_1,Tx_signal1);
hold on;
stem(t_sampled_1,BPSK_symbols,'k','Linestyle','--');
xlabel('Time (s)')
ylabel('Amplitude')
title('transmitted impulse train')
xlim([0 0.1])

%Generating eye diagram for transmit signal

eyediagram(Tx_signal1,200,2*Tb)
xlabel('Time (s)')
title('Eye diagram for sinc function without AWGN')
%%

%Generating transmit signal with raised cosine pulse and without AWGN
%(roll-off = 0.5)

alpha = 0.5; %roll-off factor

[Tx_signal2,BER2] = rcos_modulator_new(N,Tb,Rb,bit_stream,BPSK_Up,alpha,0);

%Plotting transmitted impulse train

figure;
plot(t_1,Tx_signal2);
hold on;
stem(t_sampled_1,BPSK_symbols,'k','Linestyle','--');
xlabel('Time (s)')
ylabel('Amplitude')
title('transmitted impulse train')
xlim([0 0.1])

%Generating eye diagram for transmit signal

eyediagram(Tx_signal2,200,2*Tb)
xlabel('Time (s)')
title('Eye diagram for raised cosine function with roll off 0.5 and without AWGN')

%%

%Generating transmit signal with raised cosine pulse and without AWGN
%(roll-off = 0.5)

alpha = 1; %roll-off factor

[Tx_signal3,BER3] = rcos_modulator_new(N,Tb,Rb,bit_stream,BPSK_Up,alpha,0);

%Plotting transmitted impulse train

figure;
plot(t_1,Tx_signal3);
hold on;
stem(t_sampled_1,BPSK_symbols,'k','Linestyle','--');
xlabel('Time (s)')
ylabel('Amplitude')
title('transmitted impulse train')
xlim([0 0.1])

%Generating eye diagram for transmit signal

eyediagram(Tx_signal3,200,2*Tb)
xlabel('Time (s)')
title('Eye diagram for raised cosine function with roll off 1 and without AWGN')
%%

% Task 2

%Generating AWGN

Eb = 1; %average bit energy
SNR = 10; %SNR in dB
N_0 = Eb*10^(-0.1*SNR); %Noise power spectral density
AWGN = ((N_0/2)^0.5)*randn(1,N*fs);

%Generating transmit signal with sinc pulse and without AWGN

[Tx_signal4,BER4] = sinc_modulator_new(N,Tb,Rb,bit_stream,BPSK_Up,AWGN);

%Plotting transmitted impulse train

figure;
plot(t_1,Tx_signal4);
hold on;
stem(t_sampled_1,BPSK_symbols,'k','Linestyle','--');
xlabel('Time (s)')
ylabel('Amplitude')
title('transmitted impulse train')
xlim([0 0.1])

%Generating eye diagram for transmit signal

eyediagram(Tx_signal4,200,2*Tb)
xlabel('Time (s)')
title('Eye diagram for sinc function with AWGN')

%%

%Generating transmit signal with raised cosine pulse and with AWGN
%(roll-off = 0.5)

alpha = 0.5; %roll-off factor

[Tx_signal5,BER5] = rcos_modulator_new(N,Tb,Rb,bit_stream,BPSK_Up,alpha,AWGN);

%Plotting transmitted impulse train

figure;
plot(t_1,Tx_signal5);
hold on;
stem(t_sampled_1,BPSK_symbols,'k','Linestyle','--');
xlabel('Time (s)')
ylabel('Amplitude')
title('transmitted impulse train')
xlim([0 0.1])

%Generating eye diagram for transmit signal

eyediagram(Tx_signal5,200,2*Tb)
xlabel('Time (s)')
title('Eye diagram for raised cosine function with roll off 0.5 and with AWGN')

%%

%Generating transmit signal with raised cosine pulse and with AWGN
%(roll-off = 1)

alpha = 1; %roll-off factor

[Tx_signal6,BER6] = rcos_modulator_new(N,Tb,Rb,bit_stream,BPSK_Up,alpha,AWGN);

%Plotting transmitted impulse train

figure;
plot(t_1,Tx_signal6);
hold on;
stem(t_sampled_1,BPSK_symbols,'k','Linestyle','--');
xlabel('Time (s)')
ylabel('Amplitude')
title('transmitted impulse train')
xlim([0 0.1])

%Generating eye diagram for transmit signal

eyediagram(Tx_signal6,200,2*Tb)
xlabel('Time (s)')
title('Eye diagram for raised cosine function with roll off 1 and with AWGN')

%%

%Task 3

%Generating 4-PAM symbols
PAM_symbols = zeros(1,N/2);

for i = 1:2:N
    if bit_stream(i) == 0 && bit_stream(i+1) == 0
        PAM_symbols(round(i+1)/2) = -1.5;
    elseif bit_stream(i) == 0 && bit_stream(i+1) == 1
        PAM_symbols(round(i+1)/2) = -0.5;
    elseif bit_stream(i) == 1 && bit_stream(i+1) == 1
        PAM_symbols(round(i+1)/2) = 0.5;
    elseif bit_stream(i) == 1 && bit_stream(i+1) == 0
        PAM_symbols(round(i+1)/2) = 1.5;
    end
end

PAMUpsampled = [PAM_symbols;zeros(Rb-1,length(PAM_symbols))]; 
PAM_Up = PAMUpsampled(:).'; %sampling PAM symbol stream

%Plotting bit stream and 4-PAM symbol train

figure;
subplot(2,1,1)
stairs(t_sampled_1,bit_stream);
xlabel('Time (s)')
ylabel('Amplitude')
title('Transmit bit stream')
xlim([0 0.5])
ylim([-0.2 1.2])

subplot(2,1,2)
stem(t_sampled_2,PAM_symbols,'filled');
xlabel('Time (s)')
ylabel('Amplitude')
title('4-PAM symbol stream')
xlim([0 0.5])
ylim([-1.7 1.7])

%Generating AWGN

Eb = 1; %average bit energy
SNR = 10; %SNR in dB
N_0 = Eb*10^(-0.1*SNR); %Noise power spectral density
AWGN_PAM = ((N_0/2)^0.5)*randn(1,(N/2)*fs);

%Generating transmit signal with sinc pulse and with AWGN

[Tx_signal7,BER7] = sinc_modulator_PAM(N/2,Tb,Rb,bit_stream,PAM_Up,AWGN_PAM);

%Plotting transmitted impulse train

figure;
plot(t_2,Tx_signal7);
hold on;
stem(t_sampled_2,PAM_symbols,'k','Linestyle','--');
xlabel('Time (s)')
ylabel('Amplitude')
title('transmitted impulse train')
xlim([0 0.2])

%Generating eye diagram for transmit signal

eyediagram(Tx_signal7,200,2*Tb)
xlabel('Time (s)')
title('Eye diagram for 4-PAM system with sinc function')

%%

%Generating transmit signal with raised cosine pulse and with AWGN
%(roll-off = 0.5)

alpha = 0.5; %roll-off factor

[Tx_signal8,BER8] = rcos_modulator_PAM(N/2,Tb,Rb,bit_stream,PAM_Up,alpha,AWGN_PAM);

%Plotting transmitted impulse train

figure;
plot(t_2,Tx_signal8);
hold on;
stem(t_sampled_2,PAM_symbols,'k','Linestyle','--');
xlabel('Time (s)')
ylabel('Amplitude')
title('transmitted impulse train')
xlim([0 0.2])

%Generating eye diagram for transmit signal

eyediagram(Tx_signal8,200,2*Tb)
xlabel('Time (s)')
title('Eye diagram for raised cosine function with roll off 0.5 4-PAM system')

%%

%Generating transmit signal with raised cosine pulse and with AWGN
%(roll-off = 1)

alpha = 1; %roll-off factor

[Tx_signal9,BER9] = rcos_modulator_PAM(N/2,Tb,Rb,bit_stream,PAM_Up,alpha,AWGN_PAM);

%Plotting transmitted impulse train

figure;
plot(t_2,Tx_signal9);
hold on;
stem(t_sampled_2,PAM_symbols,'k','Linestyle','--');
xlabel('Time (s)')
ylabel('Amplitude')
title('transmitted impulse train')
xlim([0 0.2])

%Generating eye diagram for transmit signal

eyediagram(Tx_signal9,200,2*Tb)
xlabel('Time (s)')
title('Eye diagram for raised cosine function with roll off 1 4-PAM system')