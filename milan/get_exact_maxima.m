function co=...
    get_exact_maxima(plane, co,abst)

ncy=co(:,1); ncx=co(:,2);

%ncy=cyr; ncx=cxr;
[sy,sx]=size(plane);
[yco,xco]=ndgrid(1:sy,1:sx);

cxr=round(ncx);cyr=round(ncy);

pcolor(plane); shading interp;hold on;
colormap gray
plot(ncx,ncy,'b+'); 
hold off

badind=[];

for k=1:length(cyr)
    k
    littlePlane=plane(cyr(k)-abst:cyr(k)+abst, ...
        cxr(k)-abst:cxr(k)+abst);
    littleY=yco(cyr(k)-abst:cyr(k)+abst, ...
        cxr(k)-abst:cxr(k)+abst);
    littleX=xco(cyr(k)-abst:cyr(k)+abst, ...
        cxr(k)-abst:cxr(k)+abst);

    x0=[0,0.6,cyr(k),cxr(k),abst/2];
    x=fit2d_gauss(x0,littleY,littleX,littlePlane);
    ncy(k)=x(3);%+cyr(k)-(abst+1); 
    ncx(k)=x(4);%+cxr(k)-(abst+1);
    if x(4)>cxr(k)+abst || x(4)<cxr(k)-abst || ...
            x(3)>cyr(k)+abst || x(3)<cyr(k)-abst
        badind=[badind; k];
    end
    
            
end


ncx(badind)=[];
ncy(badind)=[];
['badind: ' num2str(length(badind)) ]

co=[ncy,ncx,ncx*0];

  
  

    
    