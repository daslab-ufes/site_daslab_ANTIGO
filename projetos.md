---
permalink: /projetos/
layout: splash
---

## Projeto: Métodos de aprendizado de máquinas aplicados ao desenvolvimento de curvas de crescimento fetal personalizadas para a população brasileira

### Coordenadora: Agatha Sacramento Rodrigues

O crescimento intrauterino é determinado pela combinação de fatores maternos e fetoplacentários que afetam a oferta de nutrientes e oxigênio para o feto. Outros motivos inerentes ao feto podem afetar o crescimento, como infecção fetal, malformações congênitas, anomalias cromossômicas e exposição a substâncias teratogênicas. A restrição de crescimento fetal está associada a um risco maior de atraso no desenvolvimento cognitivo, morbidades e mortalidade perinatais. Assim, é importante o acompanhamento do crescimento fetal, uma vez que alerta o obstetra para a necessidade de cuidados assistenciais adequados. É possı́vel avaliar o crescimento fetal ao medir múltiplas medidas biométricas por meio de exame ultrassonográfico obstétrico. Hadlock *et al.* (1982) realizam estudos transversais em pacientes com gestação única, sem patologias feto maternas, e descrevem a correlação entre a idade gestacional e as medidas biométricas: diâmetro biparietal, circunferência cefálica, circunferência abdominal e comprimento do fêmur. Ao considerar como ponto fraco em seu estudo o fato de ser transversal, eles discutem que as curvas derivadas de estudos longitudinais são mais apropriadas para avaliar o crescimento individual e representam melhor o crescimento médio de uma população.

Atualmente no Brasil, as curvas de crescimento das medidas biométricas de Hadlock são usadas como referência. Ainda, o peso fetal é estimado como função das medidas biométricas: diâmetro biparietal, circunferência cefálica, circunferência abdominal e o comprimento do fêmur. Assim, um feto com peso estimado abaixo do percentil 10 é classificado como pequeno para idade gestacional, enquanto um feto com peso estimado acima do percentil 90 é classificado como grande para a idade gestacional. 

Algumas crı́ticas podem ser consideradas ao avaliar as curvas de Hadlock na população brasileira. A primeira consiste em utilizar uma curva baseada na população americana, que apresenta caracterı́sticas diferentes da população brasileira. Nesse sentido, talvez os pesos das medidas biométricas não sejam os mesmos quando o interesse consiste em estimar o peso fetal na população brasileira. Ainda, um tamanho de diâmetro biparietal, por exemplo, considerado pequeno na população americana pode ser normal quando considerado na população brasileira. 

Vale ressaltar que as curvas de Hadlock são funções apenas da idade gestacional. No entanto, é esperado que um feto de uma gestante de estatura alta seja maior que o feto de uma gestante com baixa estatura, ambas na mesma idade gestacional. Assim, pode ser interessante considerar curvas de crescimento fetal para medidas biométricas que, além da idade gestacional, levem em conta caracterı́sticas maternas e da gestação, como altura, peso, IMC, sexo fetal e paridade. Essas curvas são chamadas de curvas personalizadas.

Com os avanços de métodos computacionais e pesquisas em modelagem de dados, modelos para construção de curvas de crescimento fetal personalizadas podem ser ajustados, ao também levar em conta a dependência entre medidas da mesma gestante ao longo do pré-natal. A qualidade de desempenho do modelo, assim como a proporção de acerto podem ser melhoradas com a assistência de algoritmos de aprendizado de máquina (do inglês, *Machine Learning* - ML) ao considerar, inclusive, penalizações como de Lasso e de Ridge. Além dos modelos de regressão à média, também podem ser considerados os modelos de regressão quantı́lica para dados longitudinais com o intuito de estimar os percentis de interesse.

Devido ao bom desempenho dos algoritmos de ML em diversas áreas, principalmente em áreas financeiras e econômicas, seu uso na aplicação para problemas da área da saúde é de crescente interesse. 

Como objetivo geral, esse projeto tem como intuito utilizar e desenvolver métodos de machine learning para a construção de curvas de crescimento fetal personalizadas para a população brasileira, modeladas em função de variáveis maternas e gestacionais (variáveis input).

Como objetivos especı́ficos, são listados:

