clear; clc; tic;
%% L�ser in filen/signalen
[y, fs] = audioread('heyhey.wav');

highFreq = max(y);
lowFreq = min(y);
blockSize = 1024;

steps = (highFreq - lowFreq)/24;

trans = mdct(y, blockSize);

quant = round(trans/steps);

[C,IA,IC] = unique(quant);

accu = accumarray(IC(:),1);
 
prob = accu/sum(sum(accu));

huff = huffman(prob);

yComp = imdct(quant);

audiowrite('karl.wav', yComp, fs);

diff = y - yComp;

d = mean(diff.^2);

Snrdb = 10*log10(var(y)/d);

toc;