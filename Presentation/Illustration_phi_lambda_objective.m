clear;
parameters;
entry_saturation_rate = .5;
exit_saturation_rate = entry_saturation_rate;
shift = 17; %second;
alpha = 0;
beta = 0;
L =540;
generate_boundary;

phis = [1:0.5:20];
lambdas = [0.1:0.05:0.9];
thetas = zeros(length(phis),length(lambdas));
q=2;
for i = 1:length(phis)
    for j = 1: length(lambdas)
        phi = phis(i);
        lambda = lambdas(j);
        
        v_seg = v_max*ones(N,5);
        x_seg = zeros(N,5);
        delta = zeros (N,4);
        a_platoon = zeros(plat_size,5);

        for plat_i = 1:plat_size
            platoon = platoons{plat_i};
            evaluate_platoon;
            a_platoon(plat_i,:)=[0,-phi/(1-lambda),0,phi/lambda,0];
        end

        for plat_i = 1:plat_size
            for n = platoons{plat_i}
                a_minus = -a_platoon(plat_i,2);
                v_seg(n,3) = v_max - a_minus*delta(n,2);
                v_seg(n,4)= v_seg(n,3);
                for seg = 1:4
                    x_seg(n,seg+1) =  x_seg(n,seg)+ v_seg(n,seg)*delta(n,seg)+0.5*a_platoon(plat_i,seg)*delta(n,seg)^2;
                end
            end
        end
        thetas(i,j)= 0;
        for n=1:N
            thetas(i,j)=thetas(i,j)+min(sqrt(2*Delta(n)*phi),v_max)*phi^(q-1)*((1-lambda)^(1-q)+lambda^(1-q));
        end
        
        
        %Plot_Trajectories_Platoon;
        %title(num2str(min(delta(:,1))))
    end
end


thetas_up = thetas;
for i = 1:length(phis)
    for j = 1: length(lambdas)
        if thetas_up(i,j)<0
            thetas_up(i,j)=-inf;
        end
    end
end
figure(1); clf;
mesh(lambdas, phis,thetas );
set(gca,'XTick',[]);
set(gca,'yTick',[]);
set(gca,'zTick',[]);
ylabel('$\phi$')
xlabel('$\lambda$')
zlabel('$\bar{C}$')




