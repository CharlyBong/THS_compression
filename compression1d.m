% signal : entrée à traiter
% res 	 : portée de traitement souhaitée

function sortie=compression1d(signal,res)

% Matrice de travail
h = [1,1]/sqrt(2);
g = [1,-1]/sqrt(2);

h2 = fliplr(h);
g2 = fliplr(g);

% si le signal n'est pas une structure (compression)
if isstruct(signal)==0,
	x = signal;
	N = length(x);

	% Si la taille signal n'est pas d'une puissance de deux on remplit de zéro
	if (log2(N)~=floor(log2(N)))
		x = [x zeros(1,2^ceil(log2(N))-N)];
		N = length(x);
	end

	% portée entre celle rentrée et celle maximale atténiable avec le signal donnée
	res = min(res,floor(log2(N/length(h))+1));
	sortie.res = res;


	for n=0:res-1,

		% Compression
		x1 = conv(x,h);
		y1 = conv(x,g);
		
		% x = une valeur sur 2 de x1
		x = x1(1:2:end);
		y = y1(1:2:end);
		
		% Sauvegarde des Yn 
		eval(['sortie.Y' num2str(n) '=y;']);
	
	end
	
	% Sauvegarde du dernier X
	eval(['sortie.X' num2str(res-1) '=x;']);

% si le signal est un structure (décompression)	
else
	res = signal.res;
	
	% Récupération du dernier X
	eval(['x=signal.X' num2str(res-1) ';']);

	for n=res-1:-1:0,
		% Récupération des Yn
		eval(['y=signal.Y' num2str(n) ';']);
		
		% Rajout de zéro entre chaque valeur de x
		x2 = zeros(1,2*length(x));
		x2(1:2:end) = x;
		
		y2 = zeros(1,2*length(y));
		y2(1:2:end) = y;
		
		% Convalution avec les matrices inverses
		x = conv(x2,h2) + conv(y2,g2);
		x = x(2:1:end-1);

		% Affichage graphique de la reconstruction
		%plot(x);drawnow
	end

	sortie = x(1:end-1);
end
