#Natália Sens Weise
#a) Total de localidades por Unidade da Federação (UF);
SELECT ufe_sg, COUNT(ufe_sg) AS qtd_uf FROM log_localidade GROUP BY ufe_sg;

#b) Qual é a UF que apresenta o maior número de municípios;
SELECT ufe_sg, COUNT(*)
FROM log_localidade
where loc_in_tipo_localidade = 'M'
GROUP BY ufe_sg
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
FROM log_localidade where loc_in_tipo_localidade = 'M' GROUP BY ufe_sg);

#c) Qual o número de CEPs encontrados em cada UF ordenados pelo maior número;
SELECT ufe_sg, COUNT(cep) AS qtd_cep FROM log_localidade GROUP BY ufe_sg ORDER BY qtd_cep DESC;

#d) Qual o número de CEPs encontrados em cada município (loc_in_tipo_localidade = 'M'), 
#com respectiva UF, ordenados pelo maior número (de CEPs listados);
SELECT ufe_sg, COUNT(cep) AS qtd_cep FROM log_localidade where loc_in_tipo_localidade = 'M' GROUP BY ufe_sg ORDER BY qtd_cep DESC;

#e) Qual(is) o(s) nome(s) do(s) logradouro(s) considerado(s) mais popular(es) no Brasil;
SELECT log_nome, log_no, COUNT(log_no) AS popularidade FROM log_logradouro GROUP BY log_no 
HAVING popularidade > 1 ORDER BY popularidade DESC LIMIT 1;

#f) Quais os nomes das organizações (grandes usuários) da unidade da federação "SC" que possuem CEP exclusivo. 
# Listar também o nome do município;
SELECT loc_no AS municipio, gru_no AS org_da_uf FROM log_grande_usuario AS gu JOIn log_localidade AS lcd
WHERE lcd.loc_nu_sequencial = gu.loc_nu_sequencial 
AND lcd.ufe_sg = 'SC' ORDER BY municipio;

#g) Quais os nomes dos municípios com a respectiva UF que apresentam apenas um CEP;
SELECT ufe_sg AS uf, loc_no AS municipio , COUNT(cep)
FROM log_localidade
WHERE loc_in_tipo_localidade = 'M'
GROUP BY ufe_sg, municipio
HAVING count(cep)=1
ORDER BY 3 desc;

#h) Qual a localidade (nome) que apresenta o maior número de CEPs especiais (grandes usuários). Listar também a UF e a localidade;
SELECT lcd.ufe_sg AS uf, lcd.loc_no as nome, COUNT(gu.gru_nu_sequencial) AS cep_especial 
FROM log_grande_usuario AS gu JOIN log_localidade AS lcd 
WHERE lcd.loc_nu_sequencial = gu.loc_nu_sequencial GROUP BY nome ORDER BY cep_especial DESC LIMIT 1;

#i) Quais municípios possuem distrito (loc_in_tipo_localidade = 'D'). 
#Listar também, o número de distritos de cada município listado, ordenando pelo maior número encontrado;
SELECT loc_nosub AS municipio, COUNT(loc_nosub) AS qtd_dest FROM log_localidade 
WHERE loc_in_tipo_localidade = 'D'
GROUP BY municipio ORDER BY qtd_dest DESC;

#j) Listar o nome do, ou dos bairros mais populares (que mais são encontrados) 
#no estado de "SC", caso tenhamos empate no número máximo associado;
SELECT bai_no, COUNT(*) AS popularidade FROM log_bairro where ufe_sg='SC'
GROUP BY bai_no
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM log_bairro where ufe_sg='SC' GROUP BY bai_no)
ORDER BY popularidade;

#k) Qual o número de CEPs de cada bairro do município de "Blumenau" 
#localizado na unidade da federação  "SC". Listar o nome do bairro, também. Ordenar pelo maior número de CEPs;
SELECT bai_no as bairro, COUNT(log_logradouro.cep) AS qtd_cep FROM log_logradouro JOIN log_bairro JOIN log_localidade
WHERE loc_no = 'Blumenau' AND log_logradouro.bai_nu_sequencial_ini = log_bairro.bai_nu_sequencial AND 
log_logradouro.loc_nu_sequencial = log_localidade.loc_nu_sequencial
AND log_bairro.ufe_sg = 'SC'
GROUP BY bai_no ORDER BY qtd_cep DESC;

#m) Qual o nome de logradouro mais popular encontrado nos municípios da UF "SC". 
#Listar também o número de vezes encontrado, ordenando pelo maior número;
SELECT log_no, COUNT(log_no) AS popularidade FROM log_logradouro WHERE ufe_sg='SC'
GROUP BY log_no ORDER BY popularidade DESC LIMIT 1;

#n) Quais nomes de municípios são encontrados e mais de uma unidade da federação. 
#Listar também a quantidade de vezes em que o mesmo é encontrado;
SELECT loc_no AS municipio, COUNT(loc_no) as qtd_uf FROM log_localidade 
WHERE loc_in_tipo_localidade='M'
GROUP BY municipio 
having qtd_uf > 1
ORDER BY municipio;

#o) Listar o nome da praça com a respectiva informação do município (nome e UF), ordenando pela UF, seguida pelo município;
SELECT ufe_sg as uf, loc_no AS municipio FROM log_localidade WHERE loc_in_tipo_localidade='P' ORDER BY uf; 

#p) Listar o nome distrito com a respectiva informação do município da UF "SC";
SELECT dis.loc_nosub, loc.loc_nosub, dis.loc_no AS "Localidade + (Distrito)"
FROM log_localidade loc, log_localidade dis
WHERE loc.loc_nu_sequencial = dis.loc_nu_sequencial_sub
AND dis.loc_in_tipo_localidade = 'D'
AND dis.ufe_sg = 'SC';

SELECT loc_nosub, loc_no FROM log_localidade WHERE loc_in_tipo_localidade='D' AND ufe_sg='SC';

#q) Listar o nome de todos os bairros do município de "Blumenau", UF "SC";
SELECT distinct bai.bai_no AS bairro, loc.loc_no
from log_bairro AS bai, log_logradouro AS lgd, log_localidade loc
WHERE lgd.bai_nu_sequencial_ini = bai.bai_nu_sequencial
AND lgd.loc_nu_sequencial = loc.loc_nu_sequencial
AND bai.ufe_sg = 'SC'
AND loc.loc_no = 'Blumenau' ORDER BY bairro;

#r) Qual(s) município(s) não possui(em) praça no cadastro de localidades;
SELECT loc_no AS municipio FROM log_localidade
WHERE loc_nu_sequencial NOT IN (SELECT loc_nu_sequencial
FROM log_localidade
WHERE loc_in_tipo_localidade = 'P');

#s) Quais os tipos de logradouros com a respectiva quantidade de logradouros associados 
#(a cada tipo listado, ex.: Rua, quantas Ruas existem?);
SELECT log_tipo_logradouro AS tipo, COUNT(log_tipo_logradouro) AS qtd FROM log_logradouro GROUP BY tipo ORDER BY qtd DESC;

#t) Quantos municípios há em cada UF que apresentam mais de um CEP associado ao seu cadastro. Ordenar pela UF de maior número.
select ufe_sg, count(*) qtd from log_localidade where loc_in_tipo_localidade='M' and cep is null group by ufe_sg order by 2 DESC;

base_testes