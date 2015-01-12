signal = [1:4];
x = signal

% Matrice de travail
h = [ 1/sqrt(2) ,  1/sqrt(2) ];
g = [ 1/sqrt(2) , -1/sqrt(2) ];

%h = [1,1];
%g = [1,-1];

h2=fliplr(h);
g2=fliplr(g);

% Compression
x1 = conv(signal,h);
y1 = conv(signal,g);

x = x1(2:2:end);
y = y1(2:2:end);
n = 0;

eval(['sortie.Y' num2str(n) '=y;']);

while (mod(length(x),2) !=1)
	n++;
	
	% Convolution
	x2 = conv(x,h);
	y2 = conv(x,g);
	
	% Réduction
	x = x2(2:2:end);
	y = y2(2:2:end);
	
	% Sauvegarde (valeur à envoyer)
	eval(['sortie.Y' num2str(n) '=y;'])	
end
% Sauvegarde du dernier X
eval(['sortie.X' num2str(n) '=x;']);

x = sortie.X2
y = sortie.Y2
"end destroy"
% end_Compression, Reconstruction

%while(length(x)< length(signal))
while(n>=0)
	n
	eval(['y=sortie.Y' num2str(n) ';']);
	
	% Rajout de zéro
	x2 = zeros(1,2*length(x));
	x2(1:2:end)= x;
	
	y2 = zeros(1,2*length(y));
	y2(2:2:end)= y;
	
	% Convalution avec les matrices inverses
	x = conv(x2,h2);
	x=x(1:1:end-1)
	
	y = conv(y2,g2);
	y=y(2:1:end)
	
	% Somme des X et Y
	x = x+y
	n--;	
end

x=int16(x)
