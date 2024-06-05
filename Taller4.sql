--1. Seleccione el nombre y apellido de todos los empleados que tienen el mismo cargo 
--que Carmen Velásquez
SELECT E.FIRST_NAME || ' ' || E.LAST_NAME NOMBRE
FROM S_EMP E
WHERE E.TITLE =
    (
        SELECT E.TITLE
        FROM S_EMP E
        WHERE UPPER(E.FIRST_NAME) = 'CARMEN' AND 
        UPPER(E.LAST_NAME) = 'VELASQUEZ'
    );
    
--2. Liste el apellido, el cargo y el Id del depto de todos los empleados que trabajan en el 
--mismo depto que Colin
SELECT DISTINCT E.LAST_NAME APELLIDO, E.TITLE CARGO, D.ID DEPARTAMENTO
FROM S_EMP E, S_DEPT D
WHERE E.DEPT_ID = D.ID AND
    E.DEPT_ID =
    (
        SELECT E.DEPT_ID
        FROM S_EMP E
        WHERE UPPER(E.FIRST_NAME) = 'COLIN'
    );

-- 3. Liste los empleados que ganan el máximo salario 
SELECT E.FIRST_NAME EMPLEADO 
FROM S_EMP E, S_SALARY S 
WHERE S.ID = E.ID AND 
      S.PAYMENT = (SELECT MAX(S.PAYMENT) FROM S_SALARY S);

--4. Liste los empleados cuyo salario es al menos como el promedio de salario
SELECT DISTINCT E.FIRST_NAME EMPLEADO 
FROM S_EMP E, S_SALARY S 
WHERE S.ID = E.ID AND 
      S.PAYMENT >= (SELECT AVG(S.PAYMENT) FROM S_SALARY S);
    
-- 5. Liste los departamentos cuyo promedio de salario es superior al promedio general
SELECT D.NAME DEPT , AVG(S.PAYMENT) PROMEDIO
FROM S_DEPT D, S_SALARY S, S_EMP E
WHERE E.ID = S.ID AND 
      E.DEPT_ID = D.ID 
GROUP BY D.NAME 
HAVING AVG(S.PAYMENT) > (SELECT AVG(S.PAYMENT)
                         FROM S_SALARY S);

-- 6. Liste los empleados que ganan el máximo salario por departamento.
SELECT EMP.NOMBRE, MAXDP.DEPARTAMENTO, MAXDP.MAX 
FROM ( SELECT DISTINCT E.FIRST_NAME NOMBRE, D.ID IDDP, S.PAYMENT SALARIO 
       FROM S_EMP E, S_DEPT D, S_SALARY S
       WHERE E.DEPT_ID = D.ID AND 
             E.ID = S.ID) EMP, 
     ( SELECT D.ID ID, D.NAME DEPARTAMENTO, MAX(S.PAYMENT) MAX
       FROM S_DEPT D, S_EMP E, S_SALARY S
       WHERE D.ID = E.DEPT_ID AND 
             E.ID = S.ID 
       GROUP BY D.ID, D.NAME) MAXDP 
WHERE EMP.IDDP = MAXDP.ID AND 
      EMP.SALARIO = MAXDP.MAX;

-- 7. Liste el ID, el apellido y el nombre del departamento de todos los empleados que 
-- trabajan en un departamento que tengan al menos un empleado de apellido PATEL
SELECT DISTINCT E.ID , E.LAST_NAME EMPLEADO , D.NAME DEPT 
FROM S_EMP E, S_DEPT D 
WHERE E.DEPT_ID = D.ID AND
      D.ID IN (SELECT D.ID
                FROM S_EMP E, S_DEPT D 
                WHERE E.DEPT_ID = D.ID AND
                      UPPER(E.LAST_NAME) LIKE 'PATEL%');

-- 8. Liste el ID, el apellido y la fecha de entrada de todos los empleados cuyos salarios 
-- son menores que el promedio general de salario y trabajan en algún departamento 
-- que cuente con un empleado de apellido PATEL
SELECT E.ID, E.LAST_NAME APELLIDO, E.START_DATE ENTRADA 
FROM S_EMP E, S_SALARY S 
WHERE E.ID = S.ID AND
      S.PAYMENT < (SELECT AVG(S.PAYMENT) FROM S_SALARY S) 
INTERSECT 
SELECT E.ID, E.LAST_NAME APELLIDO, E.START_DATE ENTRADA 
FROM S_EMP E,S_DEPT D
WHERE E.DEPT_ID = D.ID AND
      D.ID IN (SELECT D.ID
                FROM S_EMP E, S_DEPT D 
                WHERE E.DEPT_ID = D.ID AND
                      UPPER(E.LAST_NAME) LIKE 'PATEL%');

