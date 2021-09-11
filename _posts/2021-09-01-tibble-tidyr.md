---
layout: single
title:  "Como organizar seu banco de dados com tibble e tidyr"
author: Flavia de Jesus
---

Bases de dados, geralmente, são composta por informações de diversas
classes: numérica, fatores e strings. Uma maneira de guardar todas essas
informações é através dos `data.frame`s. Os `data.frame`s são objetos do
tipo banco de dados e são organizados em linhas e colunas. Um formato
melhorado dos `data.frame`s são os `tibble`s. Eles foram criados com o
objetivo de facilitar a nossa vida. Apesar de terem muitas vantagens,
principalmente na apresentação dos dados, nem sempre nossos `tibble`s
estão organizados. Uma maneira de resolver este problema é usando um
pacote de organização de dados, o `tidyr`. Em uma postagem anterior,
aprendemos a organizar as variáveis e as observações dos nossos dados
com o [dplyr](https://daslab-ufes.github.io/dplyr/), porém também é
muito importante que nosso conjunto de dados tenha um formato ‘limpo’.
Neste post vamos explorar os `tibble`s e aprender a transformar dados
bagunçados em dados organizados.

Vamos iniciar observando algumas maneiras de criar um `tibble`:

### Como criar um `tibble`?

Para criar um `tibble`, podemos usar a função `as_tibble()`. Esta função
transforma um `data.frame` normal em um `tibble` e faz parte do pacote
`tibble`. Visto que na maioria das vezes temos conjuntos de dados
armazenados como `data.frame`, esta função será útil para transformar
eles em um `tibble`. Vejamos o exemplo
    abaixo:

``` r
library(tibble) ## Carregando o pacote tibble
```

``` r
head(mtcars) ## Visualizando o início do mtcars
```

    ##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

Temos o conjunto de dados `cars` disponível quando carregamos o R, que
está na forma de um `data.frame`. Usamos a função `as_tibble()` para
transformar este `data.frame` em um `tibble` e imprimi-lo. Vamos ver a
saída deste código conforme mostrado abaixo:

``` r
as_tibble(mtcars)
```

    ## # A tibble: 32 x 11
    ##      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
    ##    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ##  1  21       6  160    110  3.9   2.62  16.5     0     1     4     4
    ##  2  21       6  160    110  3.9   2.88  17.0     0     1     4     4
    ##  3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
    ##  4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
    ##  5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
    ##  6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1
    ##  7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
    ##  8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
    ##  9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
    ## 10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4
    ## # … with 22 more rows

Podemos perceber que há algumas diferenças entre as duas saídas. No
`tibble` os rownames são substituídos por índices, são impressos a
classe de cada coluna e também a dimensão do `tibble`.

Uma outra característica interessante é que `tibbles` sempre imprimem as
primeiras dez linhas com o número de colunas que cabem em seu console.
Este recurso funciona muito bem quando você está lidando com um grande
conjunto de dados.

Também podemos criar um `tibble` do zero, ou seja, nem sempre precisamos
de um data.frame já criado para gerar um `tibble`. Podemos usar a função
`tibble()`.

``` r
tibble1 <- tibble( a = 1:5, 
                   b = 10,
                   c = a * 2 + b
)

print(tibble1)
```

    ## # A tibble: 5 x 3
    ##       a     b     c
    ##   <int> <dbl> <dbl>
    ## 1     1    10    12
    ## 2     2    10    14
    ## 3     3    10    16
    ## 4     4    10    18
    ## 5     5    10    20

Aqui neste exemplo, criamos um objeto do tipo `tibble` chamado `tibble1`
usando a função `tibble()`. Repare que a entrada para a variável *a* é
uma sequência de comprimento igual a cinco, enquanto a variável *b*
possui comprimento um. Nos `tibble`s, assim como na criação de
`data.frame`s, qualquer entrada de comprimento menor (`b`) do que a
entrada de maior comprimento (`a`) pode ter seus valores reciclados.
Observe que apenas a variável `b` com comprimento um é reciclada.

Um outro aspecto interessante dos `tibble`s é que no R não poderíamos
ter nomes de variáveis que contenham caracteres especiais, começando com
números, contendo espaços e símbolos. No entanto, utilizando um
`tibble`s temos a liberdade de usar esses nomes de variáveis, apenas
precisamos incluir dentro de crases **\`**. Veja um exemplo abaixo:

``` r
tibble2 <- tibble( `1*vetor` = 1000,
                   `:)` = "Sorriso",
                   `@ ` = "!"
)
tibble2
```

    ## # A tibble: 1 x 3
    ##   `1*vetor` `:)`    `@ ` 
    ##       <dbl> <chr>   <chr>
    ## 1      1000 Sorriso !

### `Tribble`

Também podemos usar a função `tribble()` para criar um `tibble`. Nesta
função os nomes das variáveis podem ser adicionados verticalmente (como
colunas no Excel) usando o sinal (‘~’) e abaixo de cada nome de
variável, podemos adicionar os valores associados a cada uma delas.

``` r
tibble3 <- tribble(
     ~f,  ~g,  ~h,
     #--|---|----|
     1, "a", 82.7,
     2, "b", 54.3,
)
print(tibble3)
```

    ## # A tibble: 2 x 3
    ##       f g         h
    ##   <dbl> <chr> <dbl>
    ## 1     1 a      82.7
    ## 2     2 b      54.3

Neste código, a função `tribble()` nos ajuda a criar um `tibble` com
três variáveis chamadas “f”, “g” e “h”, respectivamente. O comentário
abaixo nos cabeçalhos é apenas para mostrar a separação entre valores da
variável e o seu nome. Abaixo disso, temos os valores associados a cada
variável separados por vírgula horizontalmente.

O formato `tibble` é utilizado em vários pacotes. Todos os pacotes do
`tidyverse` são projetados para trabalhar com `tibbles`. Destaca-se o
`dplyr` que utiliza `tibbles` no formato **tidy**. Um outro pacote em
especial, que utiliza o formato `tibbles`, é o `tidyr`. Este pacote se
baseia na suposição de que dados arrumados (*tidy*) são aqueles com
formato long (com mais linhas). O outro formato é chamado de wide (com
mais colunas).

Para um conjunto de dados ser reconhecido como *tidy*, é necessário
seguir algumas regras:

1.  Cada variável deve ter sua própria coluna.
2.  Cada observação deve ter sua própria linha.
3.  Cada valor deve ter sua própria célula.

Para entendermos bem como os dados *tidy* funcionam, vamos explorar o
pacote `tidyr`. Este pacote possui muitas funções importantíssimas para
a organização dos nossos dados, porém vamos mostrar exemplos com algumas
funções mais utilizadas, que são: `pivot_longer()`, `pivot_wider()`,
`separate()` e `unite()`.

Vamos começar criando um conjunto de dados simples e desorganizado.
Estes dados vão conter as cidades mais populosas do Espírito Santo e a
quantidade da população.

``` r
dados_cidades <- tribble(
  ~UF, ~Serra, ~VilaVelha, ~Cariacica, ~Vitoria, ~CachoeirodeItapemerim, ~Linhares,
  "ES",  527246, 501325, 383917, 365855, 210589, 176688
)
dados_cidades
```

    ## # A tibble: 1 x 7
    ##   UF     Serra VilaVelha Cariacica Vitoria CachoeirodeItapemerim Linhares
    ##   <chr>  <dbl>     <dbl>     <dbl>   <dbl>                 <dbl>    <dbl>
    ## 1 ES    527246    501325    383917  365855                210589   176688

Note que os dados estão bem desorganizados, há várias observações no
lugar de váriaveis. Para resolver isso vamos começar usando a função
`pivot_longer()`. Ela vai organizar as colunas das cidades em apenas uma
coluna.

Vamos precisar carregar os seguintes pacotes:

``` r
library(tidyr) ## Carregando o pacote tidyr
```

``` r
library(dplyr) ## carregando o pacote dplyr
```

### `pivot_longer()`

A função `pivot_longer()` torna os dados que estão no formato *wide*
(formato do objeto "dados\_cidades) em dados do tipo *long*.

``` r
dados_longer <- dados_cidades %>%
  pivot_longer(
    cols = Serra:Linhares, 
    names_to = "Cidades", 
    values_to = "População"
  ) 

