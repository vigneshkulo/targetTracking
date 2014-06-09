close all
clear all


bck=imread('realbg.jpg');
fg=imread('realfg.jpg');
s=size(bck);
height=s(1); m=height;
width=s(2);  n=width;

%Create Xb and Xf%

xb=zeros(1,(m*n));
xf=zeros(1,(m*n));
bckgry=rgb2gray(bck);
fggry=rgb2gray(fg);

%figure(1)
%subplot(2,2,1),imshow(bck),title('Background Reference Image')
%subplot(2,2,2),imshow(fg),title('Background with foreground Image')
%subplot(2,2,3),imshow(bckgry),title('Background in Gray scale')
%subplot(2,2,4),imshow(fggry),title('BG and FG in Gray Scale')

%Create Xb abd Xf with k =m * n elements%

for i=1:m
    for j=1:n
        xb((i-1)*n+j)=bckgry(i,j);
    end
end


for i=1:m
    for j=1:n
         xf((i-1)*n+j)=fggry(i,j);
    end
end

%Xt matrix with xb and xf%
xb=double(xb);
xf=double(xf);
xt=[xb;xf];
%figure(2)
%subplot(1,2,1),imhist(fggry),title('Histogram of Fore Ground')
%subplot(1,2,2),imhist(bckgry),title('Histogram of Back Ground')
%figure(3)
%plot(xb),axis([0 m*n 0 255]),title('XT')
%figure(4)
%plot(xf),axis([0 m*n 0 255]),title('XF')
k=m*n;

%Pso
iter=100;
par=20;
d1=2;                                %accelerations
d2=2;
rnd1=0.1;                            %random numbers
rnd2=0.2;
fit=zeros(iter,par);
z=zeros(16);
pslmax=zeros(2,2,par);

%A random matrix for w.
for i=1:par
    w=rand(2,2,i);
end
for i=1:par
    w(2,2,i)=-w(2,2,i);
end

for a=1:iter
    for b=1:par
        
           y=w(:,:,b)*xt;
           y=uint8(y);
           h=zeros(1,16);
           g=zeros(1,16);
           r1=0;
           r2=0;
           h1=0;
           g1=0;

           

for l=0:15
    for i=1:k
        if (y(2,i)>=16*l)&&(y(2,i)<=15+16*l)
             h(1,l+1)=h(1,l+1)+1;
         end
         if (y(1,i)>=16*l)&&(y(1,i)<=15+16*l)
             g(1,l+1)=g(1,l+1)+1;
         end
    end
end

for i=1:16
    if(h(1,i)>0)
        r1=cat(2,r1,i);
        h1=cat(2,h1,h(1,i));
    end
end
for i=1:16
    if(g(1,i)>0)
        r2=cat(2,r2,i);
        g1=cat(2,g1,g(1,i));
    end
end
n1=numel(h1);
n2=numel(g1);
h1=h1(1,2:n1);
g1=g1(1,2:n2);
n3=numel(r1);
n4=numel(r2);
r1(n3)=16;
r2(n4)=16;

m=zeros(n1-1,n2-1);
r1=r1.*16;
r2=r2.*16;

for l=1:k
for i=1:n3-1
    for j=1:n4-1
 if ((y(2,l)>=r1(i))&&(y(2,l)<=r1(i+1)-1))&&((y(1,l)>=r2(j))&&(y(1,l)<=r2(j+1)-1))
               m(i,j)=m(i,j)+1;
 end
    end
end
end

mpdf1=h1./k;
mpdf2=g1./k;
jpdf=m./k;

for i=1:n3-1
    for j=1:n4-1
        z(i,j)=abs(jpdf(i,j)-(mpdf1(1,i)*mpdf2(1,j)));
    end
end
fit(a,b)=sum(sum(z));
    end

minima=min(fit(a,:));
pmin=min(fit);

for i=1:par
    if fit(a,i)<=minima;
        globmax=w(:,:,i);
    end
end

for i=1:par
    if min(fit(i))<=pmin(i)
        pslmax(:,:,i)=w(:,:,i);
    end
end

for i=1:par
    w(1,1,i)=w(1,1,i)+d1*rnd1*(globmax(1,1)-w(1,1,i))+d2*rnd2*(pslmax(1,1,i)-w(1,1,i));
    w(1,2,i)=w(1,2,i)+d1*rnd1*(globmax(1,2)-w(1,2,i))+d2*rnd2*(pslmax(1,2,i)-w(1,2,i));         %updating
    w(2,1,i)=w(2,1,i)+d1*rnd1*(globmax(2,1)-w(2,1,i))+d2*rnd2*(pslmax(2,1,i)-w(2,1,i));
    w(2,2,i)=w(2,2,i)+d1*rnd1*(globmax(2,2)-w(2,2,i))+d2*rnd2*(pslmax(2,2,i)-w(2,2,i));
    
end
end