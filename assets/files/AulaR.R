## R COMO CALCULADORA

#Operações Aritméticas
#Soma
15+17

#Subtração
30-15

#Divisão
30/15

#Multiplicação
30*30

# Potência
2**2
2^2

#Raiz quadrada
sqrt(4)       


##ATRIBUIÇÃO
#Objeto:nome que guarda valor
x <- 9
X
x <- "Flavia"
x

##Classes
#Caracter
x <- "Flavia"
class(x)
#Numerico
a <- 10.2
class(a)

##Operadores relacionais
3 < 4
3 > 4
3 == 4
3 != 4

#Vetores
x <- c(3, 2, 1, 0, -1, -2)
x
#Acessando posições do vetor
x[3]

#Valores especiais
#NA = ausência de informação
x[7]
#NaN(Not a number) = indefinição matemática
0/0
#Inf = número muito grande
1000**1000


#Vetor de caracter
y <- c("Azul", "Branco", "Cinza", "Amarelo", "Preto", "Vermelho")
y

z <- c(1, 2, 3, 4, 5, "Flavia")

#Operações Vetoriais
x - 1
x * 2
w <- c(1, 2, 3, 4, 5, 6)
x * w


#Sequências
x <- seq(from = 1, to = 100)
x

1:100

x <- seq(from = 1, to = 100, by = 2)
x


# Matriz 
x <- matrix(seq(1, 16), nrow = 4, ncol = 4)
x

x <- matrix(seq(1, 16), nrow = 4, ncol = 4, byrow = TRUE)
x

y <- matrix(seq(-1, -16), 4, 4)
y

#Operações matriciais
#soma
x + y
#Multiplicação ponto a ponto
x*y
#Multiplicação matricial
x%*%y


#Acessando elementos da matriz
x[2, 3]
x[2,  ]
x[ , 3]
x[1,  ] <- c(10, 20, 30, 40) 


#Concatenar linhas em uma matriz
vet <- c(11, 12, 13, 14)
x2 <- rbind(x, vet)
x2

#Contanear colunas na matriz
vet2 <- c(21, 22, 23, 24)
x3 <- cbind(x, vet2)
x3

#Listas
a <- list(1, "coxinha", matrix(16, 4, 4))
a

## Data Frame
nome <- c("Ana", "Bianca", "Carlos", "Maria")
idade <- c(22, 30, 43, 50)
sexo <- c("F", "F", "M", "F")
peso <- c(48, 60, 82, 65)
altura <- c(1.70, 1.82, 1.75, 1.60)

pessoas <- data.frame(nome, idade, sexo, peso, altura)
pessoas

#Acessando objetos dentro do dataframe
(pessoas$nome)
(pessoas$peso)

## Medidas descritivas
str(pessoas)
mean(pessoas$altura)
sd(pessoas$altura)
summary(pessoas$altura)


##Importação de dados
dados <- read.csv(file = "MICRODADOS.csv", sep = ";")

##Instalando pacotes
install.packages("cbinom")
library(dplyr)


##Funções úteis
View(dados)
dim(dados)
head(dados)
names(dados)
dados_mulheres <- filter(dados, Sexo == "F")
head(dados_mulheres)
dados$Sexo <- factor(dados$Sexo, levels = c("F","M","I"), labels = c("Feminino", "Masculino", "Ignorados"))
table(dados$Sexo)

##Gráficos
barplot(peso, names.arg = nome)

barplot(peso, names.arg = nome,
        xlab = "Pessoas", ylab = "Peso",
        main = "Peso das pessoas", 
        col = c("pink", "magenta", "purple"))


##Ajuda
help(mean)