-- 9. Liste el Id del cliente, el nombre y el record de ventas de todos los clientes que están 
-- localizados en North Americam o tienen a Magee como representante de ventas. 
-- Trabajar todo el ejercicio con select anidados.
SELECT C.ID , C.NAME NOMBRE, MAX(O.TOTAL) RECORD 
FROM S_CUSTOMER C
INNER JOIN S_ORD O ON C.ID = O.CUSTOMER_ID 
WHERE C.REGION_ID IN (SELECT R.id
                      FROM s_region R 
                      WHERE lower(R.name) like 'north&')
OR C.SALES_REP_ID IN (SELECT E.id 
                      FROM s_emp E
                      WHERE lower(E.last_name) like 'mage%')
GROUP BY C.ID, C.NAME;

-- 10. Liste los empleados que ganan en promedio más que el promedio de salario de su 
-- departamento (siempre que se hable de departamento se debe tener la región, ya que 
-- los departamentos tienen igual nombre, pero son diferentes) 
SELECT E.ID ID_EMP, E.REGION_ID, E.DEPT_ID, AVG_DEPT.AVG AVG_DEPT, AVG(S.PAYMENT) AVG_EMP
FROM S_EMP E
INNER JOIN (
  SELECT D.ID AS DEPT_ID, D.REGION_ID AS REGION_ID, AVG(S1.PAYMENT) AVG
  FROM S_DEPT D
  INNER JOIN S_EMP E ON (D.ID = E.DEPT_ID AND E.REGION_ID = D.REGION_ID)
  INNER JOIN S_SALARY S1 ON E.ID = S1.ID
  GROUP BY (D.ID, D.REGION_ID)
) AVG_DEPT ON (E.DEPT_ID = AVG_DEPT.DEPT_ID AND E.REGION_ID = AVG_DEPT.REGION_ID)
INNER JOIN S_SALARY S ON E.ID = S.ID
GROUP BY (E.ID, E.REGION_ID, E.DEPT_ID, AVG_DEPT.AVG)
HAVING AVG(S.PAYMENT)>AVG_DEPT.AVG;

-- 11. Listar los empleados a cargo de los vicepresidentes

SELECT E.FIRST_NAME EMPLEADO 
FROM S_EMP E, S_EMP J 
WHERE E.MANAGER_ID = J.ID AND 
      J.ID IN (SELECT J.ID 
                FROM S_EMP J 
                WHERE UPPER(J.TITLE) LIKE ('VP%'));

-- 12. Listar los empleados que trabajan en el mismo departamento que Ngao
SELECT DISTINCT E.ID , E.LAST_NAME EMPLEADO , D.NAME DEPT 
FROM S_EMP E, S_DEPT D 
WHERE E.DEPT_ID = D.ID AND
      D.ID IN (SELECT D.ID
                FROM S_EMP E, S_DEPT D 
                WHERE E.DEPT_ID = D.ID AND
                      UPPER(E.LAST_NAME) LIKE 'NGAO%');

-- 13. Liste el promedio de salario de todos los empelados que tienen el mismo cargo que 
-- Havel
SELECT AVG(S.PAYMENT) AVGSAL , E.FIRST_NAME EMPLEADO
FROM S_EMP E, S_SALARY S 
WHERE E.ID = S.ID AND 
      E.TITLE = (SELECT E.TITLE 
                FROM S_EMP E 
                WHERE UPPER(E.LAST_NAME) LIKE 'HAVEL%')
GROUP BY E.FIRST_NAME; 

-- 14. Cuantos empleados ganan igual que Giljum Henry
SELECT COUNT(E.ID)
FROM S_EMP E, S_SALARY S 
WHERE E.ID = S.ID 
GROUP BY E.ID 
HAVING SUM(S.PAYMENT) = (SELECT SUM(S.PAYMENT)
                        FROM S_EMP E, S_SALARY S 
                        WHERE E.ID = S.ID AND 
                            UPPER(E.FIRST_NAME) LIKE 'HENRY%' AND 
                            UPPER(E.LAST_NAME) LIKE 'GILJUM' ); 

--15. Liste todos los empleados que no están a cargo de un Administrador de bodega 
SELECT E.FIRST_NAME ||' '||E.LAST_NAME EMPLEADOS 
FROM S_EMP E 
INNER JOIN S_EMP J ON E.ID = J.ID AND 
                   E.MANAGER_ID NOT IN (SELECT E.MANAGER_ID 
                   FROM S_EMP E
                   WHERE UPPER(E.TITLE) LIKE '%WAREHOUSE MANAGER%');

