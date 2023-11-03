-- Seleccionar nombres de productos que nunca se han vendido 

select      P.name
from        s_product P
left join   s_item I 
on          P.id = I.product_id
where       I.product_id is null; 

-- Operadores
--> SUM : suma
--> MIN : minimo
--> MAX : maximo
--> COUNT : contar
--> AVG : Promedio

select count(*) from s_emp;
select count(commission_pct) from s_emp;


select count(id), max(payment), min(payment), AVG(payment) from s_salary; 


-- Seleccionar el total pagado a cada empleado
--> Cuando se tiene una mezcla entre atributos agrupados y simples
--> Hay que implementar un group by

select  E.first_name, E.last_name, sum(S.payment) Vpagado
from    s_emp E, s_salary S 
where   E.id = S.id
group by E.first_name, E.last_name;

-- Seleccionar por region el valor vendido 

select  R.name Region, sum(O.total) Vtotal
from    s_region R, s_customer C, s_ord O 
where   R.id = C.region_id and
        C.id = O.customer_id
group by R.name;

-- Seleccionar por producto de valor vendido 

select P.name, sum(IT.quantity_shipped*IT.price) Vtotal
from s_product P, s_item IT
where P.id = IT.product_id
group by P.name;

-- Selccionar por region y producto el valor vendido 

select  R.name region, P.name Producto, 
        sum(IT.quantity_shipped*IT.price) Vtotal 
from    s_region R,
        s_warehouse W,
        s_inventory I,
        s_product P,
        s_item IT
where   R.id = W.region_id and
        W.id = I.warehouse_id and
        P.id = I.product_id and
        P.id = IT.product_id
group by R.name, P.name; 

-- Seleccionar las regiones que han vendido mas de 20.000 (us)

select  R.name Region, sum(O.total) Vtotal
from    s_region R, s_customer C, s_ord O 
where   R.id = C.region_id and
        C.id = O.customer_id
group by R.name
having sum(O.total) > 20000;


-- Productos que se han vendido más de 15 unidades

select P.name Producto 
from s_product P, s_item IT 
where P.id = IT.product_id
group by P.name 
having sum(IT.quantity_shipped) > 500;


-- TALLER 4, COSULTAS ANIDADAS 


-- Seleccionar empleados que ganan el maximo salario 

select  max(S.payment) maxSal;
from s_salary S;

select E.first_name, E.last_name
from s_emp E, s_salary S
where   E.id = S.id and   
        S.payment = (
                    select  max(S.payment) maxSal                   
                    from s_salary S             
                    );



-- Seleccionar region donde trabaja la doris 
select R.id
from s_region R, s_dept D, s_emp E
where   R.id = D.region_id and
        D.id = E.dept_id and D.region_id = E.region_id and
        lower(E.first_name) like 'ladoris%';


-- Seleccionar los empleados que trabajan en las misma region que laDoris

select E.first_name||' '||E.last_name nombre
from s_emp E
where E.region_id = (
        select R.id
        from s_region R, s_dept D, s_emp E
        where   R.id = D.region_id and
        D.id = E.dept_id and D.region_id = E.region_id and
        lower(E.first_name) like 'ladoris%'
);



-- Lo que gana en promedio midori
select  E.first_name, E.last_name, AVG(S.payment) Vpagado
from    s_emp E, s_salary S 
where   E.id = S.id and
        lower(E.first_name) like 'midori%'
group by E.first_name, E.last_name;


-- Empledaos que ganen en promedio mas que Midori
select  E.first_name, E.last_name, AVG(S.payment) Vpagado
from    s_emp E, s_salary S 
where   E.id = S.id
group by E.first_name, E.last_name
having  AVG(S.payment) > (
    select  AVG(S.payment) Vpagado
    from    s_emp E, s_salary S 
    where   E.id = S.id and
            lower(E.first_name) like 'midori%'
    group by E.first_name, E.last_name
);
