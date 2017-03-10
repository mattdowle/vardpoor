
vardannual <- function(Y, H, PSU, w_final,
                       ID_level1, ID_level2,
                       Dom = NULL, Z = NULL,
                       country = NULL, years,
                       subperiods, dataset = NULL,
                       year1, year2, X = NULL,
                       countryX = NULL, yearsX = NULL,
                       subperiodsX = NULL, X_ID_level1 = NULL,
                       ind_gr = NULL, g = NULL, q = NULL,
                       datasetX = NULL, percentratio = 1,
                       use.estVar = FALSE, use.gender = FALSE,
                       confidence = 0.95, method = "netchanges") {

  ### Checking
  outp_res <- FALSE
  method <- check_var(vars = method, varn = "method", varntype = "method") 
  percentratio <- check_var(vars = percentratio, varn = "percentratio", varntype = "pinteger")  
  use.estVar <- check_var(vars = use.estVar, varn = "use.estVar", varntype = "logical")
  use.gender <- check_var(vars = use.gender, varn = "use.gender", varntype = "logical")
  confidence <- check_var(vars = confidence, varn = "confidence", varntype = "numeric01")

  if(!is.null(X)) {
         if (is.null(datasetX)) datasetX <- copy(dataset)
         equal_dataset <- identical(dataset, datasetX) & !is.null(dataset)
         if (equal_dataset) { X_ID_level1 <- ID_level1
                              countryX <- country }}

  Y <- check_var(vars = Y, varn = "Y", dataset = dataset,
                 check.names = TRUE, isnumeric = TRUE, grepls = "__")
  Ynrow <- nrow(Y)
  Yncol <- ncol(Y)
  
  H <- check_var(vars = H, varn = "H", dataset = dataset,
                 ncols = 1, Ynrow = Ynrow, ischaracter = TRUE,
                 dif_name = "dataH_stratas")
  
  w_final <- check_var(vars = w_final, varn = "w_final",
                       dataset = dataset, ncols = 1, Ynrow = Ynrow,
                       isnumeric = TRUE, isvector = TRUE)
  
  Z <- check_var(vars = Z, varn = "Z", dataset = dataset,
                 check.names = TRUE, Yncol = Yncol, Ynrow = Ynrow,
                 isnumeric = TRUE, mustbedefined = FALSE)
  namesZ <- names(Z)
  
  Dom <- check_var(vars = Dom, varn = "Dom", dataset = dataset,
                   ncols = 0, Yncol = 0, Ynrow = Ynrow,
                   ischaracter = TRUE, mustbedefined = FALSE,
                   duplicatednames = TRUE, grepls = "__")
  
  country <- check_var(vars = country, varn = "country",
                       dataset = dataset, ncols = 1, Ynrow = Ynrow,
                       ischaracter = TRUE, mustbedefined = FALSE,
                       dif_name = c("percoun", "period_country"))
  
  years <- check_var(vars = years, varn = "years", dataset = dataset,
                     ncols = 1, Yncol = 0, Ynrow = Ynrow, ischaracter = TRUE,
                     dif_name = c("percoun", "period_country", names(country), "yearg"),
                     use.gender = use.gender)
  yearg <- NULL
  years[, yearg := substr(get(names(years)), 1, nchar(get(names(years))) - ifelse(use.gender, 2, 0))]
  yearm <- names(years)[1 + use.gender]
  
  if (method != "cros") {
            year1 <- check_var(vars = year1, varn = "year1", dataset = NULL, ncols = 1,
                               ischaracter = TRUE, years = years[, 1 + use.gender, with = FALSE])

            year2 <- check_var(vars = year2, varn = "year2", dataset = NULL,  ncols = 1, 
                               ischaracter = TRUE, years = years[, 1 + use.gender, with = FALSE])
         } else { if (!missing(year1)) if (!is.null(year1)) stop("'year1' must be NULL")
                  if (!missing(year2)) if (!is.null(year2)) stop("'year2' must be NULL")
                  year1 <- years[, .N, by = yearm][, N := NULL]
                  year2 <- years[, .N, by = yearm][, N := NULL] }

  subperiods <- check_var(vars = subperiods, varn = "subperiods",
                          dataset = dataset, ncols = 1, Ynrow = Ynrow,
                          ischaracter = TRUE, dif_name = c("percoun", names(country)))
  subpm <- names(subperiods)
  subn <- data.table(years, subperiods)
  subn <- nrow(subn[, .N, by = names(subn)]) / length(unique(subn[["yearg"]]))
  
  ID_level1 <- check_var(vars = ID_level1, varn = "ID_level1",
                         dataset = dataset, ncols = 1, Ynrow = Ynrow,
                         ischaracter = TRUE)
  
  ID_level2 <- check_var(vars = ID_level2, varn = "ID_level2",
                         dataset = dataset, ncols = 1, Ynrow = Ynrow,
                         ischaracter = TRUE, namesID1 = names(ID_level1),
                         country = country, years = years, periods = subperiods)
  
  PSU <- check_var(vars = PSU, varn = "PSU", dataset = dataset,
                   ncols = 1, Ynrow = Ynrow, ischaracter = TRUE,
                   namesID1 = names(ID_level1))

  if(!is.null(X)) {
         X <- check_var(vars = X, varn = "X", dataset = datasetX,
                        isnumeric = TRUE, grepls = "__",
                        dif_name = c(names(years), names(subperiods),
                                     names(country), names(H), names(PSU),
                                     names(ID_level1), "w_final", names(Y),
                                     "w_design", "g", "q"))
         Xnrow <- nrow(X)

         ind_gr <- check_var(vars = ind_gr, varn = "ind_gr",
                             dataset = datasetX, ncols = 1,
                             Xnrow = Xnrow, ischaracter = TRUE,
                             dif_name = c(names(years), names(subperiods),
                                          names(country), names(H), names(PSU),
                                          names(ID_level1), "w_final", names(Y),
                                          names(X), "w_design", "g", "q"))
 
          g <- check_var(vars = g, varn = "g", dataset = datasetX,
                         ncols = 1, Xnrow = Xnrow, isnumeric = TRUE,
                         isvector = TRUE)

          q <- check_var(vars = q, varn = "q", dataset = datasetX,
                         ncols = 1, Xnrow = Xnrow, isnumeric = TRUE,
                         isvector = TRUE)

          countryX <- check_var(vars = countryX, varn = "countryX",
                                 dataset = datasetX, ncols = 1, Xnrow = Xnrow,
                                ischaracter = TRUE, mustbedefined = !is.null(country),
                                varnout = "country", varname = names(country),
                                country = country)
 
          yearsX <- check_var(vars = yearsX, varn = "yearsX", dataset = datasetX,
                              ncols = 1, Xnrow = Xnrow, ischaracter = TRUE,
                              mustbedefined = !is.null(years), varnout = "years",
                              varname = names(years)[1], country = country,
                              countryX = countryX, years = years[, 1, with = FALSE],
                              use.gender = use.gender)

          subperiodsX <- check_var(vars = subperiodsX, varn = "subperiodsX",
                                   dataset = datasetX, ncols = 1, Xnrow = Xnrow,
                                   ischaracter = TRUE, mustbedefined = !is.null(subperiods),
                                   varnout = "subperiods", varname = names(subperiods),
                                   country = country, countryX = countryX,
                                   years = years[, 1, with = FALSE],
                                   yearsX = yearsX, periods = subperiods)
 
          X_ID_level1 <- check_var(vars = X_ID_level1, varn = "X_ID_level1",
                                    dataset = datasetX, ncols = 1, Xnrow = Xnrow,
                                    ischaracter = TRUE, varnout = "ID_level1",
                                    varname = names(ID_level1), country = country,
                                    countryX = countryX, years = years[, 1, with = FALSE],
                                    yearsX = yearsX, periods = subperiods,
                                    periodsX = subperiodsX, ID_level1 = ID_level1)
                                    
         }
   dataset <- datasetX <- NULL

   ids <- nams <- cros_se <- num1 <- totalY <- totalZ <- NULL
   estim_1 <- estim_2 <- avar <- N <- estim <- NULL
   var_est2 <- se  <- CI_lower <- CI_upper <- NULL

   pers <- data.table(years, subperiods,
                      pers = paste0(years[[1]], "__", subperiods[[1]]))
   pers[, yearg := substr(get(names(years)), 1, nchar(get(names(years))) - ifelse(use.gender, 2, 0))]
 
   if (!is.null(X)) persX <- data.table(yearsX, subperiodsX,
                                  pers = paste0(yearsX[[names(yearsX)]], "__", subperiodsX[[names(subperiodsX)]]))

   sarak <- pers[,.N, keyby = names(pers)][, N := NULL]

   namesDom <- names(Dom)
   apst <- lapply(1 : nrow(year1), function(i) {
                 
                 
                 atsyear <- rbindlist(list(year1[i], year2[i]))
                 if (method == "cros") atsyear <- year1[i]
                 atsyear <- merge(atsyear, sarak, all.x = TRUE, by = yearm, sort = FALSE)

                 if (method == "cros") {  
                                 yr12 <- data.table(year1 = year1[i][[1]], year2 = year2[i][[1]])
                                 setnames(yr12, paste0("year", c(1, 2)), paste0(names(year1), c(1, 2)))
                              } else { yr12 <- year1[i]
                 atsyear[, ids := .I]

                 nr1 <- nrow(atsyear)
                 yrs <- rbindlist(lapply(1 : (nr1 - 1), function(j) {
                           atsy1 <- atsyear[j]
                           atsy2 <- atsyear[(j + 1) : nr1]
                           if (method == "cros") {
                                       atsy2[, (yearm) := NULL]
                                       setnames(atsy1, names(atsy1)[-1], paste0(names(atsy1)[-1], "_1"))
                                } else setnames(atsy1, names(atsy1), paste0(names(atsy1), "_1"))
                           setnames(atsy2, names(atsy2), paste0(names(atsy2), "_2"))
                           data.table(atsy1, atsy2)
                         }))
                 yrs[, ids := .I]

                 datas <- vardchanges(Y = Y, H = H, PSU = PSU, w_final = w_final,
                                      ID_level1 = ID_level1, ID_level2 = ID_level2,
                                      Dom = Dom, Z = Z, country = country,
                                      period = pers[, "pers"], dataset = NULL,
                                      period1 = yrs[, .(pers = get("pers_1"))],
                                      period2 = yrs[, .(pers = get("pers_2"))],
                                      X = X, countryX = countryX, periodX = persX[, "pers"],
                                      X_ID_level1 = X_ID_level1, ind_gr = ind_gr,
                                      g = g, q = q, datasetX = NULL, annual = TRUE,
                                      linratio = !is.null(Z), percentratio = percentratio,
                                      use.estVar = use.estVar, outp_res = outp_res,
                                      confidence = confidence, change_type = "absolute",
                                      checking = FALSE)

                 crossectional_results <- datas$crossectional_results
                 crossectional_results <- merge(sarak, crossectional_results, all.y = TRUE, by = "pers")

                 grad_var <- datas$grad_var
                 grad_var <- merge(yrs, grad_var, all.y = TRUE, by = c("pers_1", "pers_2"))

                 crossectional_var_grad <- datas$crossectional_var_grad
                 crossectional_var_grad <- merge(sarak, crossectional_var_grad,
                                                 all.y = TRUE, by = c("pers"))

                 var_tau <- datas$var_tau
                 var_tau <- merge(yrs, var_tau, all.y = TRUE, by = c("pers_1", "pers_2"))
                 setkeyv(var_tau, "ids")

                 vardchanges_results <- datas$changes_results
                 vardchanges_results <- merge(yrs, vardchanges_results, all.y = TRUE, by = c("pers_1", "pers_2"))
                 rho <- datas$rho
                 rho <- merge(yrs, rho, all.y = TRUE, by = c("pers_1", "pers_2"))
                 sar <- c("country", "namesY", "namesZ", namesDom)
                 sar <- sar[sar %in% names(rho)]
                 rhoj <- rho[,.N, keyby = sar][, N := NULL]

                 apstr <- lapply(1 : nrow(rhoj), function(j){

                               rho0 <- rhoj[j]
                               rho1 <- merge(rho0, rho, by = sar)[nams == "num2"]
                               A_matrix <- diag(1, nrow(atsyear), nrow(atsyear))

                               for (k in 1 : nrow(rho1)) {
                                     at <- rho1[k == ids]
                                     A_matrix[at[["ids_1"]], at[["ids_2"]]] <- at[["rho_num1"]]
                                     A_matrix[at[["ids_2"]], at[["ids_1"]]] <- at[["rho_num1"]]
                                     if (method != "cros") {
                                               if (at[["ids_2"]] > subn & at[["ids_1"]] < subn + 1) {
                                                              A_matrix[at[["ids_1"]], at[["ids_2"]]] <- - at[["rho_num1"]]
                                                              A_matrix[at[["ids_2"]], at[["ids_1"]]] <- - at[["rho_num1"]]
                                                             }}
                                   }
                               rho1 <- merge(rho0, crossectional_var_grad, by = sar)
                               rho1 <- merge(atsyear[, c("pers", "ids"), with = FALSE], rho1,
                                               by = "pers", sort = FALSE, allow.cartesian = TRUE)
                               rho1[, cros_se := sqrt(num1)]
                               X <- rho1[["cros_se"]]

                               annual_var <- data.table(rho0, yr12, 1 / (subn)^2 * (t(X) %*% A_matrix) %*% X)
                               setnames(annual_var, "V1", "var")

                               A_matrix <- data.table(rho0, yr12, cols = paste0("V", 1 : nrow(A_matrix)), A_matrix)
                               rho1[, ids := paste0("V", ids)]
                               setnames(rho1, "ids", "cols")
                               rho1 <- data.table(yr12, rho1)

                               list(rho1, A_matrix, annual_var)})

                 rho1 <- rbindlist(lapply(apstr, function(x) x[[1]]))
                 A_matrix <- rbindlist(lapply(apstr, function(x) x[[2]]))
                 annual_var <- rbindlist(lapply(apstr, function(x) x[[3]]))

print(annual_var)
print(names(yr12))
                 sars <- c(names(country), yearm, namesDom, "namesY", "namesZ")
                 sars <- sars[sars %in% names(crossectional_var_grad)]
                 sarsb <- sars[!(sars %in% yearm)]
                 sarc <- c("totalY", "totalZ")
print(sarsb)
                 sarc <- sarc[sarc %in% names(crossectional_var_grad)]
                 ysum <- crossectional_var_grad[, lapply(.SD, mean), by = sars, .SDcols = sarc]
                 if (!is.null(ysum$namesZ)) {
                              ysum[, estim := totalY / totalZ * percentratio]
                       } else ysum[, estim := totalY]

                 ysum1 <- ysum[get(yearm) == year1[i][[1]], c(sarsb, "estim"), with = FALSE]

                 if (method != "cros") {
                             ysum2 <- ysum[get(yearm) == year2[i][[1]], c(sarsb, "estim"), with = FALSE]
                             setnames(ysum1, "estim", "estim_1")
                             setnames(ysum2, "estim", "estim_2")
                             ysum1 <- data.table(yr12, merge(ysum1, ysum2, by = sarsb))
                             ysum1[, estim := estim_2 - estim_1]  }
         print(ysum1)

                 annual_results <- merge(ysum1, annual_var, by = c(sarsb, names(yr12)))

                 list(crossectional_results,
                      crossectional_var_grad, grad_var,
                      rho, var_tau, vardchanges_results,
                      rho1, A_matrix, annual_results, ysum)
   })

  crossectional_results <- rbindlist(lapply(apst, function(x) x[[1]]))
  crossectional_var_grad <- rbindlist(lapply(apst, function(x) x[[2]]))
  grad_var <- rbindlist(lapply(apst, function(x) x[[3]]))
  rho <- rbindlist(lapply(apst, function(x) x[[4]]))
  var_tau <- rbindlist(lapply(apst, function(x) x[[5]]))
  vardchanges_results <- rbindlist(lapply(apst, function(x) x[[6]]))

  X_annual <- rbindlist(lapply(apst, function(x) x[[7]]))
  A_matrix <- rbindlist(lapply(apst, function(x) x[[8]]))
  annual_results <- rbindlist(lapply(apst, function(x) x[[9]]))
  ysum <- rbindlist(lapply(apst, function(x) x[[10]]))

  crossectional_results[, pers := NULL]
  crossectional_var_grad[, pers := NULL]
  grad_var[, (c("pers_1", "pers_2", "ids_1", "ids_2", "ids")) := NULL]
  rho[, (c("pers_1", "pers_2", "ids_1", "ids_2", "ids")) := NULL]
  var_tau[, (c("pers_1", "pers_2", "ids_1", "ids_2", "ids")) := NULL]
  vardchanges_results[, (c("pers_1", "pers_2",
                           "ids_1", "ids_2", "ids")) := NULL]

  vars_all <- c(names(country), yearm, paste0(yearm, c(1, 2)),  
                namesDom, "namesY", "namesZ")
  vars <- c(vars_all, "cols", "cros_se")
  X_annual <- X_annual[, vars[vars %in% names(X_annual)], with = FALSE]

  vars <- c(vars_all, "cols", "cros_se")
  A_matrix <- A_matrix[, vars[vars %in% names(A_matrix)], with = FALSE]

  vars <- c(vars_all, "totalY", "totalZ", "estim")
  ysum <- ysum[, vars[vars %in% names(ysum)], with = FALSE]

  vars <- c(vars_all, paste0("estim_", c(1, 2)), "estim", "var") 
  annual_results <- annual_results[, vars[vars %in% names(annual_results)], with = FALSE]

  annual_results[, var_est2 := var]
  annual_results[xor(is.na(var_est2), var_est2 < 0), var_est2 := NA]
  annual_results[, se := sqrt(var_est2)]
  annual_results[, var_est2 := NULL]

  tsad <- qnorm(0.5 * (1 + confidence))
  annual_results[, CI_lower := estim - tsad * se]
  annual_results[, CI_upper := estim + tsad * se]

  significant <- NULL
  annual_results[, significant := TRUE]
  annual_results[CI_lower <= 0 & CI_upper >= 0, significant := FALSE]

  list(crossectional_results = crossectional_results,
       crossectional_var_grad = crossectional_var_grad,
       vardchanges_grad_var = grad_var,
       vardchanges_rho = rho,
       vardchanges_var_tau = var_tau,
       vardchanges_results = vardchanges_results,
       X_annual = X_annual, A_matrix = A_matrix,
       annual_sum = ysum,
       annual_results = annual_results)

}