SELECT E.FIRST_NAME ||' '||E.LAST_NAME EMPLEADOS 
FROM S_EMP E 
WHERE E.MANAGER_ID NOT IN (SELECT E.MANAGER_ID 
                            FROM S_EMP E
                            WHERE UPPER(E.TITLE) LIKE '%WAREHOUSE MANAGER%');

-- 16. Calcule el promedio de salario por departamento de todos los empleados que 
-- ingresaron a la compañía en el mimo año que Smith George
SELECT E.ID, E.LAST_NAME APELLIDO, E.START_DATE ENTRADA , AVG(S.PAYMENT)
FROM S_EMP E, S_SALARY S 
WHERE E.ID = S.ID AND
      EXTRACT(YEAR FROM E.START_DATE) = (SELECT EXTRACT(YEAR FROM E.START_DATE)
                                        FROM S_EMP E 
                                        WHERE UPPER(E.FIRST_NAME) LIKE 'GEORGE%' AND 
                                              UPPER(E.LAST_NAME) LIKE 'SMITH%')       
GROUP BY E.ID, E.LAST_NAME, E.START_DATE;

-- 17. Liste el promedio de ventas de los empleados que están a cargo de los 
-- vicepresidentes comerciales.
SELECT E.first_name Nombre, E.last_name Apelledio, AVG(O.id) Ventas 
FROM s_emp E, s_ord O 
WHERE E.id = O.sales_rep_id AND 
      E.manager_id IN (SELECT E.id 
                       FROM s_emp E 
                       WHERE lower(E.title) like 'vp, sales%')
GROUP BY E.first_name,E.last_name;

-- 18. Liste el salario mensual de cada uno de los empleados teniendo en cuenta la 
-- comisión por venta
SELECT EXTRACT(YEAR FROM S.DATEPAYMENT) YEAR, EXTRACT(MONTH FROM S.DATEPAYMENT) MONTH, SUM(S.PAYMENT + (O.TOTAL * NVL(E.COMMISSION_PCT, 0))) PAYMENT_COMMISSION
FROM S_EMP E 
INNER JOIN S_SALARY S ON E.ID = S.ID
INNER JOIN S_ORD O ON O.SALES_REP_ID = E.ID
GROUP BY EXTRACT(YEAR FROM S.DATEPAYMENT), EXTRACT(MONTH FROM S.DATEPAYMENT);

-- 19. Liste los empleados que atienden una bodega y que han hecho alguna venta
SELECT E.FIRST_NAME EMPLEADO 
FROM S_EMP E, S_WAREHOUSE W
WHERE E.ID = W.MANAGER_ID AND
      E.ID IN (SELECT E.ID 
              FROM S_EMP E, S_ORD O 
              WHERE E.ID = O.SALES_REP_ID );

-- 20. Liste el número de orden e ítem de las ordenes con mas de 2 ítem
SELECT O.ID, I.ITEM_ID 
FROM S_ORD O, S_ITEM I
WHERE O.ID = I.ORD_ID AND 
      O.ID IN ( SELECT I.ORD_ID 
                FROM S_ITEM I
                GROUP BY (I.ORD_ID)
                HAVING COUNT (I.ORD_ID) > 2);

-- 21. Liste el promedio de salario por nombre de cargo, de los cargos con mas de dos 
-- trabajadores

SELECT E.TITLE CARGO, AVG(S.PAYMENT) PSALARIO 
FROM S_EMP E, S_SALARY S 
WHERE E.ID = S.ID AND 
      E.TITLE IN (SELECT E.TITLE 
                    FROM S_EMP E 
                    GROUP BY (E.TITLE) 
                    HAVING COUNT(E.TITLE) > 2)
GROUP BY E.TITLE; 

-- 22. Liste los clientes y sus representantes de ventas que tienen más de 2 clientes 
SELECT C.NAME CLIENTE, E.FIRST_NAME EMPLEADO 
FROM S_CUSTOMER C, S_EMP E 
WHERE E.ID = C.SALES_REP_ID AND 
      C.SALES_REP_ID IN (SELECT C.SALES_REP_ID
                FROM S_CUSTOMER C 
                GROUP BY C.SALES_REP_ID 
                HAVING COUNT(C.SALES_REP_ID) > 2); 
    
