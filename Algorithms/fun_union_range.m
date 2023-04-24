function r=fun_union_range(r1,r2)
    r_org =[r1;r2];
    if length(r_org)
        r_org = sortrows(r_org,1);
        r = r_org(1,:);
        for i = 2:size(r_org,1)
            if r_org(i,1)<=r(end,2)
                r(end,2)= max(r_org(i,2),r(end,2));
            else
                r=[r;r_org(i,:)];
            end
        end
    else
        r =[];
    end
end