dados_longer
```

    ## # A tibble: 6 x 3
    ##   UF    Cidades               População
    ##   <chr> <chr>                     <dbl>
    ## 1 ES    Serra                    527246
    ## 2 ES    VilaVelha                501325
    ## 3 ES    Cariacica                383917
    ## 4 ES    Vitoria                  365855
    ## 5 ES    CachoeirodeItapemerim    210589
    ## 6 ES    Linhares                 176688

Neste exemplo, primeiro selecionamos as colunas que serão organizadas em
apenas uma, no argumento `cols`. No segundo argumento, `names_to`,
escrevemos o nome que queremos que esta nova coluna tenha, e no terceiro
argumento, `value_to`, é o nome das observações referente a cada cidade.

### `pivot_wider()`

A função `pivot_longer()` deixou nossos dados no formato *long*, mas
podemos usar `pivot_wider()` para retornar ao formato em que foi criado.
Ela recebe argumentos parecidos com a função anterior.

``` r
dados_wider <- dados_longer %>%
  pivot_wider(names_from = "Cidades", values_from = "População")

dados_wider
```

    ## # A tibble: 1 x 7
    ##   UF     Serra VilaVelha Cariacica Vitoria CachoeirodeItapemerim Linhares
    ##   <chr>  <dbl>     <dbl>     <dbl>   <dbl>                 <dbl>    <dbl>
    ## 1 ES    527246    501325    383917  365855                210589   176688

Aqui o argumento `names_from` recebe as observações que serão
espalhadas, no nosso caso, os nomes das cidades. O argumento
`values_from` é o nome da variável que vai ser transfomada em
observações.

### `separate()`

`separate()` tem como objetivo separar uma coluna em várias outras
colunas. Para este exemplo vamos criar um `tibble` com poucas
observações:

``` r
dados <- tibble(
  Nome = c("João", "Pedro", "Amanda", "Fabiano", "Maria", "Gustavo"),
  Altura = c(1.80, 1.77, 1.71, 1.75, 1.66, 1.63),
  Nascimento = c("22-03-1998", NA, "18-02-1999", "20-09-1999", "23-01-1999", "19-09-2004"),
  Sexo = c("masculino", "masculino", "feminino", "masculino", "feminino", "masculino"),
  Peso = c(78.3, 82.1, NA, 88.1, 58.0, 75.4),
  Fumante = c(TRUE, FALSE, FALSE, FALSE, NA, FALSE),
  UF = c("PB", "AL", "PE", "PE", "SP", "CE"),
)
dados
```

    ## # A tibble: 6 x 7
    ##   Nome    Altura Nascimento Sexo       Peso Fumante UF   
    ##   <chr>    <dbl> <chr>      <chr>     <dbl> <lgl>   <chr>
    ## 1 João      1.8  22-03-1998 masculino  78.3 TRUE    PB   
    ## 2 Pedro     1.77 <NA>       masculino  82.1 FALSE   AL   
    ## 3 Amanda    1.71 18-02-1999 feminino   NA   FALSE   PE   
    ## 4 Fabiano   1.75 20-09-1999 masculino  88.1 FALSE   PE   
    ## 5 Maria     1.66 23-01-1999 feminino   58   NA      SP   
    ## 6 Gustavo   1.63 19-09-2004 masculino  75.4 FALSE   CE

A variável `Nascimento` contem observações separadas por um simbolo
(**-**), queremos dividir cada informação em três e criar uma coluna
para cada. Podemos dividir a data de nascimento em `Dia`, `Mês` e `Ano`.

``` r
dados_separate <- dados %>%
  separate(Nascimento, into = c("Dia", "Mes", "Ano"), sep = "-")

