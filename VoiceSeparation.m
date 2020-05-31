clear
clc
close all
[Original,fs]=audioread('titanium.wav');
ts=1/fs;               %ts = sample per frame | fs = Frekuensi sample          
N=length(Original)-1;    
t=0:1/fs:N/fs;                
Nfft=N;             % panjang sinyal yang dihitung transformasi Fourier
df=fs/Nfft;  
 
taa=(1:length(Original))/fs;

%tampilkan  frequensi yang dimiliki lagu ketika belum di remove voice
plot(taa,Original);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Original Song')
xlim([0,35]);
figure

%tampilkan spectrum yang dimiliki lagu ketika belum di remove voice
plot(abs(fftshift(fft(Original,fs))));
title(' Original Spectrum');
xlabel('Original Song Frequency');
ylabel('Amplitude');
 
fk=(-Nfft/2:Nfft/2-1)*df;
 
a1=1;
a2=-1;
b1=1;
b2=-1;
 
%pisahkan channel kanan dan kiri
SoundLeft=Original(:,1);
SoundRight=Original(:,2);
SoundLeft_f=ts*fftshift(fft(SoundLeft,N));
SoundRight_f=ts*fftshift(fft(SoundRight,N));  %It shifts the DC (zero frequency component) to the center of the signal
 
%didapatkan kanan dan kiri baru
NewLeft=a1*SoundLeft+a2*SoundRight;
NewRight=b1*SoundLeft+b2*SoundRight;
 
Sound(:,1)=NewLeft;
Sound(:,2)=NewRight;
Sound_Left_f=ts*fftshift(fft(NewLeft,N));
Sound_Right_f=ts*fftshift(fft(NewRight,N));
 
BP=fir1(300,[500,2000]/(fs/2));    
CutDown=filter(BP,1,Sound);     
Sound_Final=Sound-0.6*abs(CutDown);
Sound_Final_f=ts*fftshift(fft(Sound_Final,N));
 
figure
plot(taa,Sound_Final);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Final Sound')
xlim([0,35]);
figure
plot(abs(fftshift(fft(Sound_Final,fs))));
title('Final Sound');
xlabel('Frequency');
ylabel('Amplitude');
 
audiowrite('finalvoice.wav',Sound_Final,fs);
