experience = Dict(
    "EN" => 1,
    "MI" => 2,
    "SE" => 3,
    "EX" => 4
)

experience_vector = ["EN","MI", "SE", "EX"]

employment = Dict(
    "FT" => 1,
    "CT" => 2,
    "PT" => 3,
    "FL" => 4
)

employment_vector = ["FT", "CT", "PT", "FL"]

company_size = Dict(
    "S" => 1,
    "M" => 2,
    "L" => 3
)

company_size_vector = ["S", "M", "L"]


location = Dict(
    "North America" => 1,
    "Europe"        => 1,

    "Asia"          => 2,
    "South America" => 2,

    "Oceania"       => 3,
    "Africa"        => 3,
)

location_vector = [ "North America", "Europe", "Asia", "South America", "Oceania", "Africa"]

remote = Dict(
    0               => "on_site",
    50              => "hybrid",
    100             => "remote"
)

remote_vector = ["on_site", "hybrid", "remote"]

job_titles_vector = ["AI/Machine Learning", "Research & Science",
                     "Management & Leadership", "Data & Analytics", 
                     "Software Engineering", "Product Business & Strategy",
                     "Data Engineering & Infrastructure", "Data Governance & Operations"]