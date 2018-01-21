function class_match=knn(test_data, train_data, train_labels)

dist=pdist2(test_data,train_data,'euclidean');

[d, ind]=sort(dist,2);
k=12;
index_closest=ind(:,1:k);

class_match=[];

for i=1:800
    class_match(i)=mode(train_labels(index_closest(i,:)));
end

end