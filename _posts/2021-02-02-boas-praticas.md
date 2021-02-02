---
layout: single
title:  "Boas práticas no software R"
author: Pedro de Brito Neto
---

Tenho certeza que você já tentou ler algum código, talvez até mesmo um
código seu antigo, e se embolou no meio do script, não conseguiu
entender alguma função e ficou por isso mesmo… Enfim, muitas vezes
pessoas escrevem um código sem imaginar que outra pessoa poderá lê-lo ou
que poderá usá-lo novamente no futuro e não irá entender mais nada. Por
isso, existem o que chamamos de boas práticas na programação.

Boas práticas, em resumo, são dicas que servem para que você possa
produzir um código mais organizado e padronizado, que permitirá que
outras pessoas ou até mesmo você daqui a um tempo, consiga entendê-lo
sem dificuldades. Daqui pra frente você poderá criar ou editar os
códigos de uma maneira que ele fique mais fácil de se ler, entender e
fazer possíveis alterações. Então vamos para as dicas:

### Nomes dos objetos

  - Nomes de variáveis e funções devem usar apenas letras minúsculas,
    números e \_. Não use letras maiúsculas ou caracteres especiais.

<!-- end list -->

``` r
# bom
trabalho_estatistica_3

primeiro_mes

# ruim
Trabalho de estatística 3

 Primeiro_MÊS
```

  - Evite usar nomes comuns para atribuir alguma variável, nomes de
    funções ou variáveis já existentes. Isso pode confundir futuros
    leitores do seu código

<!-- end list -->

``` r
mean <- mean(dados)

desvio_padrao <-  sd(dados)

p <- x
```

### Espaçamento

  - É sempre bom colocar um espaço depois (e somente depois) de uma
    vírgula.

<!-- end list -->

``` r
# sempre 
(1, 2, 3)
[pedro, 4, x]

# nunca
(1,2,3)
[pedro , joao ,3]
```

### Parênteses

  - Não coloque espaços imediatamente antes ou depois dos parênteses,
    isso pode prejudicar o entendimento e até mesmo não executar a
    função desejada

<!-- end list -->

``` r
# sempre
filter(dados, mes == "janeiro")

# nunca
filter (dados, mes == "janeiro")
filter( dados, mes == "janeiro" )
```

### Blocos de código

  - Os colchetes `{}` definem a hierarquia mais importante do R. Para
    facilitar a visualização dessa hierarquia devemos seguir alguns
    passos.

  - `{` deve ser o último caractere da linha.

  - O conteudo deve ser recuado por dois espaços.

  - `}` deve ser o primeiro caractere da linha

<!-- end list -->

``` r
# sempre 
if (x < mean(dados)) {
  message("x está abaixo da média")
}

if (y == 0) {
  if (x > 0) {
    log(x)
  } else {
    message("x é negativo ou zero")
  }
} else {
  y^x
}
  
# nunca 
if (x < mean(dados)) {
message("x está abaixo da média")
}

if (y == 0)
{
  
 if (x > 0) {
   log(x)
 } else {
  message("x é negativo ou zero") 
   }
  } else {y^x}
```

### Atribuição

  - Sempre use `<-` e não `=` para qualquer atribuição.

<!-- end list -->

``` r
# sempre 
x <- 1

# nunca
x = 1
```

### Textos

  - Sempre opte por usar aspas duplas `""` para citar textos ao invés de
    aspas simples `''`. A não ser que o texto já possua aspas duplas.

<!-- end list -->

``` r
# sempre 
"qualquer texto"
'qualquer "texto"'

# nunca 
'qualquer texto'
```

### Vetores lógicos

  - O R permite que você use `T` para true e `F` para false, entretanto,
    sempre opte por usar a palavra completa, `TRUE` e `FALSE`.

### Comentários

  - Como já sabemos, é possível fazer “comentários” dentro do código
    (basta usar `#`). No código de análise de dados, use comentários
    para registrar descobertas importantes e decisões de análise. Se
    você precisar de comentários para explicar o que seu código está
    fazendo, considere reescrever seu código para ficar mais claro.

