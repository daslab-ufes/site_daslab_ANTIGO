---
layout: single
title:  "Como construir gráficos com ggplot2"
author: Flavia de Jesus
---

O R é muito utilizado para visualização exploratória de dados. Nele já
vem instalado um pacote base para plotagem de gráficos, porém existem
outros como `grid`, `lattice` e `ggplot2`. Neste post veremos apenas
sobre o `ggplot2`, um pacote que faz parte do `tidyverse`, conforme
nosso [post anterior](https://daslab-ufes.github.io/tidyverse/) e que
nos ajuda a criar gráficos poderosos no `R`. Ele é estruturado de forma
que os gráficos são construídos através de camadas, o que facilita criar
gráficos relativamente complexos e esteticamente agradáveis usando uma
sintaxe intuitiva e fácil de lembrar. As camadas do `ggplot2`são
formadas pelos dados, mapeamentos estéticos, objetos geométricos,
facetas, coordenadas entre outros.

Os gráficos `ggplot2` funcionam apenas com objetos do tipo `data.frame`
ou `tidy`. Caso os dados que forem utilizados não estejam organizados,
existem algumas funções que podem ajudar, e o pacote ideal é o
[tidyr](https://daslab-ufes.github.io/tibble-tidyr/).

Para esse post, os pacotes utilizados são `ggplot2` e `gridExtra`.

### `Sintaxe básica`

No `ggplot2` começamos um gráfico com a função `ggplot()` e a partir
dessa função podem ser adicionadas camadas. Todos os gráficos do
`ggplot2` são compostos por três componentes básicos:

1.  Os dados.
2.  Um conjuntos de mapeamentos estéticos entre as variáveis.
3.  Uma camada indicando o formato geométrico do gráfico.

Um exemplo geral da organização no `ggplot2` é:

``` r
ggplot(data, aesthetics +
  geometries()
```

Para começar a entender como cada camada se comporta, vamos construir um
gráfico parte por parte. Iniciando ao criar um `data.frame` para ser
nossos dados.

``` r
dados <- tibble(var_x = 1:4,
                var_y = seq(2, 8, 2),
                var_grupo = c(rep("a", 3), "b"))
dados
```

    ## # A tibble: 4 x 3
    ##   var_x var_y var_grupo
    ##   <int> <dbl> <chr>    
    ## 1     1     2 a        
    ## 2     2     4 a        
    ## 3     3     6 a        
    ## 4     4     8 b

A primeira camada do `ggplot()` é composta pelos dados, porém quando
executamos apenas os dados o R printa apenas um quadro vazio.

``` r
ggplot(dados)
```

![](/assets/images/post_ggplot2/unnamed-chunk-4-1.png)<!-- -->

A segunda camada do `ggplot()` é composta pelos mapeamentos estéticos,
aqui é onde entram as variáveis que serão as coordenadas do gráfico. O
argumento de mapeamento é sempre pareado com `aes()`, e os argumentos x
e y de `aes()` especificam quais variáveis mapear para os eixos x e y.

``` r
 ggplot(dados, aes(x = var_x, y = var_y))
```

![](/assets/images/post_ggplot2/unnamed-chunk-5-1.png)<!-- -->

Com o acréscimo das coordenadas, o `ggplot()` mapeia com as variáveis
selecionadas. A próxima camada é feita com o formato geométrico. Neste
exemplo vamos usar o formato de pontos, `geom_point()`.

``` r
ggplot(dados, aes(x = var_x, y = var_y)) +
  geom_point()
```

![](/assets/images/post_ggplot2/unnamed-chunk-6-1.png)<!-- -->

Com esta útima camada básica formamos um gráfico de dispersão.

A partir desses componentes básicos podemos acrescentar cores, facetas,
formatos, temas e outras características aos nossos gráficos.

``` r
ggplot(data, aesthetics) +
    geometries(statistics) +
    facets +
    coordinates +
    theme
```

A cada camada que formos adicionando ao nosso gráfico é necessário
utilizar o símbolo de adição (**+**).

### `Mapeamentos Estéticos`

Para adicionar algumas características ao nosso gráficos, vamos utilizar
o banco de dados `iris` que faz parte do pacote base do R. Alguns
mapeamentos estéticos são:

  - `x` e `y`: coordenadas x e y que serão mapeadas;
  - `color`: Altera a cor do gráfico;
  - `fill`: altera a cor do preenchimento do gráfico;
  - `size`: altera o tamanho do formato geométrico;
  - `alpha`: altera a transparência do formato geométrico;
  - `labels`: altera o nome das observações;
  - `shape`: altera o estilo do formato geométrico;

Há duas maneiras de adicionar cor em um ggplot, a primeira é adicionando
uma cor em todo o gráfico. <!-- A cor é adicionada dentro do `aes`.  -->
A segunda forma é colorindo uma variável específica.

``` r
ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) +  
  geom_point(color = "deeppink4") 
```

![](/assets/images/post_ggplot2/unnamed-chunk-8-1.png)<!-- -->

``` r
ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) +  
  geom_point() 
```

![](/assets/images/post_ggplot2/unnamed-chunk-9-1.png)<!-- -->

Neste segundo exemplo, adicionamos a variável `Species` como uma escala
de cores no gráfico. A legenda de cores atribui a cada ponto uma cor
correspondente a sua classe dentro da variável `Species`.

Um outro atributo estético interessante é o `shape`. Ele modela os
pontos em diferentes formatos geométricos para cada variável.

``` r
ggplot(iris, aes(x = Petal.Length, y = Petal.Width, shape = Species)) + 
  geom_point(color = "blue") 
```

![](/assets/images/post_ggplot2/unnamed-chunk-10-1.png)<!-- -->

Podemos também utilizar uma variável numérica para alterar o tamanho dos
pontos:

``` r
ggplot(iris, aes(x = Petal.Length, y = Petal.Width, size = Sepal.Length)) + 
  geom_point(color = "red")
```

![](/assets/images/post_ggplot2/unnamed-chunk-11-1.png)<!-- -->

### `Formatos Geométricos`

No `ggplot2` existem vários formatos geométricos, porém veremos apenas
alguns. Os objetos geométricos começam com a expressão `geom_` e são
seguidos pelo tipo de objeto.

  - `geom_point()` é usado para criar gráficos de dispersão.
  - `geom_bar()` Mostra a distribuição de variáveis categóricas.
  - `geom line()` desenham linhas entre os pontos do gráfico.
  - `geom_boxplot()` exibe de forma compacta a distribuição de uma
    variável contínua.
  - `geom_histogram()` mostram a distribuição de variáveis contínuas.

Um formato geométrico muito utilizado na estatística descritiva e nas
análises exploratórias é o `Boxplot`. Os `boxplots` resumem a maior
parte da distribuição com apenas cinco estatísticas: o mínimo, o
primeiro quartil (Q1), a mediana, o terceiro quartil (Q3) e o máximo. O
diagrama de caixa, ou `boxplot`, permite realizar análises mais
detalhadas em uma variável numérica por meio de quartis. Além disso, o
gráfico de caixa oferece informações da distribuição como valores
atípicos e valores extremos, entre outros. Neste exemplo abaixo,
utlizamos as variáveis `drv`e `hwy` para criar nosso gráfico.

``` r
ggplot(mpg, aes(drv, hwy)) +
  geom_boxplot()
```

![](/assets/images/post_ggplot2/unnamed-chunk-12-1.png)<!-- -->

Histogramas e polígonos de frequência mostram a distribuição de uma
única variável numérica. A diferença entre eles é que os histogramas
exibem as contagens com barras enquanto os polígonos de frequência
exibem as contagens com linhas.

``` r
ggplot(mpg, aes(hwy)) + geom_histogram()
```

![](/assets/images/post_ggplot2/unnamed-chunk-13-1.png)<!-- -->

O gráfico de barras utiliza retângulos para representar a frequência de
variável(is) qualitativa(s), sendo que o comprimento das barras é
proporcional ao valor que ele está representando. A função `geom_bar()`
plota variáveis categóricas. O que a barra representa é simplesmente a
contagem das diferentes categorias.

``` r
ggplot(mpg, aes(class)) + geom_bar(width = .75)
```

![](/assets/images/post_ggplot2/unnamed-chunk-14-1.png)<!-- -->

O `width` é utilizado para definir a largura das barras.

Por último temos os gráficos de linhas. Eles podem ser utilizados para
dados de séries temporais. O `geom_line()` geralmente possui o tempo no
eixo x, mostrando como uma única variável mudou ao longo do tempo. Para
este exemplo vamos usar os dados `economics`.

``` r
head(economics)
```

    ## # A tibble: 6 x 6
    ##   date         pce    pop psavert uempmed unemploy
    ##   <date>     <dbl>  <dbl>   <dbl>   <dbl>    <dbl>
    ## 1 1967-07-01  507. 198712    12.6     4.5     2944
    ## 2 1967-08-01  510. 198911    12.6     4.7     2945
    ## 3 1967-09-01  516. 199113    11.9     4.6     2958
    ## 4 1967-10-01  512. 199311    12.9     4.9     3143
    ## 5 1967-11-01  517. 199498    12.8     4.7     3066
    ## 6 1967-12-01  525. 199657    11.8     4.8     3018

``` r
ggplot(economics, aes(date, uempmed)) + geom_line()
```

![](/assets/images/post_ggplot2/unnamed-chunk-16-1.png)<!-- -->

### `Facetas`

Uma outra técnica para adicionar camadas aos nossos gráficos é o
*facetting*. Ele divide os dados em subconjuntos e, a seguir, plota cada
subconjunto em um painel diferente. Há três tipos de facetas:

  - `facet_null():` Plota um único gráfico.
  - `facet_wrap():` Forma uma matriz de painéis definidos por variáveis
    na forma de linhas e colunas.
  - `facet_grid():` Envolve uma sequência de painéis.

Para estes exemplos vamos usar os dados `mpg()`.

``` r
ggplot(mpg, aes(as.factor(cyl))) + 
  geom_bar() +
  facet_wrap(~class)
```

![](/assets/images/post_ggplot2/unnamed-chunk-17-1.png)<!-- -->

``` r
ggplot(mpg, aes(as.factor(cyl))) + 
  geom_bar() +
  facet_grid(~class)
```

![](/assets/images/post_ggplot2/unnamed-chunk-18-1.png)<!-- -->

### `Coordenadas`

Existem vários tipos de coordenadas cartesianas. Algumas são:

  - `coord_flip()` Sistema de coordenadas cartesianas com x e y
    invertidos.
  - `coord_fixed()` Sistema de coordenadas cartesianas com proporção
    fixa.
  - `coord_map()` Projeções de mapas.

A função `coord_flip()` inverte as posições x e y:

``` r
boxplot <- ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

boxplot_flip <- ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

grid.arrange(boxplot, boxplot_flip, ncol = 2)
```

![](/assets/images/post_ggplot2/unnamed-chunk-19-1.png)<!-- -->

Na primeira imagem foi plotado um boxplot com as coordenadas x = class e
y = hwy. Na segunda imagem foi aplicada `coord_flip()` que invertiu as
posições. A função `grid.arrange` foi utilizada para juntar os gráficos
lado a lado.

Uma outra coordenada interessante é a `coord_fixed()`. Com ela é
possível fixar uma proporção desejada. A proporção representa o número
de unidades no eixo y equivalente a uma unidade no eixo x. Vamos ver
alguns exemplos:

``` r
f <- ggplot(data = mpg, mapping = aes(x = cty)) +
      geom_bar()

fixed1 <- f + coord_fixed(ratio = 1/5)
fixed2 <- f + coord_fixed(ratio = 5)
fixed3 <- f + coord_fixed(ratio = 1)

grid.arrange(f, fixed1, fixed2, fixed3, ncol = 2)
```

![](/assets/images/post_ggplot2/unnamed-chunk-20-1.png)<!-- -->

O primeiro gráfico está com a proporção normal, sem nenhuma alteração. O
segundo gráfico foi fixado uma proporção de 1/5, isso faz com que a
imagem fique achatada, pois os valores de y diminuem, enquando no
terceiro exemplo o gráfico está mais alongado pois foi fixada uma
proporção maior. No último plot, a proporção = 1 garante que uma
unidade no eixo x tenha o mesmo comprimento que uma unidade no eixo y.

Com a `coord_fixed()` também podemos fixar uma faixa de valores que
queremos que tenha em cada coordenada, por exemplo, o gráfico `f`
plotado anteriormente, possui a coordenada x indo de 9 até 35, porém
queremos visualizar apenas as informações de 15 até 30 unidades, podemos
utilizar o argumento `xlim` para limitar nosso x. E se quisermos limitar
o nosso y, utilizaremos o argumento `ylim`.

``` r
f + coord_fixed(xlim = c(15, 20))
```

![](/assets/images/post_ggplot2/unnamed-chunk-21-1.png)<!-- -->

``` r
f + coord_fixed(ylim = c(20, 30))
```

![](/assets/images/post_ggplot2/unnamed-chunk-21-2.png)<!-- -->

O próximo exemplo é com `coord_quickmap()`. Essa função é usada para
desenhar mapas. Nesse próximo exemplo vamos utilizar o pacote `maps` e a
função `map_data`.

``` r
mundo <- map_data("world")
mapa_mundo <- ggplot(mundo, aes(long, lat, group = group)) +
  geom_line() +
  coord_quickmap()
mapa_mundo
```

![](/assets/images/post_ggplot2/unnamed-chunk-22-1.png)<!-- -->

No primeiro momento, a função `map_data` transfomou os dados `world` em
um data.frame adequado para o gráfico. Para fazer o plot foi utilizado
`geom_line()`, mas outras geoms também poderiam ser utilizadas, como
`geom_path()` ou `geom_point()`.

### `Temas`

Os temas controlam a exibição de todos os elementos que não são de dados
da plotagem. Podemos substituir todas as configurações por um tema
completo ou optar por ajustar configurações individuais usando `theme()`
e as funções `element_`. Alguns exemplos de configurações individuais
são:

  - `element_line ()` - modifica a aparência das linhas;
  - `element_text ()` - modifica a estrutura do texto;
  - `element_blank ()` - não desenha nada e não atribui espaços;
  - `element_rect ()` - desenha retângulos, usados principalmente para
    fundos.
  - `theme ()` - modifica o Layout do
gráfico.

<!-- end list -->

``` r
ggplot(data = mpg, mapping = aes(x = cty, y = hwy, color = factor(cyl))) +
  geom_point() +
  labs(title = "Temas") +
  theme(plot.title = element_text(face = "bold", colour = "red")) +
  theme(panel.grid.major = element_line(linetype = "dotted", colour = "black")) 
```

![](/assets/images/post_ggplot2/unnamed-chunk-23-1.png)<!-- -->

Neste exemplo aplicamos apenas alguns temas como a característica das
linhas e o título. porém há muitas outras funções para serem exploradas.
Para mais detalhes sobre temas, clique
[aqui](https://ggplot2.tidyverse.org/reference/theme.html).

Com este post podemos perceber que o `ggplot2` é um pacote bastante
intuitivo. É necessário apenas aprender as camadas, os argumentos e ir
adicionando e criando o gráfico da forma que desejar. O que vimos aqui é
apenas uma pequena fração do que podemos usurfruir deste pacote. Este
foi o primeiro passo, porém teremos uma continuação deste post com
gráficos mais completos e mais elegantes. Espero que tenham gostado do
post e até o próximo\!

### `Referências`

<https://r4ds.had.co.nz/data-visualisation.html#first-steps>

<https://ggplot2-book.org/index.html>
