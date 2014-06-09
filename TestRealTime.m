close all
clear all

vid = videoinput('winvideo',1,'YUY2_320x240');    %Create Video Object
set(vid,'ReturnedColorSpace','RGB');              %Convert To RGB
triggerconfig(vid, 'manual');                     %Trigger Type Manual
frame=500;
set(vid,'FramesPerTrigger',frame); 
set(vid,'Framegrabinterval',2); 
vid1 = getselectedsource(vid);
%set(vid1,'Brightness',60);

i=0;

start(vid)
trigger(vid)

bck=getdata(vid,1);
s=size(bck);
height=s(1); m=height;
width=s(2);  n=width;

for i1=2:frame
    
fg=getdata(vid,1);
xb=zeros(1,(m*n));
xf=zeros(1,(m*n));
bckgry=rgb2gray(bck);
fggry=rgb2gray(fg);

for i=1:m
    for j=1:n
        xb((i-1)*n+j)=bckgry(i,j);
        xf((i-1)*n+j)=fggry(i,j);
    end
end

xb=double(xb);
xf=double(xf);
xt=[xb;xf];

w2=[  0.2401   -0.3122];
y=w2*xt;
y=uint8(y);

k=m*n;
ifg=zeros(m,n);
ifg1=zeros(m,n);

q=y(:,:);

for u=1:m
    for v=1:n
        ifg(u,v)=q((u-1)*n+v);
    end
end

ifg=(uint8(ifg));
q=double(q);
k1=mean(q)+1.5*(sqrt(var(q)));
for u=1:m
    for v=1:n
        if ifg(u,v)< k1
            ifg1(u,v)=255;
        end
    end
end
figure(1)
subplot(2,1,1),imshow(fg),title('Background with foreground Image')
subplot(2,1,2),imshow(ifg1),title('Threshold : Foreground Image')
end

a=vid.FramesAcquired;

stop(vid)