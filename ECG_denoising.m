clc
clearvars
load('100m.mat');
ecg=val/200;    %ecg signal from database
fs=360;
t=(0:(length(ecg)-1))/fs;
N=length(t);
load('mam.mat');% motion artifacct
ma=val/200;

ecg=ecg-mean(ecg); %pure ecg short
q=[ecg ecg ecg];  %pure ecg long

d=ecg+ma;   %noisy ecg %input signal to the WAVELET DECOMPOSITION BLOCK
[C,L] = wavedec(d,7,'db4');

                D1 = wrcoef('d',C,L,'db4',1);
                D2 = wrcoef('d',C,L,'db4',2);
                D3 = wrcoef('d',C,L,'db4',3);
                D4 = wrcoef('d',C,L,'db4',4);
                D5 = wrcoef('d',C,L,'db4',5);
                D6 = wrcoef('d',C,L,'db4',6);
                D7 = wrcoef('d',C,L,'db4',7);
                A7 = wrcoef('a',C,L,'db4',7);

ref=D1+D2+D3+A7;
d=[d d d];
x=[ref ref ref];M=12;
mu=0.01;
nlms = dsp.LMSFilter('Length',M,'Method','Normalized LMS','StepSize',mu);%Designing LMS filter
reference=x';
noisy=d';
[y1,e1] = nlms(reference,noisy);% =[y,err]=lms(ref,noisy)
y=y1';
e=e1';

figure(1)
subplot(311)
plot(q);
title('original ecg');
subplot(312)
plot(d)
title('input noisy ecg');
subplot(313)
plot(e)
title('filtered output');


