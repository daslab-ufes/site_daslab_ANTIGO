---
layout: single
title:  "Utilizando mapas para mostrar estatísticas importantes"
author: Bruno Santos
---

Para diversas informações, podemos analisar a sua variação, ou os seus
resultados basicamente, com a ajuda de mapas. Por exemplo, podemos
observar a população do Brasil por municípios para perceber quais
regiões são mais povodas ou mais populosas. Podemos estudar ainda
outras informações por município, como Índice de Desenvolvimento Humano
(IDH) e taxas de desemprego para entender quais regiões estão mais
desenvolvidas ou quais passam por maiores problemas econômicos,
respectivamente. Observar esse tipo de informação em mapas é importante
porque muitas vezes essas variáveis são correlacionadas espacialmente e
o mapa pode nos ajudar a entender essa relação.

Com isso em mente, hoje vamos mostrar como utilizar alguns pacotes do
`R` para apresentar informações em mapas.

Primeiramente, carregando alguns pacote de interesse:

``` r
library(ggplot2)         # fazer gráficos
library(rgdal)           # ler arquivos de mapas
library(dplyr)           # fazer manipulação de banco de dados
library(leaflet)         # gráficos com mapas interativos.
```

Inicialmente, precisamos fazer o *download* da malha municipal, que é
definida pelo IBGE da seguinte maneira

> A Malha Municipal retrata a situação vigente da Divisão Político
> Administrativa (DPA), através da representação vetorial das linhas
> definidoras das divisas estaduais e limites municipais, utilizada na
> coleta dos Censos Demográficos e demais pesquisas do IBGE.

