function quad = getquad(point)
%quad = [0,64,128,192,256];
quad=zeros(1,size(point,2));
side_quad = [0,128,256];
quad_num=[1 2; 3 4];

for i=1:size(point,2)
x=0;
y=0;
for j=1:2
       if(point(1,i)> side_quad(j) && point(1,i)< side_quad(j+1))
       x=j;
       end
       if(point(2,i)> side_quad(j) && point(2,i)< side_quad(j+1))
       y=j;
       end
       
end
quad(i)=quad_num(x,y);
end
end