
[index1, value1] = xlsread('channel_response_wideband.csv');
[index2, value2] = xlsread('channel_response_narrow.csv');
[index3, value3] = xlsread('constellation_offset_200hz.csv');
[index4, value4] = xlsread('constellation_offset_400hz_N_64.csv');
[index5, value5] = xlsread('power _delay_narrow.csv');
[index6, value6] = xlsread('power_delay_wideband.csv');

f_off=[50,100,200,400,600,800,1000];
BER_64=[0 0 0 0.07 0.202 0.206 0.368];
BER_1024=[0.26 0.2776 0.3064 0.331 0.3766 0.4454 0.482];

figure
plot(f_off,log10(BER_64),'b',f_off,log10(BER_1024),'r');
legend('N=64','N=1024');
xlabel('Frequency offset [Hz]');
ylabel('BER');

figure
plot(index1(1,[5:65]),value1{2,[5:65]});