- Fazer a implementação dos principais modelos de aprendizado de máquina para as medidas ultrassonográficas e para calcular o peso fetal estimado como função das demais medidas ultrassonográficas.
- Utilizar os modelos implementados nos dados do Hospital Universitário da USP.
- Desenvolver modelos de regressão quantı́lica para dados longitudinais com penalizações.
- Criar um aplicativo para utilização dos resultados do modelo escolhido, numa interface amigável, com o intuito de auxiliar na decisão do médico. Por meio do aplicativo, será possı́vel entrar com os dados de um paciente e ter como saı́da curvas de crescimento fetal para as medidas ultrassonográficas e peso fetal estimado.
- Realizar uma segunda aprendizagem ao utilizar os dados imputados dos usuários de outros centros públicos e privados do Brasil e melhorar o algoritmo com os dados novos e também com outras variáveis inputs, como a região do Brasil.

#### Referência 
Hadlock, F. P., Deter, R. L., Harrist, R. B., & Park, S. K. (1982). Fetal biparietal diameter: a critical re‐evaluation of the relation to menstrual age by means of real‐time ultrasound. Journal of ultrasound in Medicine, 1(3), 97-104.

## Projeto: Observatório Obstétrico

### Coordenadora: Agatha Sacramento Rodrigues

O acesso à informação está previsto na Constituição Federal e na Declaração Universal dos Direitos Humanos. Em 2011 foi sancionada a Lei de Acesso à Informação Pública (Lei 12.527/2011) que regula o acesso a dados e informações detidas pelo governo. Dentro desse contexto, o Portal Brasileiro de Dados Abertos (PBDA) é a ferramenta que centraliza a busca e o acesso dos dados públicos. Segundo o PBDA, dados abertos é a publicação e disseminação dos dados e informações públicas de tal maneira que se permita acessar, entender e analisar. No entanto, dados sem tratamento e análise são apenas dados. Precisamos, então, analisar de maneira adequada para transformar dados em informação e permitir que esses dados tratados sejam acessı́veis à população de maneira dinâmica.

A importância de permitir acesso a dados públicos de maneira estruturada e com responsabilidade faz com que a sociedade tenha acesso à informação, que gestores públicos possam tomar decisões baseadas em evidências e que as discussões sobre polı́ticas públicas sejam embasadas em dados confiáveis. Na área da Obstetrı́cia, em especial, há algumas discussões sobre polı́ticas públicas para gestantes, fetos e recém nascidos que, muitas vezes, não são pautadas em dados cientı́ficos ou análise de dados públicos.

Como motivação, foi proposto o projeto de lei n o 17.137 / 2019 pela deputada estadual de São Paulo Janaı́na Paschoal, que garante à gestante a opcão pela cesárea no SUS (Sistema Único de Saúde), na hora do parto e sem indicação clı́nica, a partir da 39 a semana da gestação. Em seu projeto de lei, disponı́vel em [link](www.al.sp.gov.br/propositura/?id=1000262934), a proponente diz que “muitos são os casos em que, graças à submissão ao parto normal, o concepto vem a sofrer anóxia (falta de oxigênio), ficando sequelado para o resto da vida, em virtude da popularmente chamada paralisia cerebral. Nas situações mais graves, a anóxia leva à morte do bebê, seja dentro do ventre materno, seja alguns dias após o nascimento”.

