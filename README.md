## O que é modelo

O modelo desenvolvido busca lidar com a problemática levantada no estudo de Karin et al. [1]  referente aos países que aderem ao lockdown. Uma estratégia comum dessas regiões que é colocada em questão é a de que o bloqueio da movimentação e atividades econômicas ocorre quando um número limite de casos é excedido e o desbloqueio, quando os casos diminuem. Porém, apesar dessa estratégia contribuir para impedir o sobrecarregamento dos serviços de saúde, ao mesmo tempo continua a acumular casos com cada nova onda, além de levar à incerteza econômica. 

Logo, é proposta uma estratégia cíclica adaptativa para o lockdown através de um modelo matemático, onde em suas variáveis de adaptação são levados em consideração x dias, onde a população realiza suas atividades no meio social, e y dias, onde a população mantém-se em lockdown. No presente modelo, buscou-se adaptar essa estratégia e levar alguns fatores levantados no estudo para uma realizar uma simulação do retorno das aulas presenciais.

## Como funciona

O  foco  da simulação é analisar  como  a  onda  de  novos  casos  de  Covid-19  comporta-se através da estratégia cíclica adaptativa de lockdown em uma situação de retorno das aulas presenciais, podendo compara-la com a estratégia padrão de lockdown ou sem nenhuma restrição de movimentação. Assim, podemos observar como essas diferentes estratégias afetam o número de infectados e mortos ao longo do tempo por essa doença.

Logo, foram definidas três tipos de estratégias: 

- **"Cyclic"**: onde durante uma quantidade _x_ de dias a população estudantil poderá ir para a escola e durante uma quantidade _y_, ficará em lockdown em sua casa juntamente com sua família.

- **"Lockdown"**: onde toda a população ficará durante tempo indeterminado em isolamento em cada casa.

- **"None"**: onde nenhuma medida de isolamento é tomada, ou seja, a população movimenta-se livremente pelo ambiente.

## Como utilizar

Para rodar a simulação, aperte SETUP e depois GO. Visto que a simulação busca analisar a estratégia escolhida ao longo do tempo, para finalizá-la é necessário apertar novamente o botão GO para o deselecionar. 

O slider POPULATION controla quantas pessoas são levadas em consideração na simulação. A quantidade selecionada é um múltiplo de 3, visto que essa população será dividida em HOMEBASES (famílias) e a média de pessoas por família no Brasil é igual a 3, de acordo com o IBGE [2].

Para determinar a quantidade de infectados iniciais de uma população, utilize o slider INITIAL-INFECTEDS. O botão SET-INFECTED seleciona um pessoa aleatória da população e a torna infetada.

A variável RECOVERY-PROBABILITY determina a probabilidade máxima de uma pessoa da população, após a contaminação, recuperar-se e tornar-se imune a doença. Enquanto que a variável INFECTIOUNESS-PROBABILITY determina a probabilidade máxima de uma pessoa infectada da população contaminar outra pessoa próxima.

O slider %-POPULATION-LEAK determina a porcentagem da população que não adere ao lockdown, movimentando-se pelo ambiente.

O seletor STRATEGY-TYPE determina a estratégia que será utilizada na simulação, podendo variar entre uma estratégia cíclica, lockdown ou none (nenhuma medida de isolamento é tomada). Visto que essa simulação busca analisar principalmente a estratégia cíclica, ela é tida como valor inicial desse seletor.

Se a variável PREVENTION-CARE? está em "On", a probabilidade de infectar outra pessoa (INFECTIOUNESS-PROBABILITY) é diminuída em até 60%, porcentagem estimada através de estudos [3, 4] que levam em consideração a utilização de máscaras e cuidados de higiene. 

Os sliders LOCKDOWN-DURATION e SCHOOLDAY-DURATION determinam a quantidade de dias do cronograma da estratégia cíclica, onde LOCKDOWN-DURATION determina quantos dias a população ficará isolada em casa, enquanto SCHOOLDAY-DURATION determina quantos dias a população estudantil irá mover-se de casa para a escola.

## Coisas para tentar

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## Estendendo o modelo

Sugere-se aumentar o modelo e simulá-lo com um número maior de escolas, levando em consideração o transporte dos estudantes até elas (podendo ser infectado nesse caminho, caso utilize transportes públicos). Além disso, recomenda-se adicionar o fator de idade que afeta a probabilidade de recuperação, levando em conta a severidade dos sintomas. Por fim, é interessante simular a "quebra" do lockdown não apenas para aqueles que circulam pelo ambiente, mas também para os que visitam outras casas.  

## Modelos relacionados

Alvarez, L. and Rojas-Galeano, S. “Simulation of Non-Pharmaceutical Interventions on COVID-19 with an Agent-based Model of Zonal Restraint”. medRxiv pre-print 2020/06/13; https://www.medrxiv.org/content/10.1101/2020.06.13.20130542v1 DOI: 10.1101/2020.06.13.20130542

## Créditos e referências

[1] Karin, Omer & Bar-On, Yinon & Milo, Tomer & Katzir, Itay & Mayo, Avi & Korem, Yael & Dudovich, Boaz & Zehavi, Amos & Davidovich, Nadav & Milo, Ron & Alon, Uri. (2020). Adaptive cyclic exit strategies from lockdown to suppress COVID-19 and allow economic activity. DOI: 10.1101/2020.04.04.20053579. 

[2] Ohana, Victor. (2019). IBGE: 2,7% das famílias ganham um quinto de toda a renda no Brasil. Acesso em: 22/06/2020, https://www.cartacapital.com.br/sociedade/ibge-27-das-familias-ganham-um-quinto-de-toda-a-renda-no-brasil/amp/

[3] Holanda, Debora. (2020). Simulador para estudo de comportamento do COVID-19 na população brasileira. Acesso em: 22/06/2020, https://medium.com/@holanda.debora/simulador-para-estudo-de-comportamento-do-covid-19-na-população-brasileira-c809ea8586c9.

[4] Macintyre, Chandini & Chughtai, Abrar. (2015). Facemasks for the prevention of infection in healthcare and community settings. DOI: 10.1136/bmj.h69