# Data Chalenge - TOTVS Labs

Este código tem como objetivo solucionar o desafio proposto pela TOTVS Labs, como requisito  para o cargo de Cientista de Dados.

O desafio consiste em analisar dados de notas fiscais eletronicas de um restaurante. Maiores detalhes do desafio podem ser encontrados em:
https://github.com/TOTVS/MDMStatic/tree/master/code-challenge

A seguir descrevo os passos que segui para resolução do desafio:

## 1- importação e conversão dos dados

Através das funções  *import_df* e *convert_df*, importo os dados do arquivo json e crio um data frame com as seguintes colunas:
   
   * **TOTAL**: valor total da nota;
   * **DIA**: dia em que a nota foi emitida;
   * **AGUA**: quantidade de água consumida pelo cliente;
   * **BUFFET**: quantidade de buffet consumida pelo cliente;
   * **SUCO**: quantidade de suco consumida pelo cliente;
   * **CHA**: quantidade de chá consumida pelo cliente;
   * **CAFE EXPRESSO**: quantidade de café expresso consumida pelo cliente;
   * **TEMAKI**: quantidade de temaki consumida pelo cliente;
   * **SAKE**: quantidade de sake consumida pelo cliente;
   * **WHISKY**: quantidade de whisky consumida pelo cliente;
   * **SUSHI ESPECIAL**: quantidade de sushi especial consumida pelo cliente;
   * **SASHIMI**: quantidade de sashimi consumida pelo cliente;
   * **CERVEJA**: quantidade de cerveja consumida pelo cliente;
   * **YAKISSOBA**: quantidade de yakissoba consumida pelo cliente;
   * **SOBREMESA**: quantidade de sobremesa consumida pelo cliente;
   * **HARUMAKI**: quantidade de harumaki consumida pelo cliente;
   * **CAIPIRINHA**: quantidade de caipirinha consumida pelo cliente;
   * **CAIPIROSKA**: quantidade de caipiroska consumida pelo cliente;
   * **URAMAKI**: quantidade de uramaki consumida pelo cliente;
   * **REFRIGERANTE**: quantidade de refrigerante consumida pelo cliente;
   * **DOCINHOS**: quantidade de docinhos consumida pelo cliente;
   * **BACARDI**: quantidade de bacardi consumida pelo cliente;
   * **VINHO**: quantidade de vinho consumida pelo cliente;
   
## 2- Limpeza dos dados

Analizando o resultado da função *summary* e o *boxplot* do valor total das notas, podemos observar a existência de alguns *outliers*, notas com  o valor muito acima da média.

![boxplot_1](https://user-images.githubusercontent.com/38118826/38398808-aa135b2a-391c-11e8-86c3-540a378d2fb9.PNG)

Obtenho os outliers através da função *boxplot.stats* utilizando o parâmetro  *coef=1* para manter os outliers mais próximos ao terceiro quartil. Após a remoção dos outliers temos o seguinte boxplot:

