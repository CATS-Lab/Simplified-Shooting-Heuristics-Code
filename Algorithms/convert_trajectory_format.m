ts_all = cell(1,N);
as_all = cell(1,N);
vs_all = cell(1,N);
ps_all = cell(1,N);
if ~exist('extension')
    extension = 0.05;
end

for i = 1: plat_size
    for n = platoons{i}
        
        ts_all{n}(1)=t_minus(n);
        as_all{n}(1)=0;
        vs_all{n}(1)=v_max;
        ps_all{n}(1)=0;
        
        seg = 2;
        for j = 1:4
            ts_all{n}(seg)=ts_all{n}(seg-1)+delta(n,j);
            as_all{n}(seg)=a_platoon(i,j+1);
            vs_all{n}(seg)=v_seg(n,j+1);
            ps_all{n}(seg)=x_seg(n,j+1);
            seg = seg+1;
        end
        ts_all{n}(seg)=t_plus(n);
        as_all{n}(seg)=0;
        vs_all{n}(seg)=v_max;
        ps_all{n}(seg)=L;
        if extension>0
            ts_all{n}(seg+1)=t_plus(n)+(L/v_max)*extension ;
            as_all{n}(seg+1)=0;
            vs_all{n}(seg+1)=v_max;
            ps_all{n}(seg+1)=L*(1+extension);
        end
    end
end