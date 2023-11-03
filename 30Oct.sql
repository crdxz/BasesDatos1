--->>> Toma los nombres de las tables de la base de datos
SELECT table_name
FROM user_tables;
--->>> 

---Seleccionar los vendedores que despacharon orden
---

select E.first_name || ' '|| E.last_name
Despachador, O.id orden 
from s_emp E, s_ord O 
where E.id = O.stock_clerk; 


---Seleccionar las ordenes con los representantes que 
---la consiguieron y los vendedores que la despacharon

select O.id orden, 
       R.first_name ||' '|| R.last_name Representante,
       D.first_name ||' '|| D.last_name Despachador 
from s_emp R, s_emp D, s_ord O 
where R.id = O.sales_rep_id AND 
      D.id = O.stock_clerk; 


Select 
from s_emp J, s_emp E
where J 

---Seleccionar los empleados con el codigo del jefe
---

select E.id, E.first_name ||' '|| E.last_name, E.manager_id 
from s_emp E; 

---Seleccionar los empleados con el nombre de su jefe y cargo 
---

Select J.first_name ||' '|| J.last_name Jefes,  J.title CargoJ,
       E.first_name ||' '|| E.last_name Empleados, E.title CargoE
from s_emp J, s_emp E
where J.id = E.manager_id;     --->>> Usa el mismo principio de access utilizando una 
				      ---autoreferencia para crear una tabla ciclic, usando 
				      ---una copia de la misma tabla, s_emp J y s_emp E. 

---Seleccionar las personas relacionadas con la compañia 
---

select C.name Persona, 'Cliente' relacion      
from s_customer C
UNION 
select E.first_name||' '||E.last_name Persona, 
	'Empleado' relacion 
from s_emp E;

--->>> 'Cliente' relacion :_ es una columna ficticia, que no hace parte de la BD.
--->>> UNION: realiza la union de los resultados de dos consultas. 


---Seleccionar los nombre de los productos que se han vendido 
---

select distinct P.name producto 
from s_product P, s_item I 
where P.id = I.product_id;

--->>> s_item: tiene el registro de los pedidos ordenados por un cliente

---Seleccionar los productos que nunca se han vendido
---

select distinct P.name producto
from s_product P
MINUS 
select distinct P.name producto
from s_product P, s_item I 
where P.id = I.product_id;

---Seleccionar los productos que se han vendido en ASIA y AFRICA
--- 

select distinct P.name producto
from s_region R, s_warehouse W, s_inventory I, s_product P, s_item IT 
where R.id = W.region_id AND 
      W.id = I.warehouse_id AND 
      P.id = I.product_id AND 
      P.id = IT.product_id AND 
      lower(R.name) like 'asia%'
INTERSECT 
select distinct P.name producto
from s_region R, s_warehouse W, s_inventory I, s_product P, s_item IT 
where R.id = W.region_id AND 
      W.id = I.warehouse_id AND 
      P.id = I.product_id AND 
      P.id = IT.product_id AND 
      lower(R.name) like 'afri%';

---Seleccionar los nombres de los jefes tengan o no tengan subalternos
---

select J.first_name||' '||J.last_name Jefe, J.title Cargo,  
      E.first_name||' '||E.last_name subalt
from s_emp J
left join s_emp E 
on J.id = E.manager_id;

--- Otra forma de hacer lo mismo del punto anterior--- 

select J.first_name||' '||J.last_name Jefe, J.title Cargo,  
      E.first_name||' '||E.last_name subalt
from s_emp J, s_emp E 
where J.id = E.manager_id(+);

--->>> LEFT JOIN: buscar un diagrama. 

---Seleccionar los nombres de los jefes que no tengan subalternos
---

select J.first_name||' '||J.last_name Jefe, J.title Cargo,  
      E.first_name||' '||E.last_name subalt
from s_emp J
left join s_emp E 
on J.id = E.manager_id
where E.manager_id is NULL;

--- Otra forma de hacer lo mismo del punto anterior--- 

select J.first_name||' '||J.last_name Jefe, J.title Cargo,  
      E.first_name||' '||E.last_name subalt
from s_emp J, s_emp E 
where J.id = E.manager_id(+) AND E.manager_id is NULL;

--- seleccionar los nombres de los subalternos que tengan o no jefe
---

select J.first_name||' '||J.last_name Jefe, J.title Cargo,  
      E.first_name||' '||E.last_name subalt
from s_emp J
right join s_emp E 
on J.id = E.manager_id;

--->>> RIGHT JOIN : buscar un diagrama. 

--- Otra forma de hacer lo mismo del punto anterior--- 

select J.first_name||' '||J.last_name Jefe, J.title Cargo,  
      E.first_name||' '||E.last_name subalt
from s_emp J, s_emp E 
where J.id(+) = E.manager_id;

---Seleccionar los nombres de los subalternos que no tienen Jefe 
---
select J.first_name||' '||J.last_name Jefe, J.title Cargo,  
      E.first_name||' '||E.last_name subalt
from s_emp J
right join s_emp E 
on J.id = E.manager_id
where J.id IS NULL; 

--- Otra forma de hacer lo mismo del punto anterior--- 

select J.first_name||' '||J.last_name Jefe, J.title Cargo,  
      E.first_name||' '||E.last_name subalt
from s_emp J, s_emp E 
where J.id(+) = E.manager_id AND J.id is NULL;





















