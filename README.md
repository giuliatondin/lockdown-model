## O que é modelo

O modelo desenvolvido busca lidar com a problemática levantada no estudo de [Karin et al.]  referente aos países que aderem ao lockdown. Uma estratégia comum dessas regiões que é colocada em questão é a de que o bloqueio da movimentação e atividades econômicas ocorre quando um número limite de casos é excedido e o desbloqueio, quando os casos diminuem. Porém, apesar dessa estratégia contribuir para impedir o sobrecarregamento dos serviços de saúde, ao mesmo tempo continua a acumular casos com cada nova onda, além de levar à incerteza econômica. 

Logo, é proposta uma estratégia cíclica adaptativa para o lockdown através de um modelo matemático, onde em suas variáveis de adaptação são levados em consideração x dias, onde a população realiza suas atividades no meio social, e y dias, onde a população mantém-se em lockdown. No presente modelo, buscou-se adaptar essa estratégia e levar alguns fatores levantados no estudo para uma realizar uma simulação do retorno das aulas presenciais.

## Como funciona

O  foco  da simulação é analisar  como  a  onda  de  novos  casos  de  Covid-19  comporta-se através da estratégia cíclica adaptativa de lockdown em uma situação de retorno das aulas presenciais, podendo compara-la com a estratégia padrão de lockdown ou sem nenhuma restrição de movimentação. Assim, podemos observar como essas diferentes estratégias afetam o número de infectados e mortos ao longo do tempo por essa doença.

Logo, foram definidas três tipos de estratégias: 

- **"Cyclic"**: onde durante uma quantidade _x_ de dias a população estudantil poderá ir para a escola e durante uma quantidade _y_, ficará em lockdown em sua casa juntamente com sua família.

- **"Lockdown"**: onde toda a população ficará durante tempo indeterminado em isolamento em cada casa.

- **"None"**: onde nenhuma medida de isolamento é tomada, ou seja, a população movimenta-se livremente pelo ambiente.

## Coisas para tentar

Lembre-se de testar com PREVENTION-CARE? ligado e desligado. Além disso, teste com mais dias de escola e menos dias de lockdown para verificar o comportamento. Verifique os resultados obtidos a partir de diferentes taxas de aderência ao isolamento (%-POPULATION-LEAK).

## Créditos e referências

Karin, Omer & Bar-On, Yinon & Milo, Tomer & Katzir, Itay & Mayo, Avi & Korem, Yael & Dudovich, Boaz & Zehavi, Amos & Davidovich, Nadav & Milo, Ron & Alon, Uri. (2020). Adaptive cyclic exit strategies from lockdown to suppress COVID-19 and allow economic activity. DOI: 10.1101/2020.04.04.20053579. 

Alvarez, L. and Rojas-Galeano, S. “Simulation of Non-Pharmaceutical Interventions on COVID-19 with an Agent-based Model of Zonal Restraint”. medRxiv pre-print 2020/06/13; https://www.medrxiv.org/content/10.1101/2020.06.13.20130542v1 DOI: 10.1101/2020.06.13.20130542
