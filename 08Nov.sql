-- Seleccionar los empleados que ganan más que midori

select E.first_name, E.last_name
from s_emp E, s_salary S
where E.id = S.id
group by E.first_name, E.last_name
having AVG(S.payment) > (
    select avg(s.payment)
    from  s_emp E, s_salary S
    where E.id = S.id and
            lower(E.first_name) like 'midori%'
);


-- Empledos que trabajan en la misma region que un señor de 
-- apellido patel


select E.first_name, E.last_name
from s_emp E
where E.region_id in (
            select E.region_id
            from s_emp E
            where lower(E.last_name) like 'patel%'
);

-- Empleados que son compañeros del apellidado patel

select E.first_name, E.last_name
from s_emp E
where (E.region_id, E.dept_id) in (
            select E.region_id, E.dept_id
            from s_emp E
            where lower(E.last_name) like 'patel%'
);

-- Seleccionar los empleados que en promedio ganan mas que el promedio general 

select E.first_name, E.last_name
from s_emp E, s_salary S
where E.id = S.id
group by E.first_name, E.last_name
having avg(S.payment) > (
        select avg(S.payment) ValorPromedio
        from s_salary S 
        );

-- Selccionar los empleados que en promedio ganan mas que 
-- el promedio de su departamento 

select E.first_name, E.last_name
from s_emp E, s_salary S, 
(
    select E.dept_id Depto, avg(S.payment) avgDepto
    from s_emp E, s_salary S
    where E.id = S.id
    group by E.dept_id
) PD
where   E.id = S.id and
        E.dept_id = PD.Depto 
group by E.first_name, E.last_name, PD.avgDepto
having avg(S.payment) > PD.avgDepto;


