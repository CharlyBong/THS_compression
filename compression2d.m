
function sortie=compression2d(signal2d,res)

%Matrice de départ
h = [1,1]/sqrt(2);
g = [1,-1]/sqrt(2);


%Matrice de travail
h2d   = (h'*h);
g12d = (h'*g);
g22d = (g'*h);
g32d = (g'*g);

% Inverse des matrices de convolution
h2d2   = (fliplr(h)'*fliplr(h));
g12d2 = (fliplr(h)'*fliplr(g));
g22d2 = (fliplr(g)'*fliplr(h));
g32d2 = (fliplr(g)'*fliplr(g));


if isstruct(signal2d)==0,
	x = signal2d;
	N = size(x);
	M = max(N);

	if (log2(N)~=floor(log2(N)))
		z = zeros( 2^ceil(log2(M)) , 2^ceil(log2(M)) );
		z(1:1:N(1) , 1:1:N(2)) = x;
		x = z;
		N = size(x);
	end
	
	res = min(res,floor(log2(N/size(h2d2))+1));
	sortie.res = res;
	for n=0:res-1,

		% Compression
		x1 = conv2(x,h2d);
		x2 = conv2(x,g12d);
		x3 = conv2(x,g22d);
		x4 = conv2(x,g32d);

		x   = x1(1:2:end , 1:2:end);
		y1 = x2(1:2:end , 1:2:end);
		y2 = x3(1:2:end , 1:2:end);
		y3 = x4(1:2:end , 1:2:end);

		eval(['sortie.Y1' num2str(n) ' = y1;']);
		eval(['sortie.Y2' num2str(n) ' = y2;']);
		eval(['sortie.Y3' num2str(n) ' = y3;']);
	end
	% Sauvegarde du dernier X
	eval(['sortie.X' num2str(res-1) ' = x;']);
else
	res = signal2d.res;
	eval(['x=signal2d.X' num2str(res-1) ';']);
	for n=res-1:-1:0,
		%n
		eval(['y1=signal2d.Y1' num2str(n) ';']);
		eval(['y2=signal2d.Y2' num2str(n) ';']);
		eval(['y3=signal2d.Y3' num2str(n) ';']);
		
		% Rajout de zéro
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

		x = x1 + x2 + x3 + x4;
		
		x = x(2:1:end-1 , 2:1:end-1);
		imagesc(x);colormap(gray);drawnow
		
		%plot(x);drawnow
	end
	sortie=x(1:end-1,1:end-1);
end