# Data Chalenge - TOTVS Labs

Este código tem como objetivo solucionar o desafio proposto pela TOTVS Labs, como requisito  para o cargo de Cientista de Dados.

O desafio consiste em analisar dados de notas fiscais eletronicas de um restaurante. Maiores detalhes do desafio podem ser encontrados em:
https://github.com/TOTVS/MDMStatic/tree/master/code-challenge

A seguir descrevo os passos que segui para resolução do desafio:

## 1- Importação e conversão dos dados

Através das funções  *import_df* e *convert_df*, importo os dados do arquivo json e crio um data frame com as seguintes colunas:
   
   * **TOTAL**: Valor total da nota;
   * **DIA**: Dia em que a nota foi emitida;
   * **AGUA**: Quantidade de água consumida pelo cliente;
   * **BUFFET**: Quantidade de buffet consumido pelo cliente;
   * **SUCO**: Quantidade de suco consumido pelo cliente;
   * **CHA**: Quantidade de chá consumido pelo cliente;
   * **CAFE EXPRESSO**: Quantidade de café expresso consumido pelo cliente;
   * **TEMAKI**: Quantidade de temaki consumido pelo cliente;
   * **SAKE**: Quantidade de sake consumida pelo cliente;
   * **WHISKY**: Quantidade de whisky consumido pelo cliente;
   * **SUSHI ESPECIAL**: Quantidade de sushi especial consumido pelo cliente;
   * **SASHIMI**: Quantidade de sashimi consumido pelo cliente;
   * **CERVEJA**: Quantidade de cerveja consumida pelo cliente;
   * **YAKISSOBA**: Quantidade de yakissoba consumido pelo cliente;
   * **SOBREMESA**: Quantidade de sobremesa consumida pelo cliente;
   * **HARUMAKI**: Quantidade de harumaki consumido pelo cliente;
   * **CAIPIRINHA**: Quantidade de caipirinha consumida pelo cliente;
   * **CAIPIROSKA**: Quantidade de caipiroska consumida pelo cliente;
   * **URAMAKI**: Quantidade de uramaki consumido pelo cliente;
   * **REFRIGERANTE**: Quantidade de refrigerante consumido pelo cliente;
   * **DOCINHOS**: Quantidade de docinhos consumidos pelo cliente;
   * **BACARDI**: Quantidade de bacardi consumido pelo cliente;
   * **VINHO**: Quantidade de vinho consumido pelo cliente;
   
## 2- Limpeza dos dados

Analizando o resultado da função *summary* e o *boxplot* do valor total das notas, podemos observar a existência de alguns *outliers*, notas com  o valor muito acima da média.

![boxplot_1](https://user-images.githubusercontent.com/38118826/38398808-aa135b2a-391c-11e8-86c3-540a378d2fb9.PNG)

Obtenho os outliers através da função *boxplot.stats* utilizando o parâmetro  *coef=1* para manter os outliers mais próximos ao terceiro quartil. Após a remoção dos outliers temos o seguinte boxplot:

![boxplot_2](https://user-images.githubusercontent.com/38118826/38399003-05f24450-391e-11e8-9424-c1db7e9b34d3.PNG)

O Valor máximo da nota caiu de 608,91 para 125,62.

## 3- Análise de Correlação

Analisando a matriz de correlação observo que as váriaveis BUFFET, REFRIGERANTE, AGUA, CERVEJA e SUCO possuem maior correlação com o valor total, logo essas váriaveis devem fazer parte do modelode regressão.

![correlacao](https://user-images.githubusercontent.com/38118826/38399607-ba2cdaea-3921-11e8-8b7b-78f257e93b3b.PNG)

## 4- Análise de regressão linear múltipla

Inicialmente utilizo a função lm para a criação do modelo de regressão linear, tendo como parâmetros as variáveis com maior grau de correlação.

Utilizo a função summary para validar se o modelo necessita de algum ajuste. Verifico através do valor-P, utilizando 90% de confiança, que nenhuma das váriaveis deve ser removida do modelo. Através do R-Quadrado, verifico que 96% da variabilidade do valor das notas é explicado pelas váriaveis escolhidas para a modelagem. Logo o modelo não necessita de ajuste.

Em seguida realizo a validação cruzada, com dez folders, e utilizo a raiz do erro quadratico médio (RMSE) como medida de acurácia para validação do modelo. O resultado obtido pela validação cruzada foi um RMSE médio de 4.8. 

Concluo que uma possível equação que prevê o quanto um cliente irá gastar, em função das quantidades consumidas de buffet, refrigerante, água, cerveja e suco é dada por: 0.52 + 69.89 * BUFFET + 4.51 * REFRIGERANTE + 3.33 * AGUA + 7 * CERVEJA + 5.08 * SUCO.

## 5- Análise de série Temporal

Incialmente transformo o data frame, agrupando os valores das notas por dia, e utilizo a função *ts* para obter uma série temporal com os valores de vendas diárias.

![serie](https://user-images.githubusercontent.com/38118826/38460829-60a05894-3a98-11e8-9c8a-0f9c31e54696.png)

Utilizo a função *adf.test* para verificar se a série é estacionária. como o *p-value* é igual 0.01, considerando 90% de confiança, concluo que a série é estacionária.

Utilizo os gráficos de correlação e correlação parcial da série para identificar o modelo a ser utilizado.



