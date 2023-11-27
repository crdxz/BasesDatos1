--- Taller No. 4 SQL - Consultas anidadas 
--- Yeisson Steven Cardozo Herran - 20192020131
--- Juan Murillo Nope - 20192020128
--- 

--- 1. Seleccione el nombre y apellido de todos los empleados que tienen el mismo cargo que 
---Carmen Velásquez

SELECT E.first_name||' '||E.last_name Empleado, E.title
FROM s_emp E 
WHERE E.title = (SELECT E.title  
                    FROM s_emp E
                    WHERE lower(E.first_name) like 'carmen%' AND 
                    lower(E.last_name) like 'vela%');   

---2. Liste el apellido, el cargo y el Id del depto de todos los empleados que trabajan en el 
---mismo depto que Colin

SELECT DISTINCT E.last_name Apelledio, E.title Cargo, E.dept_id idDept
FROM s_emp E
WHERE E.dept_id = (SELECT E.dept_id   
                FROM s_emp E
                WHERE lower(E.first_name) like 'colin%');

---3. Liste los empleados que ganan el máximo salario

SELECT E.first_name||' '||E.last_name Empleado, S.payment
FROM s_emp E, s_salary S
WHERE E.id = S.id AND 
      S.payment = (SELECT max(S.payment) 
                  FROM s_salary S);

---4. Liste los empleados cuyo salario es al menos como el promedio de salario

SELECT DISTINCT E.first_name||' '||E.last_name Empleado 
FROM s_emp E, s_salary S
WHERE E.id = S.id AND 
      S.payment >= (SELECT avg(S.payment) 
                  FROM s_salary S);

---5. Liste los departamentos cuyo promedio de salario es superior al promedio general

SELECT DISTINCT D.name 
FROM s_emp E, s_dept D, s_salary S
WHERE E.dept_id = D.id AND 
    S.payment > (SELECT avg(S.payment) 
                FROM s_salary S );

---6. Liste los empleados que ganan el máximo salario por departamento.

SELECT E.first_name, E.last_name, E.dept_id idDept
FROM s_emp E, s_salary S, 
    (SELECT E.dept_id Depto, max(S.payment) maxSal 
    FROM s_emp E, s_salary S
    WHERE E.id = S.id 
    GROUP BY E.dept_id 
    ) PD    
WHERE E.id = S.id AND  
    E.dept_id = PD.Depto
GROUP BY E.first_name, E.last_name, E.dept_id, PD.maxSal 
HAVING max(S.payment) = PD.maxSal;

---7. Liste el ID, el apellido y el nombre del departamento de todos los empleados que 
---trabajan en un departamento que tengan al menos un empleado de apellido PATEL

SELECT DISTINCT E.id , E.last_name Apellido, D.name Depart 
FROM s_emp E, s_dept D 
WHERE E.dept_id in (SELECT E.dept_id 
            FROM s_emp E 
            WHERE lower(E.last_name) like 'patel%');

---8. Liste el ID, el apellido y la fecha de entrada de todos los empleados cuyos salarios 
---son menores que el promedio general de salario y trabajan en algún departamento 
---que cuente con un empleado de nombre PATEL

SELECT DISTINCT E.id, E.last_name Apellido, E.start_date FechaEntrada 
FROM s_emp E, s_salary S
WHERE E.id = S.id AND 
      S.payment < (SELECT avg(S.payment) 
                   FROM s_salary S)
INTERSECT 
SELECT E.id, E.last_name Apellido, E.start_date FechaEntrada 
FROM s_emp E
WHERE E.dept_id IN (SELECT E.dept_id
                   FROM s_emp E
                   WHERE lower(E.last_name) like 'patel%');

---9. Liste el Id del cliente, el nombre y el record de ventas de todos los clientes que están 
---localizados en North Americam o tienen a Magee como representante de ventas. 
---Trabajar todo el ejercicio con select anidados.

SELECT C.id , C.name nombre, COUNT(O.id) ventas
FROM s_customer C
LEFT JOIN s_ord O ON C.id = O.customer_id
WHERE C.region_id IN (SELECT R.id
                      FROM s_region R 
                      WHERE lower(R.name) like 'north&')
OR C.sales_rep_id IN (SELECT E.id 
                      FROM s_emp E
                      WHERE lower(E.last_name) like 'mage%')
GROUP BY C.id, C.name;

---10. Liste los empleados que ganan en promedio más que el promedio de salario de su 
---departamento (siempre que se hable de departamento se debe tener la región, ya que 
---los departamentos tienen igual nombre, pero son diferentes) 

SELECT E.first_name, E.last_name
FROM s_emp E, s_salary S, 
(
    SELECT E.dept_id Depto, avg(S.payment) avgDepto
    FROM s_emp E, s_salary S
    WHERE E.id = S.id
    GROUP BY E.dept_id
) PD
WHERE E.id = S.id AND
      E.dept_id = PD.Depto 
