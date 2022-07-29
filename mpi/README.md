# Задача №1. Нахождение интеграла с использованием MPI

## $`\int\limits_0^1\frac{4}{1+x^2}dx`$

### Постановка задачи: решить определенный интеграл методом трапеций.

Предполагается, что запуск исполняемого файла будет происходить с использованием p процессов. 
Один из p процессов («основной») разбивает отрезок $`[0; 1]`$ на $`N`$ малых отрезков длиной $`\Delta x`$ (шаг интегрирования), 
и вычисляет с этим разбиением интеграл в последовательном варианте. Далее этот же процесс разбивает отрезок $`[0; 1]`$, 
состоящий из $`N`$ малых отрезков, на $`p`$ частей и границы каждой из оставшихся $`(p-1)`$ частей рассылает остальным $`(p-1)`$ процессам 
(с одной из частей отрезка работает сам «основной» процесс). Число $`N`$ может меняться и задается пользователем.

Каждый из процессов, получивших свои границы части отрезка, должен вычислить свою часть интеграла $`I_i`$ и отправить ее «основному» процессу.

«Основной» процесс получает все части интеграла от процессов-рабочих и, складывая их, получает исходный интеграл  $`I`$. 