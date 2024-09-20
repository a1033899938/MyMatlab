%%
function y = polariton_UP(Ec0,co_ca,Ex,g,k)%%%%%% Ome is coupling strength, Ex is exciton energy 
Cav=Ec0+k.^2*co_ca;
y = zeros(1,length(k));
im=sqrt(-1);
gaca=2.7/1000;gax=2/1000;
for ki = 1:length(k)
    H=[Cav(ki)-im*gaca g; g Ex-im*gax];
    AA=real(eig(H));
    y(ki)=max(AA);
%     Emp(ki)=median(AA);
%     Eup(ki)=max(AA);
end