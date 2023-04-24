function r=fun_intersect_range(r1,r2)
    r_org = [];
    for i = 1:size(r1,1)
        for j = 1:size(r2,1)
            if r1(i,1)<=r2(j,2)&& r1(i,2)>=r2(j,1)
                r_org = [r_org;max(r1(i,1),r2(j,1)),min(r1(i,2),r2(j,2))];
            end
        end
    end
    if length(r_org)
        r_org = sortrows(r_org,1);
        r = r_org(1,:);
        for i = 2:size(r_org,1)
            if r_org(i,1)==r(end,2)
                r(end,2)= r_org(i,2);
            else
                r=[r;r_org(i,:)];
            end
        end
    else
        r =[];
    end
    
end