### Pipe

  - O pipe “`%>%`” é uma função bastante utilizada no R. Sempre o use
    para enfatizar uma sequência de ações, em vez do objeto no qual as
    ações estão sendo realizadas e o evite usar quando estiver
    manipulando mais de um objeto por vez.

  - Deve sempre ter um espaço antes dele e geralmente deve ser seguido
    por uma nova linha. Após isso, cada linha deve ser recuada por dois
    espaços (o editor do RStudio faz isso automaticamente ao pular de
    linha). Essa estrutura do pipe torna mais fácil adicionar novas
    etapas e mais difícil ignorar outra.

  - Um pipe de uma única etapa pode permanecer em uma linha, a não ser
    que você planeje expandi-lo posteriormente

# longas filas

  - Se os argumentos de uma função não couberem todos em uma linha,
    coloque cada argumento em sua própria linha e o idente.

<!-- end list -->

``` r
dados %>% 
  group_by(Species) %>% 
  summarise(
    Sepal.length = mean(Sepal.length),
    Sepal.Width = mean(Sepal.Width),
    Species = n_distinct(Species)
  )
```

# ggplot

### Introdução

  - As sugestões de estilo `+` usadas para separar camadas do ggplot2
    são muito semelhantes àquelas para `%>%` pipe.

### Espaçamento e longas filas

  - Sempre coloque um espaço antes do `+`, além disso, sempre que o
    utilizar, siga para uma nova linha. Não coloque mais de uma camada
    do gráfico na mesma linha, mesmo que o gráfico tenha apenas duas
    camadas. Outra coisa importante, se o argumento for muito grande
    para apenas uma linha, coloque cada argumento em uma linha.

<!-- end list -->

``` r
# sempre
ggplot(letalidade) + 
  geom_col(aes(x = raca_cor, y = taxa_l, fill = sexo), position = "dodge") +
  labs(x = "Pessoas",
       y = "Letalidade (%)",
       title = "Taxa de letalidade da COVID-19 no ES") +
  scale_fill_viridis_d() +
  theme_bw() 

# nunca

ggplot(letalidade) + 
  geom_col(aes(x = raca_cor, y = taxa_l, fill = sexo), position = "dodge") + labs(x = "Pessoas", y = "Letalidade (%)", title = "Taxa de letalidade da COVID-19 no ES") + scale_fill_viridis_d() + theme_bw()
```

### Filtragem

  - é possível fazer filtragem e manipulação dos dados dentro das
    funções do ggplot. Ao invés disso, faça todas as manipulações
    necessárias antes. Você pode inclusive usar o pipe `%>%`.

<!-- end list -->

``` r
# sempre
iris %>%
  filter(Species == "setosa") %>%
  ggplot(aes(x = Sepal.Width, y = Sepal.Length)) +
  geom_point()

# nunca
ggplot(filter(iris, Species == "setosa"), aes(x = Sepal.Width, y = Sepal.Length)) +
  geom_point()
```

### Dicas

  - A função `attach()` no R pode ser usada para tornar objetos dentro
    de dataframes acessíveis na área de trabalho com menos
    pressionamentos de tecla. Essa função, em contrapartida, tem uma
    grande chance de causar erros no seu código. Evite usá-la.

  - O editor do RStudio possui uma função que irá formatar seu código
    com algumas boas práticas, como espaçamento, pontuação, quebra de
    linhas e etc. Basta selecionar a parte do código desejada e utilizar
    `ctl + shift + a`.

  - Não coloque `;` no final de uma linha e não use `;` para colocar
    vários comandos em uma linha. O `;` serve para que você quebre a
    linha do seu código sem precisar dar enter.

# Finalização

Vale lembrar que essas foram apenas algumas das inúmeras dicas de boas
práticas existentes, mas praticando essas você já irá construir um
código muito bem estruturado e de fácil entendimento. No futuro iremos
postar uma playlist com vídeos curtos no nosso canal no youtube a
respeito dessas boas práticas.

Basta clicar
[AQUI](https://www.youtube.com/channel/UCEt4wnd1SUqp7EJLe3vbISA) para
ter acesso direto ao canal.

# **Referências**

<https://style.tidyverse.org/>

<https://google.github.io/styleguide/Rguide.html>
