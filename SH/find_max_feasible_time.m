function [t_next_extreme,t_tangent,t_next_inter]  = find_max_feasible_time(p_n,v_n,t_n,a_n,p_s,v_s,ts_window,a_s,a_c_d,direction)
    if nargin<10
        direction =1;
    end
    global err_tol
    t_shadow = ts_window(1);
    t_s = t_shadow -t_n; %relative time of tshadow 
    
    dis = find_quad_dist(p_n,v_n,t_n,a_c_d,p_s,v_s,ts_window,a_s);
    if dis < -err_tol
        t_next_extreme = direction*-inf;
        t_tangent = direction*-inf;
        t_next_inter =direction*-inf;
    else
        %checking the initial spacing at t_now
        pd = p_s - p_n - t_s*v_s + 0.5*a_s*t_s^2;    
        vd = v_s-v_n-a_s*t_s;
        asd = a_s-a_c_d;
        asn = a_s -a_n;
        A = 0.5*asd;
        if abs(A)< err_tol
%             if abs(asn)<err_tol
%                 t_next_extreme = inf;
%                 t_tangent = inf;       
%             else
%                 td = -vd/asn;
%                 if abs(td)< err_tol
%                     td =0;
%                 end
%                 t_next_extreme = t_n + td;
%                 if pd -0.5*asn*td^2< err_tol
%                     t_tangent = t_next_extreme;
%                 else
%                      t_tangent = inf;
%                 end
%             end
            t_next_extreme = direction*inf;
            t_tangent = direction*inf;
        else
            A1 =  asn*(asn-asd);
            B1 = 2*vd*(asn-asd);
            C1 =  vd^2 - 2*asd*pd;

            if abs(A1) < err_tol
                if abs(B1) < err_tol 
                     t_next_extreme = direction*inf;
                     t_tangent = direction*inf;
                else
                    td = -C1/B1;
                    if abs(td)< err_tol
                        td =0;
                    end
                    B = vd + asn*td;
                    td_tangent = td + (-B)/(2*A);
                    t_next_extreme = t_n + td;
                    t_tangent = t_n + td_tangent;
                end
            else
                D = B1^2 - 4*A1*C1;
                if D >= -err_tol 
                    if abs(D)< err_tol
                        D =0;
                    end
                     td = (-B1-sqrt(D))/(2*A1);
                     tdd =  -(vd + asn*td)/(2*A);
                     if tdd*direction <=-err_tol
                        td = (-B1+sqrt(D))/(2*A1);
                    	tdd =  -(vd + asn*td)/(2*A);
                     end
                     td_tangent = td +tdd;
%                    td1 = (-B1-sqrt(D))/(2*A1);
%                     td2 = (-B1+sqrt(D))/(2*A1);
%                     B = vd + asn*td1;
%                     td_tangent1 = td1 + (-B)/(2*A);
%                     B = vd + asn*td2;
%                     td_tangent2 = td2 + (-B)/(2*A);
%                     category = 0;
%                     if td_tangent1>= ts_window(1)-t_n && td_tangent1<= ts_window(2)-t_n
%                         category = 1;
%                     end
%                     if td_tangent2>= ts_window(1)-t_n && td_tangent2<= ts_window(2)-t_n
%                         category = category+2;
%                     end
%                     if category ==0 || category ==3
%                         if direction >=0
%                             if td1>-err_tol && td2>-err_tol
%                                 td = min(td1,td2);
%                             else
%                                 td = max(td1,td2);
%                             end
%                         else
%                             if td1<err_tol && td2<err_tol
%                                 td = max(td1,td2);
%                             else
%                                 td = min(td1,td2);
%                             end
%                             
%                         end
%                     elseif category ==1
%                         td = td1;
%                     else
%                         td = td2;
%                     end
%                     if abs(td)< err_tol
%                         td =0;
%                     end
%                     B = vd + asn*td;
%                     td_tangent = td + (-B)/(2*A);
                   
                else
                    td = direction*inf;
                    td_tangent = direction*inf;
                end
                t_next_extreme = t_n + td;
                t_tangent = t_n + td_tangent;
            end
        end
        if nargout==3 %calc t_next_inter 
            if t_tangent >=ts_window(1) && t_tangent <= ts_window(2)
                t_next_inter = t_next_extreme;
            else
                t_i= ts_window(2) - t_n;
                A2 = 0.5*(asd-asn);
                B2 = (asn - asd)*t_i ;
                C2 = 0.5*asd*t_i^2 + vd*t_i + pd;
                if abs(A2) < err_tol
                    if abs(B2)<err_tol
                        td_inter  = direction*inf;
                    else
                        td_inter = -C2/B2;
                    end
                else
                    D = B2^2-4*A2*C2;
                    if D >=0
                        t3 = (-B2-sqrt(B2^2-4*A2*C2))/(2*A2);
                        t4 = (-B2+sqrt(B2^2-4*A2*C2))/(2*A2);
                        if direction >=0
                            if t3>-err_tol && t4>-err_tol
                                td_inter = min(t3,t4);
                            else
                                td_inter = max(t3,t4);
                            end
                        else
                            if t3<err_tol && t4<err_tol
                                td_inter = max(t3,t4);
                            else
                                td_inter = min(t3,t4);
                            end
                        end
                    else
                        td_inter = direction*inf;
                    end
                end
                if abs(td_inter)< err_tol
                    td_inter =0;
                end
                t_next_inter  = t_n + td_inter;
            end
        end
    end % if dis<-err_tol
    
end