dados_separate
```

    ## # A tibble: 6 x 9
    ##   Nome    Altura Dia   Mes   Ano   Sexo       Peso Fumante UF   
    ##   <chr>    <dbl> <chr> <chr> <chr> <chr>     <dbl> <lgl>   <chr>
    ## 1 João      1.8  22    03    1998  masculino  78.3 TRUE    PB   
    ## 2 Pedro     1.77 <NA>  <NA>  <NA>  masculino  82.1 FALSE   AL   
    ## 3 Amanda    1.71 18    02    1999  feminino   NA   FALSE   PE   
    ## 4 Fabiano   1.75 20    09    1999  masculino  88.1 FALSE   PE   
    ## 5 Maria     1.66 23    01    1999  feminino   58   NA      SP   
    ## 6 Gustavo   1.63 19    09    2004  masculino  75.4 FALSE   CE

Repare que no primeiro argumento colocamos a coluna que queríamos
separar e, no segundo argumento, as novas colunas que iríamos criar e,
por fim, o símbolo separador das observações.

### `unite()`

O oposto da função `separate()`, é a função `unite()`. Ela junta várias
colunas em uma. Para exemplificar, vamos retornar nossos dados como
estavam antes, vamos juntar as colunas `Dia`, `Mês` e `Ano` em apenas
uma.

``` r
dados_unite <- dados_separate %>%
  unite(Nascimento, Dia, Mes, Ano, sep = "/")

