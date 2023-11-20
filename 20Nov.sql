

-- Seleccionar Mas empleados que en promedio ganan más que el promedio de alguno de los departamentos 

select E.first_name||' '||E.last_name Empleado
from s_emp E, s_salary S
where E.id = S.id
group by E.first_name ||' '||E.last_name
having avg(S.payment) > any (
    select  avg(S.payment)
    from    s_emp E, s_salary S
    where   E.id = S.id
    group by E.dept_id
);
--> any : Alguno de los valores de una lista 


-- Los que ganan más que todos los promedios 
--> all : Todos los valores

select E.first_name||' '||E.last_name Empleado
from s_emp E, s_salary S
where E.id = S.id
group by E.first_name ||' '||E.last_name
having avg(S.payment) > all(
    select  avg(S.payment)
    from    s_emp E, s_salary S
    where   E.id = S.id
    group by E.dept_id
);


-- Seleccionar los empleados que han tenido ventas junto con el total pagado por salario 

select  E.first_name||' '||E.last_name Empleado, sum(S.payment) Total
from    s_emp E, s_salary S
where   E.id = S.id and
exists  (
    select O.id
    from s_ord O
    where E.id = O.sales_rep_id
)
group by E.first_name||' '||E.last_name;

-- Seleccionar los empleados que NO han tenido ventas junto con el total pagado por salario 

select  E.first_name||' '||E.last_name Empleado, sum(S.payment) Total
from    s_emp E, s_salary S
where   E.id = S.id and
not exists (
    select O.id
    from s_ord O
    where E.id = O.sales_rep_id
)
group by E.first_name||' '||E.last_name;