function [n_model]=Lorenz(lambda,Ex,Lw,B,f)
lambda=lambda*1000;
E=1240./lambda;
n_model=sqrt(B+f./(Ex^2-E.^2-sqrt(-1)*Lw*E));
end

