function sortie=premiertest1(signal,res)

% Matrice de travail
h = [1,1]/sqrt(2);
g = [1,-1]/sqrt(2);

h2=fliplr(h);
g2=fliplr(g);

if isstruct(signal)==0,
	x = signal;
	N = length(x);
	if (log2(N)~=floor(log2(N)))
		x = [x zeros(1,2^ceil(log2(N))-N)];
		N = length(x);
	end
	res = min(res,floor(log2(N/length(h))+1));
	sortie.res = res;
	for n=0:res-1,

		% Compression
		x1 = conv(x,h);
		y1 = conv(x,g);

		x = x1(1:2:end);
		y = y1(1:2:end);

		eval(['sortie.Y' num2str(n) '=y;']);
	end
	% Sauvegarde du dernier X
	eval(['sortie.X' num2str(res-1) '=x;']);
else
	res = signal.res;
	eval(['x=signal.X' num2str(res-1) ';']);
	for n=res-1:-1:0,
		eval(['y=signal.Y' num2str(n) ';']);
		
		% Rajout de zéro
		x2 = zeros(1,2*length(x));
		x2(1:2:end)= x;
		
		y2 = zeros(1,2*length(y));
		y2(1:2:end)= y;
		
		% Convalution avec les matrices inverses
		x = conv(x2,h2)+conv(y2,g2);
		x=x(2:1:end-1);
		%plot(x);drawnow
	end
	sortie=x(1:end-1);
end
