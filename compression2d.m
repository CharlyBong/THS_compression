% signal2d : entrée à traiter (matrice 2d)
% res	   : portée de traitement souhaitée

function sortie=compression2d(signal2d,res)

% Matrice de départ
h = [1,1]/sqrt(2);
g = [1,-1]/sqrt(2);

% Matrice de travail
h2d  = (h'*h);
g12d = (h'*g);
g22d = (g'*h);
g32d = (g'*g);

% Inverse des matrices de convolution
h2d2  = (fliplr(h)'*fliplr(h));
g12d2 = (fliplr(h)'*fliplr(g));
g22d2 = (fliplr(g)'*fliplr(h));
g32d2 = (fliplr(g)'*fliplr(g));

% Compression : Si l'entrée  n'est pas un structure 
if isstruct(signal2d)==0,
	x = signal2d;
	N = size(x);
	M = max(N);

	% Si la taille de la matrice n'est pas d'une puissance de deux on remplit avec des zéros
	if (log2(N)~=floor(log2(N)))
		z = zeros( 2^ceil(log2(M)) , 2^ceil(log2(M)) );
		z(1:1:N(1) , 1:1:N(2)) = x;
		x = z;
		N = size(x);
	end
	
	% portée entre celle souahitée et celle maximale atténiable avec la matrice donnée
	res = min(res,floor(log2(N/size(h2d2))+1));
	sortie.res = res;

	for n=0:res-1,

		% Compression
		x1 = conv2(x,h2d);
		x2 = conv2(x,g12d);
		x3 = conv2(x,g22d);
		x4 = conv2(x,g32d);
		
		% x = une valeur d'une case de 2*2
		x  = x1(1:2:end , 1:2:end);
		y1 = x2(1:2:end , 1:2:end);
		y2 = x3(1:2:end , 1:2:end);
		y3 = x4(1:2:end , 1:2:end);

		% Sauvegarde des Yn
		eval(['sortie.Y1' num2str(n) ' = y1;']);
		eval(['sortie.Y2' num2str(n) ' = y2;']);
		eval(['sortie.Y3' num2str(n) ' = y3;']);
	end

	% Sauvegarde du dernier X
	eval(['sortie.X' num2str(res-1) ' = x;']);

% Décompression : si l'entrée est une structure
else
	res = signal2d.res;

	% Récupération du dernier X
	eval(['x=signal2d.X' num2str(res-1) ';']);
	
	for n=res-1:-1:0,
		% Récupération des Yn
		eval(['y1=signal2d.Y1' num2str(n) ';']);
		eval(['y2=signal2d.Y2' num2str(n) ';']);
		eval(['y3=signal2d.Y3' num2str(n) ';']);
		
		% Pour chaque valeur de X, insertion d'une case de 2*2 remplit avec des zéros
		x1 = zeros(2*size(x));
		x1(1:2:end , 1:2:end) = x;
		
		x2 = zeros(2*size(y1));
		x2(1:2:end , 1:2:end) = y1;
		
		x3 = zeros(2*size(y2));
		x3(1:2:end , 1:2:end) = y2;
		
		x4 = zeros(2*size(y3));
		x4(1:2:end , 1:2:end) = y3;
		
		% Convolution avec les matrices inverses
		x1 = conv2(x1,h2d2);
		x2 = conv2(x2,g12d2);
		x3 = conv2(x3,g22d2);
		x4 = conv2(x4,g32d2);
		
		% Fusion
		x = x1 + x2 + x3 + x4;
		
		x = x(2:1:end-1 , 2:1:end-1);
		
		% Affichage graphique de la reconstruction
		imagesc(x);colormap(gray);drawnow
	end

	sortie=x(1:end-1,1:end-1);
end
