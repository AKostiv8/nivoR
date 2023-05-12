world_countries_json <- jsonlite::toJSON(jsonlite::fromJSON('dev/world_countries.json'))
usethis::use_data(world_countries_json)
