% close all
% Fs=60;
% x=frameT;
% 
% %y=detrendedFrameArray(3900,:);
% 
% %y=(20*sin(4*x/(pi)))+1700;
% L=length(y);
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% Y = fft(y,NFFT)/L;
% freq = Fs/2*linspace(0,1,NFFT/2+1);
% 
% % Plot single-sided amplitude spectrum.
% figure
% plot(freq,2*abs(Y(1:NFFT/2+1))) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% 
% % Fs=60;
% % x=frameT;
% % y=detrendedFrameArray(3900,:);
% % N = length(y);
% % xdft = fft(y);
% % xdft = xdft(1:N/2+1);
% % psdx = (1/(Fs*N)) * abs(xdft).^2;
% % psdx(2:end-1) = 2*psdx(2:end-1);
% % freq = 0:Fs/length(y):Fs/2;
% % 
% % figure;
% % plot(freq,10*log10(psdx))
% % grid on
% % title('Periodogram Using FFT')
% % xlabel('Frequency (Hz)')
% % ylabel('Power/Frequency (dB/Hz)')
% 
% sigma=3;
% bplength=31;
% bpcenter=ceil(bplength/2);
% bpside=bplength-bpcenter;
%  bandpass=fspecial('gauss',[1 bplength],sigma);
%  bandpass=(bandpass/max(bandpass(:)));
% %bandpass=ones(1,bplength);
% 
% freqCenter=.2014;%.239;
% centerInd=find(freq>=freqCenter,1);
% 
% bandpass=padarray(bandpass,[0 centerInd-bpside-1],0,'pre');
% bandpass=padarray(bandpass,[0 length(freq)-length(bandpass)],0,'post');
% 
% bpfilter=ones(1,length(freq));
% bpfilter=bpfilter-bandpass;
% %bpfilter=bandpass;
% 
% filtFFT=bpfilter.*Y(1:NFFT/2+1);
% 
% figure;plot(freq,2*abs(filtFFT))
% filtFFT=[filtFFT Y(NFFT/2+2:end)];
% 
% newSig=real(ifft(filtFFT*L,NFFT));
% 
% toTrim=length(newSig)-length(y);
% 
% newSig=newSig(1:end-toTrim);
% 
% figure;
% hold all
% plot(x,y,'b')
% plot(x,newSig,'r')
% 
% Fs=60;
% x=frameT;
% y=newSig;
% N = length(y);
% xdft = fft(y);
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(y):Fs/2;
% 
% figure;
% plot(freq,10*log10(psdx))
% grid on
% title('Periodogram Using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')


close all
Fs=60;
%x=frameT;
%y=(20*sin(4*x/(pi)))+1700;

x=frameT_ASO;
y=squeeze(observedRespMean(pixY,pixX,:));

fNorm= [4/(Fs/2)  12/(Fs/2)];
[b,a]=butter(10,fNorm,'stop');

figure;freqz(b,a,128,Fs)

%newY=filtfilt(b,a,y);
newY=filter(b,a,y);

figure;hold all
plot(x,y,'b');
plot(x,newY,'r');