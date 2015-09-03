Fs=60;
x=frameT;
y=filteredFrameArray(1000,:);
%y=squeeze(mean(frameArray,1));
N = length(y);
xdft = fft(y);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(y):Fs/2;

figure;
plot(freq,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')