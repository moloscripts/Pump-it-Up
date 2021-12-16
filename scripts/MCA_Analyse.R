library(FactoMineR)
library(factoextra)
data("housetasks")

# Subset for MCA
TzWp_Cat <- training %>%
  select(basin, region, construction_year,scheme_management,permit,public_meeting,extraction_type_class,management_group,payment_type, quality_group, quantity,
         waterpoint_type_group,source_type, source_class,waterpoint_type_group, status_group)

# convert to factors
to_factor <- c("region", "basin","extraction_type_class", "management_group", "payment_type", "quality_group", "scheme_management", "permit", "quantity",
               "public_meeting","waterpoint_type_group", "source_type", "source_class", "waterpoint_type_group","status_group")
for(col in to_factor){
  TzWp_Cat[[col]] <- as.factor(as.character(TzWp_Cat[[col]]))
}
TzWp_Cat$construction_year <- as.factor(TzWp_Cat$construction_year)

inspect_types(TzWp_Cat) %>%
  show_plot()

# Contigency table per region
status_per_region <- table(TzWp_Cat$region, TzWp_Cat$status_group)
region.ca <- CA(status_per_region, graph = FALSE)
get_ca_row(region.ca)
get_ca_col(region.ca)

fviz_ca_biplot(region.ca, repel = TRUE)
fviz_ca_row(region.ca, repel = TRUE)
fviz_ca_col(region.ca, repel = TRUE)