dados_unite
```

    ## # A tibble: 6 x 7
    ##   Nome    Altura Nascimento Sexo       Peso Fumante UF   
    ##   <chr>    <dbl> <chr>      <chr>     <dbl> <lgl>   <chr>
    ## 1 João      1.8  22/03/1998 masculino  78.3 TRUE    PB   
    ## 2 Pedro     1.77 NA/NA/NA   masculino  82.1 FALSE   AL   
    ## 3 Amanda    1.71 18/02/1999 feminino   NA   FALSE   PE   
    ## 4 Fabiano   1.75 20/09/1999 masculino  88.1 FALSE   PE   
    ## 5 Maria     1.66 23/01/1999 feminino   58   NA      SP   
    ## 6 Gustavo   1.63 19/09/2004 masculino  75.4 FALSE   CE

Quando unimos as datas de nascimento, percebemos que no nascimento do
`Pedro` ficou *NA/NA/NA*, para resolver isso precisamos substituir por
apenas um *NA*. Para modificar vamos utilizar a função `mutate()` do
`dplyr` e uma estrutura condicional **ifelse**.

``` r
dados_unite <- dados_separate %>%
  unite(Nascimento, Dia, Mes, Ano, sep = "/") %>% 
  mutate(Nascimento = ifelse(Nascimento == "NA/NA/NA", NA, Nascimento))

dados_unite
```

    ## # A tibble: 6 x 7
    ##   Nome    Altura Nascimento Sexo       Peso Fumante UF   
    ##   <chr>    <dbl> <chr>      <chr>     <dbl> <lgl>   <chr>
    ## 1 João      1.8  22/03/1998 masculino  78.3 TRUE    PB   
    ## 2 Pedro     1.77 <NA>       masculino  82.1 FALSE   AL   
    ## 3 Amanda    1.71 18/02/1999 feminino   NA   FALSE   PE   
    ## 4 Fabiano   1.75 20/09/1999 masculino  88.1 FALSE   PE   
    ## 5 Maria     1.66 23/01/1999 feminino   58   NA      SP   
    ## 6 Gustavo   1.63 19/09/2004 masculino  75.4 FALSE   CE

Agora sim\! Conseguimos deixar a nossa tabela como estava antes.

Para finalizar, veremos mais uma função do `tidyr`. As funções
relacionadas a dados ausentes são importantíssimas, então pode ser
relevante observar pelo menos uma neste post. A função escolhida é a
`drop_na()`.

### `drop_na()`

Esta função é muito útil quando se está utilizando uma base de dados com
muitos dados faltantes. `drop_na()` irá excluir todas as linhas que
contêm dados faltantes. Nos argumentos desta função, colocamos apenas
as colunas que contêm dados faltantes. Vamos utilizar a mesma tabela de
dados de antes, `dados`, para este exemplo.

``` r
dados %>%
  drop_na(Nascimento, Peso, Fumante)
```

    ## # A tibble: 3 x 7
    ##   Nome    Altura Nascimento Sexo       Peso Fumante UF   
    ##   <chr>    <dbl> <chr>      <chr>     <dbl> <lgl>   <chr>
    ## 1 João      1.8  22-03-1998 masculino  78.3 TRUE    PB   
    ## 2 Fabiano   1.75 20-09-1999 masculino  88.1 FALSE   PE   
    ## 3 Gustavo   1.63 19-09-2004 masculino  75.4 FALSE   CE

Note que, as informações relacionadas ao `Pedro`, a `Amanda` e a `Maria`
foram excluídas da nossa base de dados, pois possuíam algum dado
faltante.

Os dois pacotes explorados neste post fazem parte do `tidyverse`, para
ver outros pacotes deste conjunto, leia este
[post](https://daslab-ufes.github.io/tidyverse/). Para complementar o
que aprendemos hoje e compreender melhor sobre `tidy data` recomendo uma
leitura [aqui](http://vita.had.co.nz/papers/tidy-data.html). Para ver
exemplos de cada uma das funções citadas, você pode olhar a página do
[tibble](https://tibble.tidyverse.org/) e do
[tidyr](https://tidyr.tidyverse.org/index.html) e para explorar as
funções **pivoting** do `tidyr` dê uma olhada nesta **vignette**
[aqui](https://tidyr.tidyverse.org/articles/pivot.html). Espero que
tenham gostado do assunto. Até o próximo post\!

### `Referências`

<https://r4ds.had.co.nz/tibbles.html>

<https://r4ds.had.co.nz/tidy-data.html>

<https://tidyr.tidyverse.org/index.html>