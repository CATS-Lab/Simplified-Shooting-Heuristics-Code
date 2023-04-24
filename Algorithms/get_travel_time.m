function dt = get_travel_time(l,v,v_max,a)
l_temp = (v_max^2-v^2)/(2*a);
if l_temp>l
    dt = (-v+sqrt(v^2+2*a*v))/a;
else
    dt1 = (v_max-v)/a;
    dt2 = (l - l_temp)/v_max ;
    dt = dt1+dt2;
end