GROUP BY E.first_name, E.last_name, PD.avgDepto
HAVING avg(S.payment) > PD.avgDepto;

---11. Listar los empleados a cargo de los vicepresidentes

Select E.first_name ||' '|| E.last_name Empleados
from s_emp J, s_emp E
where J.id = E.manager_id AND 
      J.id IN (SELECT J.id 
              FROM s_emp J 
              WHERE lower(J.title) like 'vp%');

---12. Listar los empleados que trabajan en el mismo departamento que Ngao

Select E.first_name ||' '|| E.last_name Empleados
from s_emp E
where E.dept_id = (SELECT E.dept_id
              FROM s_emp E 
              WHERE lower(E.last_name) like 'ngao%');

--13. Liste el promedio de salario de todos los empelados que tienen el mismo cargo que 
---Havel

SELECT E.first_name Nombre, E.last_name Apellido, E.title, AVG(S.payment) AS salario
FROM s_emp E
JOIN s_salary S ON E.id = S.id
WHERE E.title = (SELECT E.title
                 FROM s_emp E
                 WHERE lower(E.last_name) LIKE 'havel%')
GROUP BY E.first_name, E.last_name, E.title;

---14. Cuantos empleados ganan igual que Giljum Henry

SELECT COUNT(E.id) Empleados
FROM s_emp E
WHERE E.salary = (SELECT E.salary
                   FROM s_emp E 
                   WHERE lower(E.first_name) like 'henry%' AND 
                         lower(E.last_name) like 'giljum%');

---15. Liste todos los empleados que no están a cargo de un Administrador de bodega

SELECT E.first_name || ' ' || E.last_name empleado
FROM s_emp E
LEFT JOIN (SELECT id, first_name, last_name, title
          FROM s_emp
          WHERE lower(title) LIKE '%warehouse%manager%') J 
ON E.id = J.id;

---16. Calcule el promedio de salario por departamento de todos los empleados que 
---ingresaron a la compañía en el mimo año que Smith George

SELECT D.name Departamento, E.first_name Nombre, E.last_name Apelledio, AVG(S.payment) Salario 
FROM s_emp E, s_salary S, s_dept D  
WHERE EXTRACT(YEAR FROM E.start_date) = (SELECT EXTRACT(YEAR FROM E.start_date)
                                        FROM s_emp E 
                                        WHERE lower(E.first_name) like 'george%'
                                        AND lower(E.last_name) like 'smith')
AND E.dept_id = D.id
GROUP BY D.name,E.first_name,E.last_name;  

---17. Liste el promedio de ventas de los empleados que están a cargo de los 
---vicepresidentes comerciales.

SELECT E.first_name Nombre, E.last_name Apelledio, AVG(O.id) Ventas 
FROM s_emp E
JOIN s_ord O ON E.id = O.sales_rep_id
WHERE E.manager_id IN (SELECT E.id 
                       FROM s_emp E 
                       WHERE lower(E.title) like 'vp, sales%')
GROUP BY E.first_name,E.last_name;

---18. Liste el salario mensual de cada uno de los empleados teniendo en cuenta la 
---comisión por venta

SELECT TO_CHAR(S.datePayment, 'MM') AS Mes,
       E.first_name AS Nombre,
       E.last_name AS Apellido,
       AVG(S.payment + (O.total * E.commission_pct/100)) AS SalarioMensual
FROM s_emp E
JOIN s_salary S ON E.id = S.id 
JOIN s_ord O ON E.id = O.sales_rep_id
GROUP BY TO_CHAR(S.datePayment, 'MM'), E.first_name, E.last_name;

---19. Liste los empleados que atienden una bodega y que han hecho alguna venta

SELECT E.first_name AS Nombre, E.last_name AS Apellido
FROM s_emp E
JOIN s_warehouse W ON E.id = W.manager_id
WHERE EXISTS (SELECT O.id
              FROM s_ord O, s_emp E
              WHERE O.sales_rep_id = E.id);

---20. Liste el número de orden e ítem de las ordenes con mas de 2 ítem

SELECT O.id Orden, I.item_id 
FROM s_item I,s_ord O 
WHERE I.ord_id  = o.id AND 
    O.id IN (SELECT O.id 
             FROM s_item I, s_ord O 
             WHERE I.ord_id = O.id 
             GROUP BY O.id
             HAVING COUNT(I.item_id) > 2 );

---21. Liste el promedio de salario por nombre de cargo, de los cargos con mas de dos 
---trabajadores

SELECT AVG(S.payment) PromSal, E.title Cargo
FROM s_emp E
JOIN s_salary S ON E.id = S.id
GROUP BY E.title
HAVING COUNT(*) > 2;

---22. Liste los clientes y sus representantes de ventas que tienen más de 2 clientes

SELECT C.name Cliente, E.first_name||' '||E.last_name representante 
FROM s_customer C
JOIN s_emp E ON C.sales_rep_id = E.id 
WHERE C.sales_rep_id IN (SELECT C.sales_rep_id 
                        FROM s_customer C 
                        GROUP BY C.sales_rep_id
                        HAVING COUNT(*) > 2);