-- 23. Liste el salario promedio de cada representante de ventas (id y nombre), teniendo en 
-- cuenta que la comisión se asigna sobre las ventas del mes. 
SELECT E.ID, E.FIRST_NAME || ' ' || E.LAST_NAME EMPLEADO, 
AVG(S.PAYMENT + NVL(E.COMMISSION_PCT, 0)/100 * NVL(V.TOTAL, 0)) AVG 
FROM S_EMP E, S_SALARY S, S_ORD O, 
(
  SELECT EXTRACT(MONTH FROM O.DATE_ORDERED) MONTH, E.ID, SUM(O.TOTAL) TOTAL
  FROM S_EMP E, S_ORD O
  WHERE E.ID = O.SALES_REP_ID
  GROUP BY EXTRACT(MONTH FROM O.DATE_ORDERED), E.ID
) V
WHERE S.ID = E.ID AND
    V.MONTH = EXTRACT(MONTH FROM S.DATEPAYMENT) AND 
    V.ID = E.ID AND
    E.ID = O.SALES_REP_ID
GROUP BY E.ID, E.FIRST_NAME,E.LAST_NAME;

-- 24. Generar un listado con el promedio devengado (incluidas comisiones) en el 2011 de 
-- todos los empleados.
SELECT E.FIRST_NAME EMP, AVG(S.PAYMENT + COALESCE(O.TOTAL * (E.COMMISSION_PCT/100), 0)) PROM 
FROM S_EMP E, S_SALARY S, S_ORD O 
WHERE E.ID = S.ID AND 
      EXTRACT(YEAR FROM S.DATEPAYMENT) = '2011'
GROUP BY E.FIRST_NAME; 

-- 25. Seleccionar los empleados (nombres) que han ganado en algún mes menos que el 
-- promedio del mes.
SELECT E.FIRST_NAME EMP
FROM S_EMP E , S_SALARY S 
WHERE E.ID = S.ID 
GROUP BY E.FIRST_NAME
HAVING AVG(S.PAYMENT) < ANY (SELECT AVG(S.PAYMENT)
                        FROM S_SALARY S 
                        GROUP BY EXTRACT(MONTH FROM S.DATEPAYMENT));

-- 26. Seleccionar los empleados que han ganado menos que el promedio de algún 
-- departamento.
SELECT E.FIRST_NAME EMP
FROM S_EMP E , S_SALARY S 
WHERE E.ID = S.ID 
GROUP BY E.FIRST_NAME
HAVING AVG(S.PAYMENT) < ANY (SELECT AVG(S.PAYMENT) 
                        FROM S_SALARY S , S_DEPT D , S_EMP E 
                        WHERE S.ID = E.ID AND 
                              E.DEPT_ID = D.ID  
                        GROUP BY D.ID);

-- 27. Seleccionar los productos que han pedido menos que alguna cantidad en stock
SELECT P.NAME 
FROM S_PRODUCT P, S_ITEM I
WHERE I.PRODUCT_ID = P.ID 
GROUP BY P.NAME 
HAVING SUM(I.QUANTITY) < ANY (SELECT DISTINCT I.AMOUNT_IN_STOCK 
                              FROM S_INVENTORY I);

-- 28. Seleccionar los clientes que han pedido cantidades mayores que el promedio en US 
-- de pedido por orden, por mes o por producto. 
SELECT C.NAME 
FROM S_CUSTOMER C, S_ORD O, S_ITEM I 
WHERE O.CUSTOMER_ID = C.ID AND
      I.ORD_ID = O.ID
GROUP BY C.NAME 
HAVING SUM(I.QUANTITY) > ANY ( SELECT AVG(I.QUANTITY) QUANTITY 
                                               FROM S_CUSTOMER C, S_ORD O, S_ITEM I , S_REGION R 
                                               WHERE O.CUSTOMER_ID = C.ID AND
                                                     I.ORD_ID = O.ID AND 
                                                     R.ID = C.REGION_ID AND 
                                                     UPPER(R.NAME) = 'NORTH AMERICA%'
                                               GROUP BY O.ID
                                               UNION
                                               SELECT AVG(I.QUANTITY) QUANTITY 
                                               FROM S_CUSTOMER C, S_ORD O, S_ITEM I, S_REGION R
                                               WHERE O.CUSTOMER_ID = C.ID AND
                                                     I.ORD_ID = O.ID AND 
                                                     R.ID = C.REGION_ID AND 
                                                     UPPER(R.NAME) = 'NORTH AMERICA'
                                               GROUP BY EXTRACT(MONTH FROM O.DATE_ORDERED)
                                               UNION
                                               SELECT AVG(I.QUANTITY) QUANTITY 
                                               FROM S_CUSTOMER C, S_ORD O, S_ITEM I, S_REGION R, S_PRODUCT P 
                                               WHERE O.CUSTOMER_ID = C.ID AND
                                                     I.ORD_ID = O.ID AND 
                                                     P.ID = I.PRODUCT_ID AND 
                                                     R.ID = C.REGION_ID AND 
                                                     UPPER(R.NAME) = 'NORTH AMERICA'
                                               GROUP BY P.ID);