Por outro lado, a SOGESP (Associação de Obstetrı́cia e Ginecologia de São Paulo) diz que o projeto não tem base em evidências cientı́ficas e que pode estimular taxas indiscriminadas de cesáreas, que trazem riscos à mulher e ao bebê. Ainda, “não há evidência na literatura médica de que o parto normal esteja associado a um maior risco de paralisia cerebral. O aumento nas taxas de cesariana não muda a ocorrência de paralisia cerebral”, diz presidente da SOGESP, a professora da USP Rossana Francisco em reportagem disponı́vel em [link](https://www1.folha.uol.com.br/cotidiano/2019/08/projeto-que-permite-cesarea-sem-indicacao-no-sus-e-aprovado-em-sp.shtml). Além disso, não há dados sobre as taxas de paralisia cerebral no estado de São Paulo ou estudos que determinem se essa ocorrência é maior ou menor em hospitais públicos ou privados paulistas, em que cesáreas podem ser realizadas sem indicação clı́nica.

Por esse motivo, propomos a criação de um observatório obstétrico por meio de uma plataforma iterativa com os dados disponı́veis (conceito de PaaS – Platform as a Service) pública e gratuita com utilização de ferramentas open source para análise e disseminação de grandes quantidades de dados da Obstetrı́cia do Brasil.


## Projeto: Modelos de Regressão Quantı́lica Bayesianos para Variáveis Resposta Multidimensionais

### Coordenador: Bruno Santos

Modelos de regressão são ferramentas estatı́sticas utilizadas para entender a relação entre variável resposta e covariáveis, considerando diferentes distribuições de probabilidade e usualmente descrevendo efeitos no valor médio dessa variável resposta.

Modelos de regressão quantı́lica se diferem dos modelos usuais de regressão ao estudar a relação entre covariáveis e quantis condicionais da variável resposta. Em especial, esses modelos de regressão quantı́lica podem ser estimados considerando a perspectiva da inferência bayesiana, em que algoritmos de Monte Carlo via Cadeias de Markov (MCMC, da sigla em inglês) permitem maior flexibilidade na definição da estrutura de regressão. Uma nova área de pesquisa tem crescido nos últimos anos, em que a variável resposta é definida com dimensão maior que um. Isso traz novos desafios tanto com relação a possı́veis distribuições de probabilidade multidimensionais que podem ser utilizadas nessa modelagem, quanto maneiras de interpretação e visualização dos resultados. Nesse sentido, modelos de regressão quantı́lica para variáveis resposta multidimensionais podem ser interessantes pois permitem a análise dos dados sem a suposição de uma distribuição de probabilidade para a variável resposta. Por outro lado, a definição de quantis multidimensionais também pode trazer dificuldades. Para esse problema, uma possı́vel solução é utilizar a definição de quantis direcionais nesse espaço. Dessa maneira, esses modelos de regressão quantı́lica poderão ser utilizados para estudar o efeito das variáveis preditoras em diferentes quantis nesse espaço multidimensional. Por exemplo, considerando as notas de estudantes no Exame Nacional do Ensino Médio (ENEM), com esses modelos seria possı́vel estimar a diferença entre escolas privadas e públicas, tanto entre as maiores notas quanto nas piores notas, considerando simultaneamente as notas de diferentes disciplinas, tendo em vista a correlação entre esses valores


## Projeto: Classificação de Perfis de Violência contra adolescentes no Espı́rito Santo

### Coordenadores: Nátaly Adriana Jiménez Monroy; Fabio A. Fajardo Molinares; Luciana Graziela Godoi

De acordo com o Relatório Mundial da Saúde, considera-se como violência, para fins de notificação, “o uso intencional de força fı́sica ou do poder, real ou em ameaça, contra si próprio, contra outra pessoa, ou contra um grupo ou uma comunidade que resulte ou tenha possibilidade de resultar em lesão, morte, dano psicológico, deficiência de desenvolvimento ou privação” (Krug, 2002). Ou seja, é qualquer conduta – ação ou omissão – de caráter intencional que cause ou venha a causar dano, morte, constrangimento, limitação, sofrimento fı́sico, sexual, moral, psicológico, social, polı́tico, econômico ou patrimonial.

O setor da saúde tem um papel fundamental como identificador de casos de violência. No Brasil, o Ministério da Saúde (MS) publicou a Portaria n o 104 que estabelece a obrigatoriedade da notificação de casos novos de doenças e agravos, incluindo aqui casos de violência (da República Federativa do Brasil, 2011).

Na ficha de notificação das violências, o profissional da saúde deverá indicar o principal tipo de violência associada com o evento relatado pela vı́tima, podendo ser classificado como: fı́sica, psicológica/moral, tortura, violência sexual, tráfico de seres humanos, financeira/econômica, negligência/abandono e outros, em que deverá ser discriminado casos como tentativa de suicı́dio e autoagressão. No instrutivo da ficha de notificação aparece uma descrição detalhada sobre os diferentes tipos de violência e classificação. Além dos tipos de violência, a notificação contém informações como local onde ocorreu a violência, dados pessoais da vı́tima, perfil do possı́vel autor da agressão, entre outros. Espera-se com isso fornecer subsı́dios para o planejamento de ações de prevenção e intervenção.

Uma população considerada de risco é a de jovens e adolescentes, como reconhecida pela lei n o 8.069 de 13 de julho de 1990, chamada por Estatuto da Criança e do Adolescente (ECA), cujo objetivo é trazer proteção integral ás crianças e adolescentes. O Art. 7 o do estatuto diz ”A criança e o adolescente têm direito a proteção à vida e à saúde, mediante a efetivação de polı́ticas sociais públicas que permitam o nascimento e o desenvolvimento sadio e harmonioso, em condições dignas de existência”.

Em 2017, a United Nations Children’s Fund (UNICEF) disponibilizou o relatório técnico ”A Familiar Face: Violence in the lives of children and adolescents” que mostra a situação da violência contra jovens e adolescentes em âmbito familiar no mundo e, em particular, indicam que o Brasil é o quinto paı́s mais violento da América Latina quando se trata de jovens de 10 a 19 anos (UNICEF, 2017). Ainda, o relatório cita as dificuldades de mensurar e os desafios éticos da coleta de dados sobre diversos casos de violência que ocorrem contra essa população ao redor do globo.

Os métodos estatı́sticos tornaram-se ferramentas fundamentais para toda classe de pesquisadores e usuários que estão em contato com as mais diversas fontes de dados. Esses métodos, servem não apenas como apoio cientı́fico a quase todas as áreas do conhecimento, também proporcionam mecanismos para diagnosticar a aperfeiçoar a gestão e operação de diversos sistemas, muitas vezes complexos,subsidiando a tomada de decisões através da criação de modelos que descrevem o comportamento e a relação de diversas variáveis ou fatores.

Particularmente na área das ciências da saúde, encontram-se com frequência variáveis como gênero, etnia, escalas de satisfação, nı́vel de poluição, local de moradia, etc. Estas variáveis são conhecidas como variáveis categóricas. Em outros casos, encontram-se variáveis discretas, caracterizadas por descrever a frequência de eventos de interesse tais como: número de internações hospitalares, número de sinistros em acidentes de trânsito, número de alunos com transtorno de ansiedade,número de notificações de agravos de violência, etc.

Os modelos estatı́sticos usados na análise de variáveis contı́nuas, tais como o modelo de regressão linear, não são aplicáveis às variáveis anteriormente descritas. Dessa forma, faz-se necessário o tratamento adequado desse tipo de dados para aprimorar as análises e a veracidade das conclusões derivadas dos modelos ajustados.

Especificamente nessa pesquisa analisaremos dados provenientes da Ficha de Notificação de Violência Interpessoal/Autoprovocada, registrados no Sistema de Informação de Agravos de Notificações (SINAN) no sistema de serviços de saúde. Temos por objetivo principal fazer uma análise adequada desses dados e promover uma modelagem correta a fim de identificar o perfil dos adolescentes que se encontravam em situação de violência no Espı́rito Santo entre 2011 e 2018.

Além da análise descritiva, será considerada neste trabalho modelagem via técnicas de regressão, especificamente, modelos de regressão logı́stico e multinomial com o objetivo de determinar quais fatores estão associados com a ocorrência de cada um dos tipo de violência contra os adolescentes no Espı́rito Santo.

Estudos envolvendo dados de criminalidade fazendo uso de técnicas de machine learning já foram reportados em Berk (2012) e Berk (2013). Dessa forma, pretendemos desenvolver um algoritmo de classificação que permita a partir do perfil da vı́tima e de sua proximidade com o autor da violência identificar qual tipo de violência um adolescente está mais propenso a sofrer a partir de seu perfil.


## Projeto: [EnsinaR](/ensinaR/)

### Coordenadora: Agatha Sacramento Rodrigues

Esse projeto de extensão visa a divulgação, ensino e treinamento da comunidade sobre o software R (https://www.r-project.org/). O software R é um software gratuito com linguagem e ambiente para análise de dados. É um dos principais software da ciência de dados, com uma comunidade muito ativa e engajada. Dentre as atividades deste projeto de extensão, destacamos os cursos de extensão em R (R para iniciantes, análise de dados em R, Machine Learning com R, visualização de dados, dashboards com R e web scraping com R) e a criação do capítulo R-Ladies Vitória (https://rladies.org/). R-Ladies é uma organização mundial cuja missão é promover a diversidade de gênero na comunidade R, ao promover meetups (encontros) e mentorias, garantindo um espaço amigável e seguro.

