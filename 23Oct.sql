***Primeros Ejemplos*** 

select first_name, title, salary, commission_pct, commission_pct/100 from s_emp;
select first_name, salary , commission_pct, salary+salary*nvl(commission_pct, 0)/100 as Pago from s_emp;

***Seleccionar personas que no gana comision***

Select first_name, last_name 
from s_emp
where commission_pct is null; 

***Seleccionar CARGOS que gana comision***

Select distinct title 
from s_emp
where commission_pct is not null; 

>>> distinc - Selecciona los casos distintos, quita los casos repetidos.

***Seleccionar los nombres y cargos de los empleados que ganan mas de 1700***

Select first_name, title, salary+salary*nvl(commission_pct, 0)/100 as Pago
from s_emp 
where (salary+salary*nvl(commission_pct, 0)/100)>1700; 

***Seleccionar los nombres, Salario y usa las funciones FLoor y Ceil***

Select first_name,salary+salary*nvl(commission_pct, 0)/100 as Salario, 
trunc(salary+salary*nvl(commission_pct, 0)/100,1) as Truncar, 
round(salary+salary*nvl(commission_pct, 0)/100,1) as Redondear 
from s_emp;

***Seleccionar los nombres, Salario y usa las funciones FLoor y Ceil***

Select first_name,salary+salary*nvl(commission_pct, 0)/100 as Salario, 
floor(salary+salary*nvl(commission_pct, 0)/100) as Piso, 
ceil(salary+salary*nvl(commission_pct, 0)/100) as Techo
from s_emp;

***Extrae el año de ingreso de los empleados***

SELECT first_name, start_date ,
EXTRACT(YEAR FROM start_date) ANO
from s_emp;

***Extrae los empleados que ingresaron en Febrero***

SELECT first_name, start_date ,
EXTRACT(month FROM start_date) Mes 
from s_emp
where (EXTRACT(month FROM start_date))= 2;

***Mostrar la fecha actual del sistema***

Select CURRENT_DATE , SYSDATE 
from dual;

***Todos los empleados que llevan mas de 3 años en la compañia*** 

Select first_name, last_name, EXTRACT(year FROM CURRENT_DATE) - EXTRACT(year FROM Start_date) as Anos
from s_emp
where EXTRACT(year FROM CURRENT_DATE) - EXTRACT(year FROM Start_date) > 3;

***Selecciona la cantidad de meses entre el dia actual y la fecha de ingreso*** 

select first_name, last_name, round(MONTHS_BETWEEN(sysdate,start_date),0)as Meses
from s_emp; 

***Determina si el empleado gana o no comisiones***

select first_name, nvl2(commission_pct, 'gana','No gana') gana
from s_emp;

***Convertir una fecha en una cadena con formato***

select first_name, to_char(start_date,'MON/DD') formato
from s_emp;

*** Muestra segun un rango de precios si el empleado gana: bajo,medio o alto***

Select first_name,title, CASE When salary<=1000 THEN 'bajo' WHEN salary >= 1000
AND salary<=1200 THEN 'Medio' ELSE 'alto' END "Categoria Salario"
from s_emp;



>>> trunc - Truncar: necesita un parametro (columna, No decimales)
>>> round - Redondear: necesita un parametro (columna, No decimales) 
>>> floor - Piso 
>>> ceil  - Techo 
>>> distinc - Selecciona los casos distintos, quita los casos repetidos.
>>> abs   - Valor absoluto
>>> extract - Extrae valores de una fecha o intervalo
>>> current_date - Devuelve la fecha actual del servidor
>>> mount_between - Devuelve la cantidad de meses entre dos fechas
>>> nvl2 - Si expr1 no es nulo, devuelve expr2. Si expr1 es nulo, devuelve expr3. Los argumentos pueden ser de cualquier tipo.
>>> nvl - Si expr1 es nulo, devuelve expr2. Si expr1 no es nulo, devuelve expr1. Los argumentos pueden ser de cualquier tipo.
>>> to_char - Convierte una fecha a una cadena o un número con el formato especificado.
>>> case - Evalua diferentes expresiones para dar un valor de salida.