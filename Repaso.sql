--- Repaso Parcial SQL AVANZADO ---

--- UNION : Une dos conjuntos 
--- INTERSECT : Toma la interseccion entre dos conjuntos 
--- MINUS : Resta un conjunto del otro 
 
--- LEFT JOIN (ConjuntoA) - ON (ConjuntoB) WHERE 
--- RIGTH JOIN (ConjuntoA) - ON (ConjuntoB) WHERE

--- Operadores: 
-- SUM : Suma de los valores de una columna 
-- MIN : Minimo ----------
-- MAX : Maximo ----------
-- COUNT : Cuenta la cantidad de valores de una columna 
-- AVG : Promedio de los valores de una columna 

-- COUNT(*) FROM TABLA : Cuenta todos los valores de la tabla 

-- Cuando se tiene una mezcla entre atributos agrupados y simples
-- se tiene que usar el GROUP BY 

-- Cuando se usa el GROUP BY para poner una condicion se utiliza el
-- HAVING 

-- GROPU BY Tabla
-- HAVING sum(Tabla) > 200; 

-- Consultas anidadas: Introducir una consulta sobre otra. 

-- IN: se utiliza para saber si una resultado se encuentra en 
-- un conjunto 
-- TablaA IN (Consulta); 

--- CREAR UNA TABLA DENTRO DE UNA CONSULTA 
-- SELECT ItemA, ItemB , ItemTablaB
-- FROM TablaA, ( Consulta )TablaB 
-- WHERE condicionA > TablaB.ItemTablaB; 

--- OTRAS CONDICIONES 
-- ANY : algun valor en la lista -: condicion ANY ( < ANY(Consulta))
-- ALL : Todos los valores -: condicion ALL ( > ALL(consulta))
-- EXIST : existe alguno en la lista 
-- NOT EXIST : No existe en la lista

--- EJEMPLOS ---

-- Seleccionar empleados que en promedio ganan más que 
-- el promedio de alguno de los departamentos 

SELECT E.first_name Nombre
FROM s_emp E, s_salary S  
WHERE E.id = S.id 
GROUP BY E.first_name 
HAVING avg(S.payment) > ANY(SELECT avg(S.payment)
                        FROM s_emp E,s_salary S 
                        WHERE E.id = S.id
                        GROUP BY E.dept_id); 

-- Seleccione el nombre y apellido de todos los empleados 
-- que tienen el mismo cargo que 
-- Carmen Velásquez

SELECT E.first_name Nombre, E.last_name apellido 
FROM s_emp E 
WHERE E.title = (SELECT E.title
                FROM s_emp E 
                WHERE lower(E.first_name) LIKE 'carmen%' AND 
                      lower(E.last_name) LIKE 'vel%');

-- Liste los empleados que ganan el máximo salario

SELECT E.first_name Nombre 
FROM s_emp E, s_salary S  
WHERE E.id = S.id AND 
      S.payment = (SELECT MAX(S.payment) 
                   FROM s_salary S);

-- Liste los empleados que ganan el salario maximo por 
-- departamento 

SELECT E.first_name Nombre, MAXDP.Max 
FROM s_emp E,s_salary S,(SELECT E.dept_id Dept , MAX(S.payment) Max
                            FROM s_emp E, s_salary S
                            WHERE E.id = S.id 
                            GROUP BY E.dept_id) MAXDP
WHERE E.id = S.id AND 
      E.dept_id = MAXDP.Dept 
GROUP BY E.first_name, MAXDP.Max 
HAVING MAX(S.payment) = MAXDP.Max ; 

---Liste el ID, el apellido y la fecha de entrada de todos los empleados cuyos salarios 
---son menores que el promedio general de salario y trabajan en algún departamento 
---que cuente con un empleado de nombre PATEL

SELECT E.id, E.last_name apellido, E.start_date Entrada 
FROM s_emp E, s_salary S 
WHERE E.id = S.id AND 
      S.payment < (SELECT AVG(S.payment)
                      FROM s_salary S)
INTERSECT 
SELECT E.id, E.last_name apellido, E.start_date Entrada 
FROM s_emp E
WHERE E.dept_id IN (SELECT E.dept_id 
                   FROM s_emp E 
                   WHERE lower(E.last_name) like 'patel%');

