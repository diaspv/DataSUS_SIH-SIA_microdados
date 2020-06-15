# Download de arquivos públicos do SUS: atendimentos ambulatoriais (SIA/SUS) e
# internações hospitalares (SIH/SUS)
# Patrick Dias - github.com/diaspv

#Para executar este script no RGui: Arquivo >> Interpretar código fonte R... >> 
#Para executar este script no RStudio: <Ctrl> + <Shift> + <Enter>


if (!require("RCurl")) install.packages("RCurl")
if (!require("stringr")) install.packages("stringr")
library(RCurl)
library(stringr)

# Identificar as variáveis pré existentes no ambiente
var_exist <- ls()

#  Diretório dos arquivos de dados de internações e atendimentos ambulatoriais
SIH <- "ftp://ftp.datasus.gov.br/dissemin/publicos/SIHSUS/200801_/Dados/"
SIA <- "ftp://ftp.datasus.gov.br/dissemin/publicos/SIASUS/200801_/Dados/"

# Selecionar os arquivos de interesse e o diretório para salvamento
SIS <- select.list(c("SIA", "SIH"), title="Selecione o SIS", graphics = TRUE)
URL <- eval(parse(text = SIS))
SIH_DB <- c("RD", "SP", "RJ", "ER")
SIA_DB <- c("AB", "ABO", "ACF", "AD", "AM", "AN", "AQ", "AR", "ATD", "PA", "PS", "SAD")
DB <- select.list(eval(parse(text = paste0(SIS,"_DB"))), title="Selecione o Banco de Dados", graphics = TRUE)
UF <- select.list(c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"), title="Selecione o(s) estado(s):", graphics = TRUE, multiple=TRUE)
AA <- select.list(str_pad(seq(8, format(Sys.Date(), "%y")), 2, pad = "0"), title="Selecione o(s) ano(s):", graphics = TRUE, multiple=TRUE)
setwd(choose.dir(caption = "Selecione a pasta de destino"))

# Identifica todos os arquivos disponíveis para download no diretório escolhido
todos_arquivos <- getURL(URL, ftp.use.epsv = FALSE,dirlistonly = TRUE) 
todos_arquivos <- unlist(strsplit(todos_arquivos,'\r\n')) 


# Identificar todos os arquivos disponíveis no DataSUS compatíveis aos filtros aplicados
lista_baixar <- NULL
for (i in 1:length(UF)){
  for (j in 1:length(AA)){
    procurado <- paste0("^",DB,UF[i],AA[j],"..+dbc")
    lista <- grep(procurado,todos_arquivos, value=TRUE)
    lista_baixar <- c(lista_baixar, lista)
  }
}

# Baixar os arquivos de interesse
urls <- paste0(URL, lista_baixar)
for(k in seq_along(urls)){
  download.file(urls[k], lista_baixar[k], mode="wb")
  print(paste0(k,"/",length(urls)))
}

# Remover as variáveis criadas no ambiente
rm(list = setdiff(ls(), var_exist))
