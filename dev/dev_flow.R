library(devtools)
devtools::document()
devtools::install(quick = TRUE)

system("yarn install")
system("yarn run webpack")
