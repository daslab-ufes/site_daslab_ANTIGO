---
layout: single
title:  "Como criar gráficos interativos no R"
author: Bruno Santos
---

Durante uma análise de dados, é comum apresentarmos gráficos para
mostrar padrões nos dados ou para entender como duas variáveis se
relacionam, por exemplo. Podemos fazer um gráfico de barras para
comparar os valores de diferentes categorias ou poderíamos fazer um
gráfico de linhas para observar a evolução de uma certa variável ao
longo do tempo, para ilustrar somente duas situações. Uma ótima opção
para fazer gráficos no R é o pacote
[ggplot2](https://ggplot2.tidyverse.org/reference/). Aqui nesse blog já
mostramos inclusive como utilizar o pacote `gganimate` para fazer
animações desse tipo de gráficos e você pode conferir novamente aqui
nesse [link](https://daslab-ufes.github.io/estatistica_animada/). Porém,
é interessante em algumas situações passar o mouse por cima dos gráficos
para descobrir sobre os valores postados, para complementar a informação
que gostaríamos de passar com o gráficos. Alguns exemplos podem ser
vistos [aqui](https://coronavirus.es.gov.br/painel-covid-19-es) e [aqui
também](https://brasil.elpais.com/ciencia/2020-07-23/evolucao-dos-casos-de-coronavirus-no-brasil.html).

Esse tipo de gráfico não pode se valer simplesmente de uma imagem
estática, que é a maneira usual que o `R` gera seus gráficos. Nesse
caso, vamos utilizar o pacote
[`highcharter`](https://jkunst.com/highcharter/articles/highcharter.html),
que cria gráficos interativos utilizando rotinas de *javascript* por
trás de suas funções.

Para começar, vamos carregar alguns pacote de interesse:

``` r
library(highcharter)     # fazer gráficos interativos
library(dplyr)           # fazer manipulação de banco de dados
```

Para ilustrar algumas das capacidades desse pacote, vamos reconsiderar
os dados utilizados em um post anterior feito pelo Pedro, sobre os casos
do novo coronavirus no Estado do Espírito Santo. Para deixar o post mais
curto, nós vamos pular a parte de importação dos dados, pois vocês podem
ver todas as instruções no seguinte
[link](https://daslab-ufes.github.io/covid-es-r/). Vamos considerar que
o banco de dados estará disponível no objeto `dados`, assim como no post
linkado. Notem que as informações discutidas serão relativas ao dia
16/02/2021, dia em que o post foi escrito.

Uma primeira informação importante sobre o pacote `highcharter` é que o
resultado ou saída dos comandos é um objeto html, exatamente para
possibilitar essa interatividade entre usuário e gráfico. Nesse sentido,
você deve ter em mente que para apresentar esse gráfico você vai
precisar de um navegador ou se seu interesse é compartilhar o resultado
com outras pessoas, então é necessário disponibilizar o gráfico em algum
site. Vamos mostrar como fazer isso aqui também.

Para começar vamos considerar o número de casos das quatro cidades mais
populosas do Espírito Santo e fazer um gráfico de barras para comparar
as quantidades de cada um dos municípios. Podemos fazer isso da seguinte
maneira:

``` r
# Filtrando somente os casos confirmados de 
# Vitória, Vila Velha, Serra e Cariacica 
dados_filtrados <- 
  janitor::clean_names(dados) %>% 
  filter(municipio %in% c('VITORIA', 'VILA VELHA', 'SERRA', 'CARIACICA')) %>% 
  filter(classificacao == "Confirmados")


# E obtendo os valores totais
dados_sumarizados <- dados_filtrados %>% 
  group_by(municipio) %>% 
  summarise(total = n())

grafico <- 
  hchart(dados_sumarizados, type = "column", 
       hcaes(x = municipio, y = total)) %>%
  hc_colors("#440154FF") %>%
  hc_title(text = "Número de casos da COVID-19 no ES") %>%
  hc_subtitle(text = "Considerando somente Grande Vitória") %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "Número de casos")) %>%
  hc_credits(
    enabled = TRUE,
    text = "Fonte: Painel COVID-19 Espírito Santo",
    href = "https://coronavirus.es.gov.br/painel-covid-19-es")
```

``` r
grafico
```

<object class="html-widget" style="width:800px;height:480px;" data="/assets/files/post_highcharter/grafico.html">

</object>

O gráfico nos mostra, por exemplo, que o número de casos confirmados foi
maior nas cidades de Vila Velha e Serra. Note que é possível adicionar
link das fontes do gráfico, no canto inferior direito. Perceba que ao
passar o cursor do *mouse* por cima dos gráficos é possível obter a
informação das quantidades exatas de casos em cada uma das barras. Uma
possibilidade bastante interessante desse pacote é poder utilizar temas
com paleta de cores e fontes já definidas, de acordo com algum site ou
revista. Por exemplo, é possível utilizar o layout do site do
estatístico Nate Silver
[fivethirtyeight](https://fivethirtyeight.com/), fazendo simplesmente

``` r
grafico %>% 
  hc_add_theme(hc_theme_538())
```

<object class="html-widget" style="width:800px;height:480px;" data="/assets/files/post_highcharter/grafico1_1.html">

</object>

Outra opção é considerar um tema de lousa com fonte que imita a escrita
utilizando giz fazendo

``` r
grafico %>%
  hc_add_theme(hc_theme_chalk())
```

<object class="html-widget" style="width:800px;height:480px;" data="/assets/files/post_highcharter/grafico1_2.html">

</object>

A lista de temas disponíveis é bem grande, com opções bem interessantes.
Ao longo do post, vamos sempre utilizar um tema diferentes. Vocês podem
ver mais informações sobre isso no link
<https://jkunst.com/highcharter/articles/themes.html>, inclusive
comdicas inclusive de como criar o seu próprio tema.

Considerando uma outra variável, como raça/cor ou gênero, poderíamos
criar para cada um dos municipios a barra correspodente para cada caso.
A princípio de ilustração, vamos retirar os valores de pessoas
indígenas, por se tratar de um valor pequeno de observações e também
dados para os quais não há informação de raça/cor.

``` r
dados_sumarizados_2 <- dados_filtrados %>% 
  filter(raca_cor %in% c("Amarela", "Branca", "Parda", "Preta")) %>% 
  group_by(municipio, raca_cor) %>% 
  summarise(total = n())

grafico2 <- 
  hchart(dados_sumarizados_2, type = "column", 
       hcaes(x = municipio, y = total, group = raca_cor)) %>%
  hc_title(text = "Número de casos da COVID-19 no ES por raça/cor") %>%
  hc_subtitle(text = "Considerando somente Grande Vitória") %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "Número de casos")) %>%
  hc_credits(
    enabled = TRUE,
    text = "Fonte: Painel COVID-19 Espírito Santo",
    href = "https://coronavirus.es.gov.br/painel-covid-19-es") %>% 
  hc_add_theme(hc_theme_elementary())
```

``` r
grafico2
```

<object class="html-widget" style="width:800px;height:480px;" data="/assets/files/post_highcharter/grafico2.html">

</object>

Apenas para Vitória o número de casos entre pessoas brancas e pessoas
parada é similar, enquanto nas outras cidades o número de casos de
pessoas pardas é sempre maior. Podemos fazer o mesmo gráfico, porém
agora considerando o número de mortes.

``` r
dados_sumarizados_3 <- dados_filtrados %>% 
  filter(raca_cor %in% c("Amarela", "Branca", "Parda", "Preta")) %>% 
  filter(evolucao == "Óbito pelo COVID-19") %>% 
  group_by(municipio, raca_cor) %>% 
  summarise(total = n())

grafico3 <- 
  hchart(dados_sumarizados_3, type = "column", 
       hcaes(x = municipio, y = total, group = raca_cor)) %>%
  hc_title(text = "Número de mortes da COVID-19 no ES por raça/cor") %>%
  hc_subtitle(text = "Considerando somente Grande Vitória") %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "Número de mortes")) %>%
  hc_credits(
    enabled = TRUE,
    text = "Fonte: Painel COVID-19 Espírito Santo",
    href = "https://coronavirus.es.gov.br/painel-covid-19-es") %>% 
  hc_add_theme(hc_theme_google())
```

``` r
grafico3
```

<object class="html-widget" style="width:800px;height:480px;" data="/assets/files/post_highcharter/grafico3.html">

</object>

Ainda sobre os dados da pandemia, poderíamos estar interessados em fazer
gráficos de linha com o número de casos por dia por município e mostrar
esses valores lado a lado, para entender a evolução da doença e também
para falar sobre 1ª e 2ª onda de casos. Podemos fazer isso da seguinte
forma:

``` r
# Filtrando somente os casos confirmados de 
# Vitória, Vila Velha, Serra e Cariacica 
# E obtendo os valores totais
dados_sumarizados_4 <- dados_filtrados %>% 
  mutate(data_notificacao = as.Date(data_notificacao)) %>% 
  group_by(municipio, data_notificacao) %>% 
  summarise(total = n())

grafico4 <- 
  hchart(dados_sumarizados_4, type = "line", 
       hcaes(x = data_notificacao, y = total, group = municipio)) %>%
  hc_title(text = "Número de casos pela COVID-19 no ES") %>%
  hc_subtitle(text = "Considerando somente Grande Vitória") %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "Número de casos")) %>%
  hc_credits(
    enabled = TRUE,
    text = "Fonte: Painel COVID-19 Espírito Santo",
    href = "https://coronavirus.es.gov.br/painel-covid-19-es") %>% 
  hc_add_theme(hc_theme_alone())
```

``` r
grafico4
```

<object class="html-widget" style="width:800px;height:480px;" data="/assets/files/post_highcharter/grafico4.html">

</object>

Para facilitar a visualização, poderíamos considerar uma média móvel de
7 dias, fazendo o seguinte.

``` r
menor_data <- min(as.Date(dados$DataNotificacao))
maior_data <- max(as.Date(dados$DataNotificacao))
dados_sumarizados_5 <- dados_filtrados %>% 
  mutate(data_notificacao = as.Date(data_notificacao)) %>% 
  group_by(municipio, data_notificacao) %>% 
  summarise(total = n()) %>% 
  tidyr::complete(tidyr::nesting(municipio), 
                  data_notificacao = seq.Date(menor_data, maior_data, 
                                        by = "day"), 
                  fill = list(total = 0)) %>%
  arrange(municipio, data_notificacao) %>% 
  ungroup() %>% 
  mutate(total_menos1 = lag(total), 
         total_menos2 = lag(total, 2), 
         total_menos3 = lag(total, 3),
         total_menos4 = lag(total, 4), 
         total_menos5 = lag(total, 5), 
         total_menos6 = lag(total, 6)) %>% 
  mutate(media_movel = (total + total_menos1 + total_menos2 + total_menos3 + total_menos4 + total_menos5 + total_menos6) / 7) %>% 
  filter(data_notificacao > as.Date("2020-04-01"))

grafico5 <- 
  hchart(dados_sumarizados_5, type = "line", 
       hcaes(x = data_notificacao, y = media_movel, group = municipio)) %>%
  hc_title(text = "Número de casos pela COVID-19 no ES") %>%
  hc_subtitle(text = "Considerando somente Grande Vitória") %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "Número de casos")) %>%
  hc_credits(
    enabled = TRUE,
    text = "Fonte: Painel COVID-19 Espírito Santo",
    href = "https://coronavirus.es.gov.br/painel-covid-19-es") %>% 
  hc_add_theme(hc_theme_superheroes())
```

``` r
grafico5
```

<object class="html-widget" style="width:800px;height:480px;" data="/assets/files/post_highcharter/grafico5.html">

</object>

Veja como para as quatro cidades parece haver dois picos do número de
casos. Podemos fazer o mesmo tipo de análise, porém considerando uma
forma diferente de visualização. Podemos guardar para cada município o
maior valor de número de casos num certo dia. Nesse sentido, podemos
verificar em todos os dias da pandemia, o quão próximo estamos desse
valor máximo. Isso pode ser visualizado em um gráfico do tipo de *tiles*
(ou azulejos). Veja o exemplo a seguir:

``` r
dados_todos <- dados_filtrados %>% 
  mutate(data_notificacao = as.Date(data_notificacao)) %>% 
  group_by(municipio, data_notificacao) %>% 
  summarise(total = n()) %>% 
  tidyr::complete(tidyr::nesting(municipio), 
                  data_notificacao = seq.Date(menor_data, maior_data, 
                                        by = "day"), 
                  fill = list(total = 0)) %>%
  arrange(municipio, data_notificacao) %>% 
  ungroup() %>% 
  mutate(total_menos1 = lag(total), 
         total_menos2 = lag(total, 2), 
         total_menos3 = lag(total, 3),
         total_menos4 = lag(total, 4), 
         total_menos5 = lag(total, 5), 
         total_menos6 = lag(total, 6)) %>% 
  mutate(media_movel = (total + total_menos1 + total_menos2 + total_menos3 +
                            total_menos4 + total_menos5 + total_menos6) / 7) %>%
  group_by(municipio) %>% 
  mutate(perc_total = media_movel/max(media_movel, na.rm = TRUE)) %>% 
  filter(data_notificacao > as.Date("2020-04-01")) %>% 
  mutate(municipio = forcats::fct_drop(municipio))


# Retirado de https://jkunst.com/highcharter/articles/showcase.html
grafico6 <- hchart(
  dados_todos, 
  "heatmap", 
  hcaes(
    x = data_notificacao,
    y = municipio, 
    value = perc_total
    )
  ) %>%
  hc_colorAxis(
    stops = color_stops(10, viridisLite::inferno(10))) %>%
  hc_yAxis(
    title = list(text = ""),
    reversed = TRUE, 
    offset = -10,
    tickLength = 0,
    gridLineWidth = 0, 
    minorGridLineWidth = 0,
    labels = list(style = list(fontSize = "9px"))
  ) %>%
  hc_xAxis(
    title = list(text = ""), 
    gridLineWidth = 0,
    offset = 20,
    labels = list(style = list(fontSize = "5px"))
  ) %>%
  hc_title(
    text = "Número de casos relativo ao total observado na pandemia"
    ) %>%
  hc_subtitle(
    text = "Número de casos dividido pelo maior valor de número de casos"
  ) %>% 
  hc_legend(
    layout = "horizontal",
    verticalAlign = "top",
    align = "left",
    valueDecimals = 0
  )
```

``` r
grafico6
```

<object class="html-widget" style="width:800px;height:480px;" data="/assets/files/post_highcharter/grafico6.html">

</object>

O gráfico nos mostra que os picos das 4 cidades não ocorreram exatamente
nos mesmos momentos, mas que parecem estar relacionados. Não foi
possível melhorar o texto do eixo x de forma satisfatória para esse
gráfico de *heatmap*, ao que deixamos dessa forma depois de algumas
tentativas frustradas de melhorar o resultado final. Poderíamos fazer o
mesmo gráfico para as 30 cidades com maior número de casos no Estado,
com resultado final mostrado a
seguir.

``` r
grafico7
```

<object class="html-widget" style="width:800px;height:720px;" data="/assets/files/post_highcharter/grafico7.html">

</object>

Conforme falamos no início, esses gráficos para ter esse comportamento
interativo precisam ser disponibilizados em formato `html`. Para fazer
isso, podemos utilizar outro pacote como o `htmlwidgets`. Por exemplo,
para cada gráfico criado, tendo em vista que salvamos o gráfico em um
objeto como `grafico`, poderíamos fazer o seguinte para gerar um arquivo
html com o gráfico gerado:

``` r
htmlwidgets::saveWidget(grafico, file = 'grafico.html', 
                        libdir = "aux_files", selfcontained = FALSE)
```

As opções `selfcontained = FALSE` e `libdir` com algum caminho definido
ajudam a deixar o arquivo `html` menor, o que pode ser útil em algumas
situações.

O código ao longo deste post não foi organizado da melhor maneira
possível. Isto foi feito exatamente para lembrar que existem boas
práticas que devem ser seguidas. O post anterior no blog retrata
exatamente isto e vocês podem ler este texto clicando
[aqui](https://daslab-ufes.github.io/boas-praticas/).

Este post demonstrou alguns exemplos com o pacote `highcharter` mas
existem muitas outras opções de gráficos e temas que não foram
explorados aqui. Terminamos aqui para não estender o post ainda mais.
Mas deixamos alguns links com mais exemplos do pacote:

  - <https://jkunst.com/highcharter/articles/showcase.html>

  - <https://jkunst.com/highcharter/articles/stock.html>

  - <https://jkunst.com/highcharter/articles/maps.html>

Esperamos que estejam gostando e que continuem acompanhando nossos posts
por aqui.
