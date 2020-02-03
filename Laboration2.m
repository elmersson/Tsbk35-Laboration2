clear; clc; tic;
%% L�ser in filen/signalen
[y, fs] = audioread('heyhey.wav');

% Hitta min/max frekvenser
highFreq = max(y);
lowFreq = min(y);

% V�lj blockstorlek till mdct
blockSize = 512;

% V�lj storlek p� kvantiseringssteg
quantStep = (highFreq - lowFreq)/24.419;

% Utf�r transformering p� signalen
yTransformed = mdct(y, blockSize);

% Utf�r kvantisering p� transformkomponenterna
yQuantized = round(yTransformed/quantStep);

% IC �r alla index till v�rden p� kvantiserade komponenter
[~,~,IC] = unique(yQuantized);

% Reshape till vektorform
accu = accumarray(IC(:),1);

% Skapa en sannolikhetsmatris
prob = accu/sum(sum(accu));

% Ber�kna datatakt vid huffmankodning
huff = huffman(prob);

% Avkoda den komprimerade signalen
yComp = imdct(yQuantized*quantStep);

% Skriv den avkodade signalen till en fil
audiowrite('heyhey_compressed.wav', yComp, fs);

% Ber�kna SNR
SnrDb = snr(y, yComp - y);

toc;