Esses arquivos também são conhecidos como *shapefiles* e serão a base de
nossos mapas. É possível baixar os arquivos relativos a todo Brasil no
seguinte
[link](https://www.ibge.gov.br/geociencias/organizacao-do-territorio/15774-malhas.html?=&t=downloads).
Em consulta feita em dezembro de 2020, o nome do arquivo a ser baixado
era `br_municipios_20200807.zip`.

Ao baixar essa pasta com todos os municípios, você deve descompactar o
arquivo e salvar essa pasta em algum caminho de sua preferência. Para
facilitar, deixe salvo em um objeto esse caminho. Por exemplo, faça

``` r
caminho_mapas <- "Coloque o caminho da pasta aqui."
```

Note que dentro dessa pasta existem vários arquivos de diferentes
formatos, todos com o nome `BR_Municipios_2019`. Não se preocupe com
qual arquivo vamos utilizar por enquanto. Para ler os arquivos utilize a
função `readOGR` do pacote `rgdal`. Note que é possível fazer o `plot`
do objeto criado

``` r
mapa_brasil <- readOGR(dsn = caminho_mapas, 
                       layer = 'BR_Municipios_2019', verbose = FALSE)
plot(mapa_brasil)
```

![](mapas_da_estatistica_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Note porém que esse gráfico não é muito interessante devido a sua
resolução, pois a quantidade de linhas perto da costa dificulta a sua
visualização. Vamos mostrar como podemos ir melhorando esse mapa.

Primeiramente, podemos avaliar quantos objetos ou municípios são
apresentados fazendo

``` r
mapa_brasil$SIGLA_UF %>% 
  janitor::tabyl() %>% 
  knitr::kable()
```

| .  |   n |   percent |
| :- | --: | --------: |
| AC |  22 | 0.0039483 |
| AL | 102 | 0.0183058 |
| AM |  62 | 0.0111271 |
| AP |  16 | 0.0028715 |
| BA | 417 | 0.0748385 |
| CE | 184 | 0.0330223 |
| DF |   1 | 0.0001795 |
| ES |  78 | 0.0139986 |
| GO | 246 | 0.0441493 |
| MA | 217 | 0.0389447 |
| MG | 853 | 0.1530869 |
| MS |  79 | 0.0141780 |
| MT | 141 | 0.0253051 |
| PA | 144 | 0.0258435 |
| PB | 223 | 0.0400215 |
| PE | 185 | 0.0332017 |
| PI | 224 | 0.0402010 |
| PR | 399 | 0.0716080 |
| RJ |  92 | 0.0165111 |
| RN | 167 | 0.0299713 |
| RO |  52 | 0.0093324 |
| RR |  15 | 0.0026920 |
| RS | 499 | 0.0895549 |
| SC | 295 | 0.0529433 |
| SE |  75 | 0.0134602 |
| SP | 645 | 0.1157574 |
| TO | 139 | 0.0249462 |

Veja como Minas Gerais é o Estado com maior número de municípios com 853
no total. E tirando o DF, os Estados com menor número de municípios são
do Norte com Roraima, Amapá e Acre apresentando apenas 15, 16 e 22
municípios, respectivamente.

A título de curiosidade apenas, podemos fazer o mapa de apenas um estado
em particular da seguinte forma

``` r
subset(mapa_brasil, SIGLA_UF == "ES") %>% plot()
```

![](mapas_da_estatistica_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

A título de curiosidade, o mapa do Espírito Santo não tem um erro e
aquele ponto ao extremo leste são as ilhas [Trindade e Martim
Vaz](https://pt.wikipedia.org/wiki/Trindade_e_Martim_Vaz), que fazem
parte do território capixaba.

Continuando, podemos usar o `ggplot2` para melhorar nossos gráficos. Por
exemplo, podemos utilizar os dados de população do Estado do Espírito
Santo, que podem ser obtidos em
<https://www.ibge.gov.br/cidades-e-estados/es/> e fazer o gráfico dessa
informação. Os dados do ES foram salvos no objeto `dados_es` e uma parte
das informações disponíveis pode ser vista a seguir:

``` r
head(dados_es)
```

    ## # A tibble: 6 x 13
    ##   Município Código Gentílico `Prefeito [2017… `Área Territori… `População esti…
    ##   <chr>      <dbl> <chr>     <chr>                       <dbl>            <dbl>
    ## 1 Afonso C… 3.20e6 afonso-c… EDÉLIO FRANCISC…             941.            30455
    ## 2 Águia Br… 3.20e6 aguiabra… ANGELO ANTONIO …             454.             9631
    ## 3 Água Doc… 3.20e6 água-doc… PAULO MARCIO LE…             474.            10909
    ## 4 Alegre    3.20e6 alegrense JOSÉ GUILHERME …             757.            29975
    ## 5 Alfredo … 3.20e6 alfreden… FERNANDO VIDEIR…             616.            14636
    ## 6 Alto Rio… 3.20e6 alto-rio… LUIZ AMÉRICO BO…             228.             7874
    ## # … with 7 more variables: `Densidade demográfica - hab/km² [2010]` <dbl>,
    ## #   `Escolarização <span>6 a 14 anos</span> - % [2010]` <dbl>, `IDHM
    ## #   <span>Índice de desenvolvimento humano municipal</span> [2010]` <dbl>,
    ## #   `Mortalidade infantil - óbitos por mil nascidos vivos [2017]` <dbl>,
    ## #   `Receitas realizadas - R$ (×1000) [2017]` <dbl>, `Despesas empenhadas - R$
    ## #   (×1000) [2017]` <dbl>, `PIB per capita - R$ [2018]` <dbl>

Note porém que os nomes dos municipios contém acentos e por isso vamos
utilizar uma função para retirar esses caracteres especias para fazer o
cruzamento com a base dos mapas. Tal tratamento é comum para evitar
erros de cruzamento, em que um município está com um nome escrito de uma
forma em uma base e está escrito diferente na outra base.

Vamos fazer essas alterações nos dois bancos de dados, com a ajuda da
função `iconv` do pacote `base` do `R`.

``` r
# salvando somente informação do ES.
mapa_es <- subset(mapa_brasil, SIGLA_UF == "ES")

# criando variavel municipio no objeto mapa_es@data, com todas letras maiúsculas
mapa_es@data$municipio <- 
  iconv(mapa_es@data$NM_MUN, from = 'UTF-8', to = 'ASCII//TRANSLIT') %>%
  toupper()

# alterando nome das variaveis em dados_es
dados_es <- janitor::clean_names(dados_es)

dados_es$municipio <- 
  iconv(dados_es$municipio, from = 'UTF-8', to = 'ASCII//TRANSLIT') %>%
  toupper()
```

Podemos checar se todos os municipios da base de dados estão nos dois
bancos utilizando a função `anti_join`.

``` r
municipios_nao_encontrados <- mapa_es@data %>%
  anti_join(dados_es) %>% 
  select(municipio)
municipios_nao_encontrados
```

    ## [1] municipio
    ## <0 rows> (or 0-length row.names)

Como o resultado não retornou nenhum dado, significa que todos os
valores do banco de dados `mapa_es@data` foram encontrados no banco de
dados `dados_es`.

Podemos fazer a fusão dos dois bancos de dados, usando a função
`left_join` para manter a nossa base de dados nos mapas intacta. Mais
sobre fusão de bases em posts aqui no futuro\!

``` r
mapa_es@data <- mapa_es@data %>%
  left_join(dados_es)
```

Para usar os gráficos do `ggplot2` devemos transformar o objeto
`mapa_es` que é inicialmente da classe `SpatialPolygonsDataFrame`.
Podemos fazer isso da seguinte forma:

``` r
# criando uma variável identificadora de cada municipio
mapa_es@data$id = rownames(mapa_es@data)

# criando uma base de dados a partir do objeto mapa_es
mapa_es_pontos = ggplot2::fortify(mapa_es, region = "id")

# fazendo a junção desses pontos com todas as informações em mapa_es@data
mapa_es_df = dplyr::inner_join(mapa_es_pontos, 
                                   mapa_es@data, 
                                   by = "id")

# Retirando ilhas de Trindade e Martim Vaz
mapa_es_df <- mapa_es_df %>%  
  filter(long < - 36)
```

``` r
ggplot(mapa_es_df) + theme_minimal() +
  geom_polygon(aes(x = long, y = lat, group = group,  
                   fill = populacao_estimada_pessoas_2020)) +
  geom_path(aes(long, lat, group = group), color = "black") + 
  coord_equal() + 
  theme_minimal() + 
  scale_fill_viridis_c("População estimada em 2020") +
  theme(legend.position = 'bottom')
```

![](mapas_da_estatistica_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

Para diminuir a diferença entre os municípios da região da Grande
Vitória para os demais, poderíamos fazer o gráfico com a escala
logarítmica também.

``` r
ggplot(mapa_es_df) + theme_minimal() +
  geom_polygon(aes(x = long, y = lat, group = group,  
                   fill = log(populacao_estimada_pessoas_2020))) +
  geom_path(aes(long, lat, group = group), color = "black") + 
  coord_equal() + 
  theme_minimal() + 
  scale_fill_viridis_c("Log(população estimada) em 2020") +
  theme(legend.position = 'bottom')
```

![](mapas_da_estatistica_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

De maneira geral, nota-se uma grande diferença entre a população em
torno da capital Vitória, com os municípios de Serra, Vila Velha e
Cariacica com grande destaque. Note que se tivéssemos a informação da
população ao longo dos anos poderíamos fazer uma animação da evolução da
população ao longo do tempo, conforme explicado em [post
anterior](https://daslab-ufes.github.io/estatistica_animada/) sobre
animações.

Outra informação disponível nesse banco de dados é a mortalidade
infantil. O seu gráfico ficaria da seguinte forma, alterando a cor das
linhas das divisas entre os municipios para cinza.

``` r
ggplot(mapa_es_df) + theme_minimal() +
  geom_polygon(aes(x = long, 
                   y = lat, 
                   group = group,  
                   fill = 
                     mortalidade_infantil_obitos_por_mil_nascidos_vivos_2017)) +
  geom_path(aes(long, lat, group = group), color = "grey", size = 0.1) + 
  coord_equal() + 
  theme_minimal() + 
  scale_fill_viridis_c("Mortalidade infantil \n Óbitos por mil nascidos (2017)")
```

![](mapas_da_estatistica_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

Para esse gráfico não parece haver uma correlação espacial muito forte,
pois não observamos nenhum tipo de padrão muito forte, com exceção de
uma taxa de mortalidade maior em alguns municípios no noroeste do
Estado.

Esses gráficos com o ggplot apresentam uma melhoria com relação ao
`plot` feito de forma direta no objeto da classe
`SpatialPolygonsDataFrame`, porém ainda não temos que recorrer ao banco
de dados para saber qual é aquel município com maior taxa de mortalidade
infantil.

Uma alternativa é construir mapas com a ajuda do pacote `leaflet`, que
produz gráficos interativos que ajudam a entender a informação de
maneira direta. Antes de tudo precisamos fazer uma alteração no sistema
de coordenadas de latitude e longitude usando a função `spTransform`.

``` r
# Transformando o formato de latitude e longitude
es_ll <- spTransform(mapa_es, CRS("+init=epsg:4326"))
```

Primeiramente, podemos selecionar quais informações gostaríamos de
apresentar quando passarmos o mouse por cima de cada município. Para
isso, vamos criar o objeto `texto` da seguinte forma.

``` r
# alterando nome das variáveis.
es_ll@data <- es_ll@data %>% 
  rename(
    pop_estimada = populacao_estimada_pessoas_2020,
    mort_infantil = mortalidade_infantil_obitos_por_mil_nascidos_vivos_2017,
    pib_percapita = pib_per_capita_r_2018,
    idhm = idhm_span_indice_de_desenvolvimento_humano_municipal_span_2010)
         
texto <- paste(
  "Municipio: ", es_ll@data$municipio,"<br/>", 
  "População estimada (2020): ", es_ll@data$pop_estimada, "<br/>", 
  "Mortalidade infantil (2017): ", es_ll@data$mort_infantil, "<br/>",
  "PIB per capita (2018): ", es_ll@data$pib_percapita, "<br/>",
  "IDHM: ", es_ll@data$letalidade, "<br/>",
  sep = "") %>%
  lapply(htmltools::HTML)
```

Depois, podemos criar a paleta de cores que o pacote leaflet vai usar de
acordo com a variável que gostaríamos de plotar. Vamos considerar a
título de demonstração a variável mortalidade.

``` r
minha_paleta <- colorNumeric(palette = "viridis", 
                            domain = es_ll@data$mort_infantil, 
                            na.color = "transparent")
```

Em seguida, podemos fazer o gráfico utilizando o `leaflet` da seguinte
maneira.

``` r
leaflet() %>% 
  addTiles()  %>% 
  setView(lat = -19.6, lng = -40.97, zoom = 7) %>%
  addPolygons(data = es_ll, 
              fillColor = ~ minha_paleta(mort_infantil), 
              stroke = TRUE, 
              fillOpacity = 0.9, 
              color = "white", 
              weight = 0.3,
              label = texto,
              labelOptions = labelOptions( 
                style = list("font-weight" = "normal", padding = "3px 8px"), 
                textsize = "13px", 
                direction = "auto"
              )) %>%
  addLegend(data = es_ll, 
            pal = minha_paleta, 
            values = ~ mort_infantil, 
            opacity = 0.9, 
            title = "Mort. infantil", 
            position = "bottomleft")
```

<object class="leaflet html-widget" style="width:480px;height:480px;" data="/assets/files/graf_es.html"></object>

<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>

Agora podemos passar o cursor por cima dos municípios e descobrir, por
exemplo, que o município com alta taxa de mortalidade se chama Ponto
Belo e tem população estimada em cerca de 27 mil pessoas. Note também
que é possível fazer *zoom* no gráfico, o que pode ser importante se
fizermos um gráfico de uma região muito grande.

Diversas opções da função `addPolygons` não foram discutidas aqui, porém
deixamos para cada pessoa *brincar* com essas opções e ver o resultado
para checar o que pode ser mais interessante. Deixamos esses valores
segundo exemplos em que já testamos essas configurações e elas
apresentaram resultados razoáveis.

De maneira geral, qualquer informação que possa ser representada por um
*shapefile* pode ser analisada em gráficos como fizemos aqui. Por
exemplo, considerando a separação por bairros na cidade de Vitória, o
Observatório Capixaba da COVID-19 nas Favelas (OCOFA) analisa dados de
letalidade na pandemia do novo coronavirus nos diferentes bairros.
Exemplos podem ser vistos [aqui](http://ocofa.org/mapas.html). Além
disso, ao invés de considerar a informação por municípios, também
poderíamos fazer mapas com as divisões por estados.

Esperamos que tenham gostado de aprender como apresentar estatísticas em
formas de mapas e continuaremos escrevendo sobre outros assuntos
relevantes aqui no blog.
