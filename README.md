# THS_compression
[Projet ISEN] Compression et décompression de signal ou d'image
Réalisation sur projet sur matlab

## Exemple d'utilisation

### 1D
a = randn(1,256);<br/>
res = compression1d(compression1d(a,100),100);<br/>

### 2D
a = randn(256);<br/>
res = compression2d(compression2d(a,100),100);<br/>

### Pour une image
load Imagedurer<br/>
res = compression2d(compression2d(X,100),100);<br/>
