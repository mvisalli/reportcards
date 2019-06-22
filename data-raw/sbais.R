#devtools::load_all()

sbais_ci <- tibble::tibble(
  txt = list.files("data-raw", "^AIS_.*\\.txt$", full.names = T, recursive = T)) %>%
  dplyr::mutate(
    # note use of custom read_ais_txt() function applied to each *.txt file
    data = purrr::map(txt, shipr::read_ais_txt)) %>%
  dplyr::select(-txt) %>%
  tidyr::unnest(data) %>%
  dplyr::arrange(datetime, name) %>%
  filter(mmsi == 309933000)

readr::write_csv(sbais_ci, "data-raw/sbais_ci.csv")
saveRDS(sbais_ci, "data/sbais_ci.RDS")

sbais062019 <- tibble::tibble(
  txt = list.files("data-raw", "^AIS_.*\\.txt$", full.names = T, recursive = T)) %>%
  dplyr::mutate(
    # note use of custom read_ais_txt() function applied to each *.txt file
    data = purrr::map(txt, shipr::read_ais_txt)) %>%
  dplyr::select(-txt) %>%
  tidyr::unnest(data) %>%
  dplyr::arrange(datetime, name)

readr::write_csv(sbais062019, "data-raw/sbais062019.csv")
saveRDS(sbais062019, "data/sbais062019.RDS")
