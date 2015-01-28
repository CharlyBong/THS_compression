# THS_compression
[Projet ISEN] Compression et décompression de signal ou d'image
Réalisation sur projet sur matlab

exemple d'utilisation :

1D :
a = randn(1,256);
res = compression1d(compression1d(a,100),100);

2D :
a = randn(256);
res = compression2d(compression2d(a,100),100);

Pour une image :
load Imagedurer
res = compression2d(compression2d(X,100),100);
