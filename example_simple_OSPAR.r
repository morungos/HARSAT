# Intro ----

# This is a very simple example that assesses a small subset of the biota data
# used in the OSPAR 2022 CEMP assessment


# Setup ----

# Sources functions (folder functions) and reference tables (folder information)
# Only those functions needed for this example are sourced here
# The functions and reference tables folders are assumed to be in the current
# R project folder


rm(list = objects())

function_path <- file.path("functions")

source(file.path(function_path, "import_functions.R"))
source(file.path(function_path, "import_check_functions.R"))
source(file.path(function_path, "assessment_functions.R"))
source(file.path(function_path, "ctsm_lmm.R"))
source(file.path(function_path, "reporting_functions.R"))
source(file.path(function_path, "support_functions.R"))

# source reference tables and associated information functions

info_species_file_id <- "species_2020.csv"

info_AC_type <- "OSPAR"

info_AC_infile <- list(
  biota = "assessment criteria biota.csv",
  sediment = "assessment criteria sediment.csv",
  water = "assessment criteria water.csv"
)

info_determinand_infile <- "determinand_simple_OSPAR.csv"

source(file.path(function_path, "information_functions.R"))

# check if species values are within pre-defined range
# constants
min_value = 0L # min value for species values range check
max_value = 100L # max value for species values range check
species <- read.csv(file.path("information",info_species_file_id),header=TRUE,colClasses="character")
values_range_check_species(species, min_value, max_value)

# Read data from ICES extraction ----

# There are three input data sets: 
# - the contaminant data
# - the station dictionary
# - the quality assurance data (more accurately called a chemical methods file)

biota_data <- ctsm_read_data(
  compartment = "biota", 
  purpose = "OSPAR",                               
  contaminants = "test_data.txt", 
  stations = "station_dictionary.txt", 
  QA = "quality_assurance.txt",
  path = file.path("data", "example_simple_OSPAR"), 
  extraction = "2022/01/11",
  max_year = 2020L
)  


# Prepare data for next stage ----

# gets correct variable and streamlines some of the data files

biota_data <- ctsm_tidy_data(biota_data)


# Construct timeseries ----

# identifies groups of data that form a coherent timeseries
# also does a lot of data cleaning and processing (creates oddities folder)

# need a quick hack because some variables aren't present in simplified data

biota_data$data$subseries <- rep(NA_character_, nrow(biota_data$data))

biota_timeSeries <- ctsm_create_timeSeries(
  biota_data,
  determinands = c("CD", "CB153", "HBCD","HBCDA", "HBCDG", "PYR1OH"), 
  determinands.control = list(
    HBCD = list(det = c("HBCDA", "HBCDB", "HBCDG"), action = "sum"),
    "LIPIDWT%" = list(det = c("EXLIP%", "FATWT%"), action = "bespoke")
  ), 
  get_basis = get_basis_biota_OSPAR
)

# identical (apart from call) to: 
# 
# ctsm_create_timeSeries(
#   biota_data,
#   determinands = ctsm_get_determinands("biota"),
#   determinands.control = list(
#     HBCD = list(det = c("HBCDA", "HBCDB", "HBCDG"), action = "sum"),
#     "LIPIDWT%" = list(det = c("EXLIP%", "FATWT%"), action = "bespoke")
#   )
# )
# 
# ctsm_create_timeSeries(
#   biota_data,
#   determinands.control = list(
#     HBCD = list(det = c("HBCDA", "HBCDB", "HBCDG"), action = "sum"),
#     "LIPIDWT%" = list(det = c("EXLIP%", "FATWT%"), action = "bespoke")
#   )
# )


# Assessment ----

# do the statistical analysis

biota_assessment <- ctsm.assessment.setup(
  biota_timeSeries, 
  AC = c("BAC", "EAC", "EQS.OSPAR", "HQS"), 
  recent.trend = 20
)


biota_assessment$assessment <- ctsm.assessment(biota_assessment)


# check convergence - no errors this time

ctsm_check_convergence(biota_assessment$assessment)


# tidy up 

# make timeSeries factor levels more interpretable

biota_assessment$timeSeries <- biota_assessment$timeSeries %>% 
  rownames_to_column(".rownames") %>% 
  mutate(
    .matrix = ctsm_get_info("matrix", matrix, "name") %>% 
      str_to_sentence() %>% 
      recode(
        "Erythrocytes (red blood cells in vertebrates)" = "Red blood cells",
        "Egg homogenate of yolk and albumin" = "Egg yolk & albumin"
      ), 
    level6name = case_when(
      level6element %in% "matrix" ~ .matrix,
      level6element %in% "sex" ~ recode(level6name, "F" = "Female", "M" = "Male"),
      TRUE ~ level6name
    ),
    level7name = case_when(
      level7element %in% "matrix" ~ .matrix,
      level7element %in% "subseries" ~ gsub("_", " ", level7name),
      TRUE ~ level7name
    ),
    .matrix = NULL,
    level6element = recode(
      level6element, 
      matrix = "Tissue", 
      sex = "Sex", 
      "METOA" = "Chemical analysis"
    ),
    level7element = recode(
      level7element, 
      matrix = "Tissue", 
      subseries = "Mammal group"
    )
  ) %>% 
  column_to_rownames(".rownames")



# Summary files ----

# web objects: these are a legacy from a Flash app for displaying results

webGroups = list(
  levels = c("Metals", "Metabolites", "Organobromines", "Chlorobiphenyls"),  
  labels = c(
    "Metals", "PAH metabolites", "Organobromines",  "Polychlorinated biphenyls"
  )
)

biota_web <- ctsm_web_initialise(
  biota_assessment,
  classColour = list(
    below = c(
      "BAC" = "blue", 
      "EAC" = "green", 
      "EQS.OSPAR" = "green",
      "HQS" = "green"
    ),
    above = c(
      "BAC" = "orange", 
      "EAC" = "red", 
      "EQS.OSPAR" = "red",
      "HQS" = "red"
    ), 
    none = "black"
  ),
  determinandGroups = webGroups
)


# write summary table 
# can adjust file location with the path argument

ctsm_summary_table(
  assessments = list(Biota = biota_web), 
  determinandGroups = webGroups,
  path = file.path("output", "example_simple_OSPAR")
)


