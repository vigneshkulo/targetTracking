close all
clear all

%Read the input video%
ip=mmreader('outdoor an 320.avi');
frames=read(ip);
no=get(ip,'numberOfFrames');
s=size(frames);
height=s(1); m=height;
width=s(2);  n=width;

%Create Xb and Xf%
bck=frames(:,:,:,100);

for i1=1:no
fg=frames(:,:,:,i1);
xb=zeros(1,(m*n));
xf=zeros(1,(m*n));
bckgry=rgb2gray(bck);
fggry=rgb2gray(fg);

%Create Xb abd Xf with k =m * n elements%

for i=1:m
    for j=1:n
        xb((i-1)*n+j)=bckgry(i,j);
        xf((i-1)*n+j)=fggry(i,j);
    end
end

%Xt matrix with xb and xf%
xb=double(xb);
xf=double(xf);
xt=[xb;xf];


w2=[ 0.2401   -0.3122];   
   

y=w2*xt;
y=uint8(y);

ifg=zeros(m,n);
ifg1=zeros(m,n);
q=y(1,:);

for u=1:m
    for v=1:n
        ifg(u,v)=q((u-1)*n+v);
    end
end

z=zeros(16);
ifg=(uint8(ifg));
q=double(q);
k1=mean(q)+1.5*(sqrt(var(q)));
for u=1:m
    for v=1:n
        if ifg(u,v)> k1
            ifg1(u,v)=255;
        end
    end
end

ifg1 = bwmorph(ifg1,'dilate',2);
ifg1 = bwmorph(ifg1,'erode',2);
%ifg1 = bwmorph(ifg1,'clean');

%se = strel('square',5);
%ifg1 = imdilate(ifg1,se);
        
[image1 num] = bwlabel(ifg1);
        
stats = regionprops(image1, 'BoundingBox');
stat=regionprops(image1);
g = fg;
[M N] = size(stats);

for k = 1:M
for i = floor(stats(k).BoundingBox(1)):floor(stats(k).BoundingBox(1))+stats(k).BoundingBox(3)
for j = floor(stats(k).BoundingBox(2)):floor(stats(k).BoundingBox(2))+stats(k).BoundingBox(4)
 x1 = floor(stats(k).BoundingBox(1));
 y1 = floor(stats(k).BoundingBox(2));
%if(i==0||y1==0)
%      g(y1,i+1) = 255; 
%      g(y1+stats(k).BoundingBox(4),i+1) = 255;
%else
%    g(y1+1,i)=255;
%    g(y1+stats(k).BoundingBox(4),i) = 255;
%end
%if(j==0||x1==0)
%      g(j+1,x1+1) = 255;
%      g(j+1,x1+stats(k).BoundingBox(3)) = 255;
%else
%    g(j,x1) = 255;
%    g(j,x1+stats(k).BoundingBox(3)) = 255;
%end
g(y1+1,i+1,:) = 0;
g(y1+stats(k).BoundingBox(4),i+1,:) = 0;
g(j+1,x1+1,:) = 0;
g(j+1,x1+stats(k).BoundingBox(3),:) = 0;

end
end
end
        
    

figure(1)
%subplot(2,2,1),imshow(fg),title('Background with foreground Image')
%subplot(2,2,2),imshow(fggry),title('Background with foreground Image')
%subplot(2,2,3),imshow(ifg),title('Foreground image')
%subplot(2,2,4),

        imshow(g)
       

end

