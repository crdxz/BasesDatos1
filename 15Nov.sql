

-- Seleccionar los representantes de ventas que 
-- vendieron más que el promedio de su region 

select E.first_name||' '||E.last_name representantes, PR.avgRegion AVGRegion
from s_emp E, s_ord O,
(
    select E.region_id Region, avg(O.total) avgRegion 
    from s_emp E, s_ord O
    where E.id = O.sales_rep_id
    group by E.region_id
) PR
where   E.id = O.sales_rep_id and 
        E.region_id = PR.Region
group by E.first_name||' '||E.last_name,  PR.avgRegion
having sum(O.total) > PR.avgRegion;

-- Listar los rep de ventas con el salario total 

select  E.first_name||' '||E.last_name "representantes", 
        (sum(S.payment) + min(nvl(O.total*E.commission_pct/100,0))) as "valor pagado"
from    s_emp E, s_salary S, s_ord O
where   E.id = S.id and
        E.id = O.sales_rep_id
group by E.first_name||' '||E.last_name;

-- Cuanto le han pagado a cada rep mes a mes
-- Salario de los representantes en los meses que hicieron ventas

select  E.first_name||' '||E.last_name "representantes",
        salario.periodo,
        venta.TotalV + Salario.totalP "Pago total" 
from s_emp E,
(
    select  E.id Repre,
            To_char(O.date_shipped, 'YYYY/MM') periodo,
            sum(nvl(O.total*E.commission_pct/100,0)) TotalV
    from    s_emp E, s_ord O
    where   E.id = O.sales_rep_id
    group by E.id , 
            To_char(O.date_shipped, 'YYYY/MM')
) venta,
(
    select  E.id Repre,
            To_char(S.datepayment, 'YYYY/MM') periodo,
            sum (S.payment) TotalP
    from    s_emp E, s_salary S
    where   E.id = S.id
    group by E.id , 
            To_char(S.datepayment, 'YYYY/MM')
) Salario
where   E.id = venta.Repre and  
        E.id = salario.Repre and 
        venta.periodo = salario.periodo;

-- Salario de los representantes en los meses que no hicieron ventas 


-- Salario de los empleados que no son representantes de ventas 


