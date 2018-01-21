function centroids=kmeans_cluster(d,K)

iter = 10;
centroids = zeros(K,size(d,2)); 
random_idx = randperm(size(d,1));
centroids = d(random_idx(1:K), :);


for i=1:iter
  
   u = size(centroids, 1);
  idx = zeros(size(d,1), 1);
  t = size(d,1);

  for i=1:t
    k = 1;
    distance_min = sum((d(i,:) - centroids(1,:)) .^ 2);
    for j=2:u
        distance = sum((d(i,:) - centroids(j,:)) .^ 2);
        if(distance < distance_min)
          distance_min = distance;
          k = j;
        end
    end
    idx(i) = k;
  end
  
  [r c] = size(d);
  centroids = zeros(u, c);
  
  for i=1:u
    p = d(idx==i,:);
    cent= size(p,1);
    centroids(i, :) = (1/cent) * sum(p);
  end
  
end
end