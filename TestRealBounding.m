close all
clear all

vid = videoinput('winvideo',1,'YUY2_320x240');    %Create Video Object
set(vid,'ReturnedColorSpace','RGB');              %Convert To RGB
triggerconfig(vid, 'manual');                     %Trigger Type Manual
frame=200;
set(vid,'FramesPerTrigger',frame); 
set(vid,'Framegrabinterval',3); 
vid1 = getselectedsource(vid);
set(vid1,'Brightness',30);

i=0;

start(vid)
trigger(vid)

bck=getdata(vid,1);
s=size(bck);
height=s(1); m=height;
width=s(2);  n=width;
xb=zeros(1,(m*n));
bckgry=rgb2gray(bck);
xb=double(xb);

for i=1:m
    for j=1:n
        xb((i-1)*n+j)=bckgry(i,j);
    end
end

for i1=2:frame
    
fg=getdata(vid,1);
xf=zeros(1,(m*n));
fggry=rgb2gray(fg);

for i=1:m
    for j=1:n
        xf((i-1)*n+j)=fggry(i,j);
    end
end

xf=double(xf);
xt=[xb;xf];

w2=[ 0.2401   -0.3122];
y=w2*xt;
y=uint8(y);


k=m*n;
ifg=zeros(m,n);

q=y(:,:);

for u=1:m
    for v=1:n
        ifg(u,v)=q((u-1)*n+v);
    end
end

%ifg=(uint8(ifg));

ifg = bwmorph(ifg,'dilate',2);
ifg = bwmorph(ifg,'erode',3);
%ifg1 = bwmorph(ifg1,'clean');
[image1 num] = bwlabel(ifg);
        
stats = regionprops(image1, 'BoundingBox');
stat=regionprops(image1);
g = fg;
[M N] = size(stats);

for k = 1:M
for i = floor(stats(k).BoundingBox(1)):floor(stats(k).BoundingBox(1))+stats(k).BoundingBox(3)
for j = floor(stats(k).BoundingBox(2)):floor(stats(k).BoundingBox(2))+stats(k).BoundingBox(4)
 x1 = floor(stats(k).BoundingBox(1));
 y1 = floor(stats(k).BoundingBox(2));

if(i==0||y1==0)
      g(y1+1,i+1) = 255; 
      g(y1+stats(k).BoundingBox(4),i+1) = 255;
else
    g(y1,i)=255;
    g(y1+stats(k).BoundingBox(4),i) = 255;
end
if(j==0||x1==0)
      g(j+1,x1+1) = 255;
      g(j+1,x1+stats(k).BoundingBox(3)) = 255;
else
    g(j,x1) = 255;
    g(j,x1+stats(k).BoundingBox(3)) = 255;
end

end
end
end


figure(1)
subplot(2,1,1),imshow(fg),title('Background with foreground Image')
subplot(2,1,2),imshow(g),title('Threshold : Foreground Image')

end
a=vid.FramesAcquired;

stop(vid)