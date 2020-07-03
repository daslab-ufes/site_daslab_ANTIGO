---
layout: single
title:  "Analisando o melhor canal do YouTube"
author: Agatha Rodrigues
---

O canal **Meteoro Brasil** é o melhor canal do YouTube, segundo a opinião desta que aqui escreve. De acordo com a descrição do próprio [canal](https://www.youtube.com/channel/UCk5BcU1rOy6hepflk7_q_Pw), o Meteoro é um canal sobre cultura pop, ciência e filosofia. Mas eu diria que é mais que isso. A Mulher Mais Sábia e o Cara Mais Simples (donos do canal) conectam esses temas de maneira brilhante e com bastante sensibilidade. Para exemplificar meu ponto, dentre muitos vídeos ótimos do canal, destaco o vídeo [Emicida Celebra Você](https://www.youtube.com/watch?v=4y411GG_pfA), que analisa a poderosa música "AmarElo" do Emicida e a presença nela dos versos potentes de Belchior (falaremos mais desse cara mais pra frente), e o vídeo [Tentando Lidar com as Circunstâncias](https://www.youtube.com/watch?v=31gvTYL8U38). Sobre este último, apenas deixo como um pequeno *spoiler* um trecho do poema de Rainer Maria Rilke: 

> "Deixe tudo acontecer com você: beleza e terror. <br>
> Apenas continue. <br>
> Nenhum sentimento é final"<br>

(uma lembrança para uma amiga muito especial).

[![Watch the video]](https://youtu.be/4y411GG_pfA)

{% include video id="4y411GG_pfA" provider="youtube" %}

{% include video id="31gvTYL8U38" provider="youtube" %}

<!--Eles tem um lema que gosto bastante: "Não importa o que eu acho, importa o que eu sei!". -->

Nesse **post**, vamos analisar alguns números do canal com o [R](https://www.r-project.org/), apresentando os vídeos que se destacam em algumas estatísticas. Para isso, vamos utilizar  o pacote [tuber](https://cran.r-project.org/web/packages/tuber/tuber.pdf), que permite acessar a API do YouTube para ter acesso a diversos dados de um canal ou vídeo específico,  como o número de visualizações, número de likes (curtidas), número de dislikes e comentários de vídeos.

Antes de tudo, precisamos instalar o pacote. Podemos fazer isso por meio do comando `install.packages("tuber")` ou então obtendo pelo GitHub do autor do pacote `devtools::install_github("soodoku/tuber", build_vignettes = TRUE)`.

A segunda tarefa consiste em obter o `app_id` e `app_secret` do console de desenvolvimento da Google. Para isso, clique [aqui](console.developers.google.com) e siga as orientações de configuração e, para ter mais informações, clique neste [link](https://developers.google.com/youtube/v3). Se a tarefa de obter esses códigos de acesso não for muito tranquila, posso criar um post separado explicando como obtê-los.  

Com os códigos de acesso devidamente obtidos, o próximo passo é rodar o o código abaixo:

``` r
yt_oauth(app_id="ID",
         app_secret="PASS")
```

Agora precisamos saber o *id* do canal para ter as informações disponíveis sobre ele. Para identificar o *id* do **Meteoro Brasil** podemos rodar o seguinte comando:

``` r
yt_search(term = "Meteoro Brasil")
```
Com o comando acima, descobrimos que o *id* do canal é `UCk5BcU1rOy6hepflk7_q_Pw`. Nesse momento, quero saber as estatísticas gerais do canal e utilizo para isso a função `get_channel_stats` do pacote [tuber](https://cran.r-project.org/web/packages/tuber/tuber.pdf). 

``` r
get_channel_stats("UCk5BcU1rOy6hepflk7_q_Pw")
```

A data da realização das análises é 27 de junho de 2020 e todos os números apresentados nesse post são relativos a essa data. O canal apresenta um total de 83043689 visualizações e 813000 inscritos. 

Para a manipulação dos vídeos do canal e organizar suas informações em um banco de dados, vamos usar os seguintes pacotes:

``` r
library(dplyr)          # transformar dados
library(tibble)         # criar dataframes
library(lubridate)      # manipular datas
library(stringr)        # manipular texto
library(abjutils)       # lidar com texto em português
library(purrr)          # criar funcionais
library(purrrlyr)       # criar funcionais
library(ggplot2)        # fazer gráficos lindos
library(patchwork)      # ajudar mais ainda com gráficos lindos
library(wordcloud)      # criar nuvem de palavras
library(corrplot)       # criar correlogramas
```

Vamos novamente usar a função `yt_search`, mas agora para obter os vídeos do canal. Além disso, vamos também criar uma coluna `data` com a data da publicação de cada vídeo.

``` r
videos <- yt_search(term="", type="video", channel_id = "UCk5BcU1rOy6hepflk7_q_Pw")

videos <- videos %>%
  mutate(data = as.Date(publishedAt)) %>%
  arrange(data)
```
No objeto `videos` temos um dataframe com todos os vídeos do canal. Dois argumentos úteis da função `yt_search` são `published_after`  e `published_before` para indicar o período de interesse dos vídeos. Como queremos obter todos os vídeos do canal, deixamos esses argumentos sem restrição. 

O próximo passo é obter as estatísticas de cada vídeo. Temos disponíveis as informações de número de visualizações (no código abaixo chamamos de `Nvisua`), número de likes (`Nlikes`), número de dislikes (`Ndislikes`) e número de comentários (`Ncomentarios`). 

```r
videostats <-  lapply(as.character(videos$video_id),function(x){  get_stats(video_id = x) })

videostats <- do.call(rbind.data.frame, videostats)
videostats$titulo <- videos$title
videostats$data <- videos$data
videostats <-   videostats %>% mutate(Nvisua = as.numeric(as.character(viewCount)),
                       Nlikes = as.numeric(as.character(likeCount)),
                       Ndislikes = as.numeric(as.character(dislikeCount)),
                       Ncomentarios = as.numeric(as.character(commentCount))) %>%
                select(id, titulo, data, Nvisua, Nlikes, Ndislikes, Ncomentarios) 

```
O dataframe `videostats` tem 7 colunas (id, titulo, data, Nvisua, Nlikes, Ndislikes, Ncomentarios) e 487 linhas, cada uma referente a um vídeo do canal. Logo, na data da presente análise, o canal tem 487 vídeos. 

Para nos familiarizarmos com as variávies na base de dados `videostats`, uma primeira informação que gostaria de saber é sobre o primeiro vídeo publicado no canal. Para isso, podemos usar o comando

```r
videostats %>%
  filter(data==min(data)) 
```
Como saída, temos: 

    ##       id                                           titulo       data Nvisua Nlikes Ndislikes Ncomentarios
    ##  DVpC21wJ4qo Steven Universe, sexualidade e estupro - Meteoro 2017-04-10 206544  30434       976         1198

Com isso, sabemos que o primeiro vídeo foi publicado no dia 10 de abril de 2017 e desde então acumulou 206544 visualizações, com 30434 likes, 976 dislikes e 1198 comentários. Este foi um vídeo sobre o desenho animado [Steven Universe](https://www.youtube.com/watch?v=DVpC21wJ4qo), em que discutem as metáforas do desenho que aborda, de maneira sutil, questões de gênero e até violência sexual. Como todo início de canal no YouTube, percebemos que muito foi melhorado desde então, principalmente as questões técnicas, mas ali já dava para perceber a sensibilidade ao analisar a cultura pop além da superfície.

Uma impressão que tenho como fã assídua do canal é que ele tem publicado mais vídeos no ano de 2020. Para avaliar se minha impressão faz algum sentido, fiz uma análise do número de vídeos publicados por mês desde a inauguração do canal até o mês atual da análise. 

```r
video_aux <- videostats %>% 
  mutate(ano=year(data),mes=month(data,label=TRUE)) %>%
  group_by(ano,mes ) %>%
  summarise(quant_videos=n()) 

video_aux$date <- paste(str_sub(video_aux$ano, start = -2),video_aux$mes, sep="-") 

video_aux$date <- factor(video_aux$date,levels = c("17-abr", "17-jun", "17-jul", "17-ago", "17-set",
                                                   "17-out", "17-nov", "17-dez", "18-jan","18-fev",
                                                   "18-mar", "18-abr", "18-mai", "18-jun", "18-jul",
                                                   "18-ago", "18-set", "18-out", "18-nov", "18-dez",
                                                   "19-jan", "19-fev", "19-mar", "19-abr", "19-mai",
                                                   "19-jun", "19-jul", "19-ago", "19-set", "19-out",
                                                   "19-nov", "19-dez", "20-jan", "20-fev", "20-mar",
                                                   "20-abr", "20-mai", "20-jun"))
video_aux %>%
  ggplot(aes(x = date, y = quant_videos)) +
  geom_col(color = 'black') +
  labs(x = "Ano e mês", y = "Número de videos") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
```

![](/assets/images/Num_videos_bar.png)<!-- -->

Podemos perceber uma crescente no número de vídeos publicados nos meses mais recentes e maio de 2020 é o mês com mais vídeos publicados. Também quero saber quantos vídeos foram publicados no período de janeiro a maio de cada ano. Como em 2017 só teve vídeo a partir de abril, esse ano não entrará nessa análise. 

```r
videostats %>% 
  mutate(ano=year(data),mes=month(data,label=TRUE)) %>%
  group_by(ano,mes ) %>%
  summarise(quant_videos=n()) %>%
  filter(ano>=2018 & (mes=="jan" | mes=="fev" |
           mes=="mar" |mes=="abr" | mes=="mai")) %>%
  group_by(ano) %>%
  summarise(quant_videos=sum(quant_videos))
```

    ### A tibble: 3 x 2
    ##    ano quant_videos
    ##  <dbl>        <int>
    ##1  2018           41
    ##2  2019           55
    ##3  2020          134
    
<!--Como resultado, no período de janeiro a maio, foram 41 vídeos publicados em 2018, em 2019 foram 55, e em 2020, o total de número publicados é de 134 vídeos. Ou seja, -->
Em 2020 o número de vídeos publicados representa 326% e 243% dos vídeos publicados em 2018 e 2019, respectivamente, para o mesmo período observado, corroborando também a minha impressão. 


Agora, gostaria de avaliar o número de visualizações pela data da publicação do vídeo. Para isso, analisamos o seguinte gráfico:


``` r
videostats %>%
ggplot(aes(x = data, y = Nvisua)) +
  geom_line() +
  labs(x = "Data da publicação", y = "Número de visualizações") +
  scale_x_date(date_breaks="5 months",date_labels = "%b %y") +
  geom_line(aes(y = 500000, colour = "500 mil views")) +
  geom_line(aes(y = 1000000, colour = '1 Milhão views')) +
  theme(legend.title = element_blank())+
  theme(legend.position="bottom") +
  scale_color_discrete(name="")
```
![](/assets/images/visua.png)<!-- -->

Ao analisar o gráfico acima e com a ajuda dos códigos apresentados abaixo, observamos que 11 vídeos  acumulam mais de 500 mil visualizações e há 2 vídeos que apresentam mais de 1 milhão de visualizações. O vídeo mais visto do canal é ["Decifrando This is America"](https://www.youtube.com/watch?v=gvsQ09wM-bU), em que exploram as mensagens contidas no clipe "This is America" de Childish Gambino. O vídeo foi publicado em maio de 2018 e tem 1507086 visualizações acumuladas desde então. 

<!--Vale ressaltar que nem são os canais mais velhos, que teriam a vantagem de mais tempo para serem vistos, e nem os mais recentes, que tem a vantagem de ter mais inscritos. -->

``` r
## titulo dos vídeos com mais de 500 mil visualizações
videostats %>%
  filter(Nvisua>500000) %>%
  select(titulo)
```

    ##                                                         titulo
    ## 1                    COMO GORILLAZ SALVOU O ROCK #Meteoro
    ## 2                 DECIFRANDO THIS IS AMERICA #meteoro.doc
    ## 3                          VOCÊ FOI ENGANADO #meteoro.doc
    ## 4  10 RAZÕES PARA DELETAR SUAS REDES SOCIAIS #meteoro.doc
    ## 5                  QUEM É OLAVO DE CARVALHO? #meteoro.doc
    ## 6                        QUEM É NANDO MOURA? #meteoro.doc
    ## 7                           POBRE BETTINA... #meteoro.doc
    ## 8                    QUEM É O DONO DA HAVAN? #meteoro.doc
    ## 9   RACIONAIS: POR UM BRASIL MENOS IGNORANTE #meteoro.doc
    ## 10                    RAUL SEIXAS, O TEÓLOGO #meteoro.doc
    ## 11                                     QUEM É SARA WINTER
    

``` r
## titulo dos vídeos com mais de 1 milhão de visualizações
videostats %>%
  filter(Nvisua>1000000) %>%
  select(titulo)
```

    ##                                                         titulo
    ##  1 DECIFRANDO THIS IS AMERICA #meteoro.doc
    ##  2  QUEM É OLAVO DE CARVALHO? #meteoro.doc


``` r
# titulo dos vídeos com mais de 500 mil visualizações
videostats %>%
  filter(Nvisua==max(Nvisua)) 
```

    ##       id                                  titulo       data  Nvisua Nlikes Ndislikes Ncomentarios
    ##  gvsQ09wM-bU DECIFRANDO THIS IS AMERICA #meteoro.doc 2018-05-08 1507086 128120      1630         2943

O canal apresenta, em média, 151720 visualizações por vídeo, com um desvio padrão de 130611 visualizações, como podemos ver por meio de algumas medidas descritivas do número de visualizações abaixo:

``` r
#medidas descritivas do número de visualizações
videostats %>% 
  summarise(
    min=min(Nvisua,na.rm=TRUE),
    media= mean(Nvisua, na.rm = TRUE),
    mediana = median(Nvisua, na.rm = TRUE),
    dp  = sd(Nvisua,na.rm=TRUE),
    max=max(Nvisua,na.rm=TRUE)
  )
```

    ##     min    media mediana       dp     max
    ##    13547 151719.9  125405 130610.9 1507086


<!--Já o vídeo menos visto foi o quarto vídeo de uma série de Capivara Carteira, que eles leem mensagem dos inscritos em um momento que a identidade deles é desconhecida.

#            id                                        titulo       data Nvisua Nlikes Ndislikes Ncomentarios
# 20 IHGGZq0CyI4 Capivara Carteira #04 - aniversário - Meteoro 2017-10-07  13547   3361        11         1061 -->


Quando analisamos apenas o número de visualizações, como na análise anterior, não estamos levando em consideração o fato de que vídeos mais antigos tem mais tempo de disponibilidade para visualização, privilegiando assim os vídeos mais antigos. Mas, por outro lado, há um segundo argumento de que os vídeos mais recentes tem a vantagem do canal ter mais inscritos e, possivelmente, ser visto por mais inscritos no momento de sua publicação. Esse último argumento faz sentido se pensarmos que, em geral, as pessoas raramente assistem aos vídeos mais antigos quando se inscrevem nos canais. Mas estas são apenas algumas hipóteses e, ao analisar o número de visualizações corrigindo pela idade do vídeo no gráfico abaixo, me parece que o segundo argumento faz algum sentido. 

```r 
videostats %>%
  mutate(idade = as.numeric(Sys.Date() - data)) %>%
  ggplot(aes(x = data, y = Nvisua/idade)) +
  geom_line() +
  labs(x = "Data da publicação", y = "Visualizações/Idade") +
  scale_x_date(date_breaks="5 months",date_labels = "%b %y") 
```
![](/assets/images/visua_idade.png)<!-- -->

Uma próxima análise que gostaria de avaliar é o número de likes relativo ao número de visualizações. No gráfico abaixo está a porcentagem de likes pela data da publicação do vídeo.  

```r
videostats %>%
  mutate(prop_like = Nlikes/Nvisua) %>%
  ggplot(aes(x = data, y = prop_like)) +
  geom_line(color = 'black') +
  labs(x = "Data da publicação", y = "Proporção de likes") +
  scale_x_date(date_breaks="5 months",date_labels = "%b %y") +
  scale_y_continuous(labels = scales::percent,limits =c(0,0.3))
```

![](/assets/images/prop_like.png)<!-- -->

O video com maior porcentagem de likes (28,75\%) é episódio 10 da série [Capivara Carteira](https://www.youtube.com/watch?v=-fDHDUH0Fjk). Nesse episódio, o Cara Mais Simples faz uma homenagem para a Mulher Mais Sábia no dia de seu aniversário. Mas alguém pode dizer: "Para que tanto like relativo em um vídeo de homenagem?". Eu me arrisco a afirmar que esta é uma homenagem com a cara do Meteoro, novamente com sensibilidade, sinceridade e poesia, e talvez isso justifique o *feedback* positivo daqueles que assistiram.
<!--e o com menor porcentagem de likes é "Raul Seixas, o teólogo", que
fala sobre a obra prima Gita de Raul Seixas e Paulo Coelho. -->

``` r
# titulo com maior número de likes relativo ao número de visualizações
videostats %>%
  mutate(prop_like = Nlikes/Nvisua) %>%
  filter(prop_like ==max(prop_like )) 
```

    ##     id                             titulo       data Nvisua Nlikes Ndislikes Ncomentarios 
    ##    134 -fDHDUH0Fjk GRANDE DIA | Capivara Carteira #10 2018-10-07  31323   9007       110         1760 

<!-- #            id                              titulo       data Nvisua Nlikes Ndislikes Ncomentarios  prop_like
#215 yD6q4n7d6FQ RAUL SEIXAS, O TEÓLOGO #meteoro.doc 2019-05-25 806161  33927       882         1490 0.04208465-->


Gostaria agora de analisar também o número de dislikes dos vídeos. Para isso, fiz um gráfico da razão entre likes e dislikes dos vídeos pela data de publicação do vídeo.  

```r
videostats %>%
  mutate(like_dislike = Nlikes/Ndislikes) %>%
  ggplot(aes(x = data, y = like_dislike)) +
  geom_line(color = 'black') +
  labs(x = "Data da publicação", y = "Likes/Dislikes") +
  scale_x_date(date_breaks="5 months",date_labels = "%b %y") 
```

![](/assets/images/like_dislike.png)<!-- -->

Uma primeira observação que destaco é o fato de não ter nenhuma razão menor que 1, indicando que os vídeos do canal sempre tem mais likes que dislikes. O canal com a menor razão like/dislike é o vídeo [ELENÃO](https://www.youtube.com/watch?v=J7yZMlb8ruo) (likes/dislikes=1,87), que aborda o movimento #elenão, formado por mulheres indo às ruas para expressar a rejeição para o então candidato e atual presidente (infelizmente) Bolsonaro. Faz um certo sentido pensar que o vídeo com a menor razão de likes/dislikes ser algum que incorpora a questão política, uma vez que estamos em uma situação de bastante polarização no país. 

```r
videostats %>%
  mutate(like_dislike = Nlikes/Ndislikes) %>%
  filter(like_dislike == min(like_dislike))
```

    ##      id               titulo       data Nvisua Nlikes Ndislikes Ncomentarios 
    ##     131 J7yZMlb8ruo #ELENÃO #meteoro.exp 2018-09-30 132199  21003     11230        14605 
    
    
Para analisar o número de comentários nos vídeos, faço agora um gráfico dessa variável pela data de publicação do vídeo, apresentado no que segue:

```r
videostats %>%
  ggplot(aes(x = data, y = Ncomentarios)) +
  geom_line() +
  labs(x = "Data da publicação", y = "Número de comentários") 
```
![](/assets/images/comentarios.png)

O vídeo com maior número de comentários é [Quem é Olavo de Carvalho?](https://www.youtube.com/watch?v=Mz9f3fLks9s), com um total de 25971 comentários. Eu fortemente recomendo esse vídeo e para justificar minha recomendação, vou colocar aqui a sua descrição: 

> Olavo de Carvalho, antes de se definir como o "parteiro da nova direita", foi militante de esquerda e astrólogo. Aqui, olhamos para a biografia contraditória e controversa desse personagem, na tentativa de entender como ele conseguiu transformar suas ficções em realidade.

Vale um parênteses aqui de algo que lembrei agora: o Meteoro Brasil lançou o livro **Tudo o que você precisou desaprender para virar um idiota**. Esse livro explica a ficção e da realidade por trás de kit gay, marxismo cultural, gramscismo, Lei Rouanet, mudança climática, Paulo Freire, globalismo, vacinas e muito mais (frase retirada do resumo no site da [Amazon](https://www.amazon.com.br/Tudo-precisou-desaprender-virar-idiota/dp/8542217756/ref=asc_df_8542217756/?tag=googleshopp00-20&linkCode=df0&hvadid=379792431986&hvpos=&hvnetw=g&hvrand=4496352622355239333&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=1001549&hvtargid=pla-850164298977&psc=1)). Ok, talvez meu parênteses sobre esse livro estar na parte do texto que falo sobre Olavo de Carvalho não seja apenas uma coincidência...


```r
videostats %>%
   filter(Ncomentarios == max(Ncomentarios))
```

    ##      id                                 titulo       data  Nvisua Nlikes Ndislikes Ncomentarios
    ##       56 Mz9f3fLks9s QUEM É OLAVO DE CARVALHO? #meteoro.doc 2018-11-30 1025781 111184     37366        25971   


 Agora, uma análise que gostaria de realizar é a correlação entre os números de visualizações, likes, dislikes e comentários dos vídeos. Pelos gráficos abaixo, observamos que há uma correlação bastante positiva entre número de visualizações e número de likes, assim como entre o número de dislikes e o número de comentários. Refiz a mesma análise sem os pontos muito discrepantes e os resultados foram bem parecidos. 


```r
# gráficos de dispersão
p1 <- videostats %>%
  ggplot(aes(x = Nvisua, y = Nlikes)) +
  geom_point(color = 'black') +
  labs(x = "nº de visualizações", y = "nº de likes") 

p2 <- videostats %>%
  ggplot(aes(x = Nvisua, y = Ndislikes)) +
  geom_point(color = 'black') +
  labs(x = "nº de visualizações", y = "nº de dislikes") 

p3 <- videostats %>%
  ggplot(aes(x = Nvisua, y = Ncomentarios)) +
  geom_point(color = 'black') +
  labs(x = "nº de visualizações", y = "nº de comentários") 

p4 <- videostats %>%
  ggplot(aes(x = Nlikes, y = Ncomentarios)) +
  geom_point(color = 'black') +
  labs(x = "nº de likes", y = "nº de comentários") 

p5 <- videostats %>%
  ggplot(aes(x = Ndislikes, y = Ncomentarios)) +
  geom_point(color = 'black') +
  labs(x = "nº de dislikes", y = "nº de comentários") 

p6 <- videostats %>%
  ggplot(aes(x = Ndislikes, y = Nlikes)) +
  geom_point(color = 'black') +
  labs(x = "nº de dislikes", y = "nº de likes") 

(p1 | p2 |p3 ) / (p4 | p5 | p6 )
```

![](/assets/images/graficos_dispersao.png)<!-- -->


```r
videos_aux <- videostats %>%
  select(Nvisua,Nlikes,Ndislikes,Ncomentarios)
corrplot.mixed(cor(videos_aux))
```
![](/assets/images/corr_plot.png)<!-- -->

A partir daqui, quero falar do meu vídeo favorito no canal: [Revelando Belchior](https://www.youtube.com/watch?v=u_2biKBWO0I). O fato de falar sobre Belchior auxilia bastante nesse favoritismo. Além disso, eles fazem uma análise de duas músicas do artista que eu particularmente adoro: "Como Nossos Pais" e "Velha Roupa Colorida", também interpretadas pela maravilhosa Elis Regina, relacionando seus versos com temas do Brasil atual. 

{% include video id="u_2biKBWO0I" provider="youtube" %}

Desse vídeo, vamos analisar seus comentários e para isso, precisamos saber o seu *id*. 
```r
videostats %>%
  filter(str_detect(titulo,"BELCHIOR"))
```


    ##  id             titulo       data Nvisua Nlikes Ndislikes Ncomentarios
    ##   u_2biKBWO0I REVELANDO BELCHIOR 2020-03-04 165161  29871       161         1377
 
 O *id* do vídeo é `u_2biKBWO0I` e vamos agora obter todos os comentários disponíveis dele por meio da função `get_comment_threads` da seguinte maneira:

```r
comentarios <- get_comment_threads(c(video_id = "u_2biKBWO0I"), max_results = 1500)
```


Vamos analisar o número de comentários por dia. Pelo gráfico abaixo, podemos observar que, como esperado, o maior número de comentários realmente acontece próximo ao dia da publicação do vídeo. 

```r
comentarios$data = as.Date(comentarios$$publishedAt)
df <-  df %>%
  arrange(data) %>%
  group_by(year(data), month(data), day(data)) %>%
  count()
df$data = make_date(df$`year(data)`, df$`month(data)`,df$`day(data)`)

df %>%
  ggplot(aes(x = data, y = n)) +
    geom_line(color = 'black') +
    labs(x = "Data da publicação", y = "Número de comentários") +
    scale_x_date(date_breaks="15 days",date_labels = "%d %b") 
```
![](/assets/images/Comentarios_Belchior.png)<!-- -->

Agora gostaria de construir uma nuvem de palavras contidas nos comentários do vídeo. 

```r
coment_text <- as.character(comentarios$textOriginal)

oi <- lapply(coment_text, function(x){
  abjutils::rm_accent(x) })

coment_texto <- tibble(text = Reduce(c, oi)) %>%
  mutate(texto = str_to_lower(text)) %>%
  select(texto) 

remove <- c("voce","voces","o","a","os","as","que","muito","este","esta","aquele","aquela","sao","para","de","nao","com","mais","foi","era","uma","mas","ficou","meu","minha","seu","sua","como","apenas","essa","esse","por","favor","sempre","todo","para","tem","faz","pelo","sobre","acho","isso","aqui","quando","mesmo","fala","morando","minha","proximo","proxima","pra","sei","dos","das","fazer","ver","cada","desse","tipo","ter","tambem","fiquei","num","seus","tinha","vez","ainda","vai","agora","desde","deste","sou","anos","agr","tava","sera","ate","poe","muita","vcs","outras","fizeram","conheco","feito","nos","coisa","quanto","todas","suas","poderia","seja","pode","tanto","dessa","fez","tao","tudo","vou","ficaria","foi","pela","teu","video","sobre","ser","ele","acima","canal","todos","meio","dar","trabalho","achei","sem","nas","falando","dele","talvez","chegou","parar","paulo","olho","olho")
         
words <-  tibble(palavras = Reduce(c, stri_extract_all_words(coment_texto$texto))) %>%
  group_by(palavras) %>% count() %>% arrange(desc(n)) %>% filter(nchar(palavras) >= 3) %>%
  filter(n > 15 & palavras %in% remove == FALSE) 

pal2 <- brewer.pal(8,"Dark2")
wordcloud(words$palavras, words$n, random.order = FALSE, random.color = TRUE,rot.per = 0.3,colors=pal2)
```

![](/assets/images/nuvem_belchior.png)<!-- -->

Condicionado aos critérios definidos no código acima, a palavra mais frequente nos comentários (no caso é "Belchior") é a de maior tamanho na nuvem de palavras e assim por diante.


  De maneira análoga, fiz também a nuvem de palavras obtida pelos comentários do vídeo da música "AmarElo" do Emicida ([Emicida Celebra Você](https://www.youtube.com/watch?v=4y411GG_pfA)), citado no início desse **post**, que contém versos da música "Sujeito de Sorte" do Belchior.  


![](/assets/images/nuvem_emicida.png)<!-- -->

  Bom, com esse **post** espero ter alcançado alguns objetivos:
  
1) Mostrar como analisar os números dos canais e vídeos do YouTube com o R;

2) Divulgar a maravilha que é o canal **Meteoro Brasil** ([clique aqui para acessar o canal](https://www.youtube.com/channel/UCk5BcU1rOy6hepflk7_q_Pw));

3) Falar sobre o Belchior, apresentando o artista para aqueles que talvez não o conheça e, com isso, deixar sempre viva a sua obra.