---23. Liste el salario promedio de cada representante de ventas (id y nombre), teniendo en 
---cuenta que la comisión se asigna sobre las ventas del mes. 

SELECT E.id ID,
       E.first_name || ' ' || E.last_name  Nombre,
       AVG(S.payment + (O.total * E.commission_pct/100)) SalarioPromedio
FROM s_emp E
JOIN s_salary S ON E.id = S.id
JOIN s_ord O ON E.id = O.sales_rep_id
GROUP BY E.id, E.first_name, E.last_name;

---24. Generar un listado con el promedio devengado (incluidas comisiones) en el 2011 de 
---todos los empleados.

SELECT E.id AS ID,
       E.first_name || ' ' || E.last_name AS Nombre,
       AVG(S.payment + COALESCE(O.total * E.commission_pct/100, 0)) AS PromedioDevengado
FROM s_emp E
JOIN s_salary S ON E.id = S.id
LEFT JOIN s_ord O ON E.id = O.sales_rep_id
WHERE TO_CHAR(S.datePayment, 'YYYY') = '2011'
GROUP BY E.id, E.first_name, E.last_name;

---25. Seleccionar los empleados (nombres) que han ganado en algún mes menos que el 
---promedio del mes.

SELECT E.id AS ID,
       E.first_name || ' ' || E.last_name AS Nombre
FROM s_emp E
JOIN s_salary S ON E.id = S.id
LEFT JOIN s_ord O ON E.id = O.sales_rep_id
WHERE S.payment + COALESCE(O.total * E.commission_pct/100, 0) <
      (
        SELECT AVG(S.payment + COALESCE(O.total * E.commission_pct/100, 0))
        FROM s_emp E2
        JOIN s_salary S2 ON E2.id = S2.id
        LEFT JOIN s_ord O2 ON E2.id = O2.sales_rep_id
        WHERE TO_CHAR(S2.datePayment, 'MM') = TO_CHAR(S.datePayment, 'MM')
      );

---26. Seleccionar los empleados que han ganado menos que el promedio de algún 
---departamento.

SELECT E.id AS ID,
       E.first_name || ' ' || E.last_name AS Nombre,
       E.dept_id AS Departamento,
       S.payment + COALESCE(O.total * E.commission_pct/100, 0) AS Salario,
       (SELECT AVG(S.payment + COALESCE(O.total * E.commission_pct/100, 0))
         FROM s_emp E
         JOIN s_salary S ON E.id = S.id
         LEFT JOIN s_ord O ON E.id = O.sales_rep_id
         WHERE E.dept_id = E.dept_id
       ) AS PromDept
FROM s_emp E
JOIN s_salary S ON E.id = S.id
LEFT JOIN s_ord O ON E.id = O.sales_rep_id;

---27. Seleccionar los productos que han pedido menos que alguna cantidad en stock.

select  P.name Producto,
        sum(I.quantity_shipped) as "# Pedidos"
from    s_product P,
        s_item I
where   I.product_id = P.id
GROUP BY P.name
HAVING sum(I.quantity_shipped) < any (
        SELECT amount_in_stock
        from s_inventory
);

---28. Seleccionar los clientes que han pedido cantidades mayores que el promedio en US 
---de pedido por orden, por mes o por product

SELECT C.name nombre,
    sum(I.quantity_shipped) Cantidad_pedidos
FROM s_customer C,
    s_ord O,
    s_item I
WHERE C.id = O.customer_id
    AND O.id = I.ord_id
GROUP BY BY C.name
HAVING sum(I.quantity_shipped) > (
    -- Por orden
        select avg(P.pedidos) 
        from (
                select sum(I.quantity_shipped) Pedidos
                from s_region R,
                    s_customer C,
                    s_ord O,
                    s_item I
                where R.id = C.region_id
                    and C.id = O.customer_id
                    and O.id = I.ord_id
                    and lower(R.name) like 'north%'
                group by I.ord_id
            ) P
    )
    -- Por mes
    or sum(I.quantity_shipped) > (
        select avg(P.pedidos)
        from (
                select sum(I.quantity_shipped) Pedidos
                from s_region R,
                    s_customer C,
                    s_ord O,
                    s_item I
                where R.id = C.region_id
                    and C.id = O.customer_id
                    and O.id = I.ord_id
                    and lower(R.name) like 'north%'
                group by to_char(O.date_ordered, 'MM')
            ) P
    )
    -- Por producto
    or sum(I.quantity_shipped) > (
        select avg(P.pedidos)
        from (
                select sum(I.quantity_shipped) Pedidos
                from s_region R,
                    s_customer C,
                    s_ord O,
                    s_item I
                where R.id = C.region_id
                    and C.id = O.customer_id
                    and O.id = I.ord_id
                    and lower(R.name) like 'north%'
                group by I.product_id
            ) P
    );