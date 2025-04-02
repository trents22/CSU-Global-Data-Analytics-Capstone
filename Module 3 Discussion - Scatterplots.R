install.packages("ggplot2")
library(ggplot2)

#Read in the dataset.
engine <- read.csv("C:/Users/trent/OneDrive/Desktop/CSU_Global/MIS581/Z_Data/engine_data.csv", header = TRUE)
engine <- engine[-c(2424, 15124), ]
engine$engine_condition <- as.factor(engine$engine_condition)

#Scatterplot: RPM vs Fuel Pressure
ggplot(engine, aes(x = rpm, y = fuel_pres, color = engine_condition)) +
  geom_point(size = 3, alpha = 0.7) +
  scale_color_manual(
    values = c("#1f77b4", "#ff7f0e"),
    labels = c("Faulty", "Normal"),
    name = "Engine Condition"
  ) +
  labs(title = "RPM and Fuel Pressure by Engine Condition",
       x = "RPM", y = "Fuel Pressure") +
  theme_minimal()

#Scatterplot: Coolant Pressure vs Coolant Temperature
ggplot(engine, aes(x = coolant_pres, y = coolant_temp, color = engine_condition)) +
  geom_point(size = 3, alpha = 0.7) +
  scale_color_manual(
    values = c("#1f77b4", "#ff7f0e"),
    labels = c("Faulty", "Normal"),
    name = "Engine Condition"
  ) +
  labs(title = "Coolant Pressure and Coolant Temperature by Engine Condition",
       x = "Coolant Pressure", y = "Coolant Temperature") +
  theme_minimal()

#Scatterplot: Oil Pressure vs Oil Temperature
ggplot(engine, aes(x = oil_pres, y = oil_temp, color = engine_condition)) +
  geom_point(size = 3, alpha = 0.7) +
  scale_color_manual(
    values = c("#1f77b4", "#ff7f0e"),
    labels = c("Faulty", "Normal"),
    name = "Engine Condition"
  ) +
  labs(title = "Oil Pressure and Oil Temperature by Engine Condition",
       x = "Oil Pressure", y = "Oil Temperature") +
  theme_minimal()

# Create the box plot for RPM
ggplot(engine, aes(x = engine_condition, y = rpm, fill = engine_condition)) +
  geom_boxplot() +
  scale_fill_manual(
    values = c("#1f77b4", "#ff7f0e"),
    labels = c("Faulty", "Normal"),
    name = "Engine Condition"
  ) +
  labs(title = "RPM by Engine Condition",
       x = "Engine Condition",
       y = "RPM") +
  theme_minimal()

# Create the box plot for Fuel Pressure
ggplot(engine, aes(x = engine_condition, y = fuel_pres, fill = engine_condition)) +
  geom_boxplot() +
  scale_fill_manual(
    values = c("#1f77b4", "#ff7f0e"),
    labels = c("Faulty", "Normal"),
    name = "Engine Condition"
  ) +
  labs(title = "Fuel Pressure by Engine Condition",
       x = "Engine Condition",
       y = "Fuel Pressure") +
  theme_minimal()

# Create the box plot for Coolant Pressure
ggplot(engine, aes(x = engine_condition, y = coolant_pres, fill = engine_condition)) +
  geom_boxplot() +
  scale_fill_manual(
    values = c("#1f77b4", "#ff7f0e"),
    labels = c("Faulty", "Normal"),
    name = "Engine Condition"
  ) +
  labs(title = "Coolant Pressure by Engine Condition",
       x = "Engine Condition",
       y = "Coolant Pressure") +
  theme_minimal()

# Create the box plot for Coolant Temperature
ggplot(engine, aes(x = engine_condition, y = coolant_temp, fill = engine_condition)) +
  geom_boxplot() +
  scale_fill_manual(
    values = c("#1f77b4", "#ff7f0e"),
    labels = c("Faulty", "Normal"),
    name = "Engine Condition"
  ) +
  labs(title = "Coolant Temperature by Engine Condition",
       x = "Engine Condition",
       y = "Coolant Temperature") +
  theme_minimal()

# Create the box plot for Oil Pressure
ggplot(engine, aes(x = engine_condition, y = oil_pres, fill = engine_condition)) +
  geom_boxplot() +
  scale_fill_manual(
    values = c("#1f77b4", "#ff7f0e"),
    labels = c("Faulty", "Normal"),
    name = "Engine Condition"
  ) +
  labs(title = "Oil Pressure by Engine Condition",
       x = "Engine Condition",
       y = "Oil Pressure") +
  theme_minimal()

# Create the box plot for Oil Temperature
ggplot(engine, aes(x = engine_condition, y = oil_temp, fill = engine_condition)) +
  geom_boxplot() +
  scale_fill_manual(
    values = c("#1f77b4", "#ff7f0e"),
    labels = c("Faulty", "Normal"),
    name = "Engine Condition"
  ) +
  labs(title = "Oil Temperature by Engine Condition",
       x = "Engine Condition",
       y = "Oil Temperature") +
  theme_minimal()