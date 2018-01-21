function quad1 = getquad_2(point)
%quad = [0,64,128,192,256];
quad1=zeros(1,size(point,2));
side_quad = [0,64,128,192,256];
quad_num=[1 2 3 4;5 6 7 8; 9 10 11 12;13 14 15 16 ];

for i=1:size(point,2)
x=0;
y=0;
for j=1:4
       if(point(1,i)> side_quad(j) && point(1,i)< side_quad(j+1))
       x=j;
       end
       if(point(2,i)> side_quad(j) && point(2,i)< side_quad(j+1))
       y=j;
       end
       
end
quad1(i)=quad_num(x,y);
end
end