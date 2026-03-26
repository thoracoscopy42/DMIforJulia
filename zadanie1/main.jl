using DataFrames
using CSV
using StatsBase
using CairoMakie

# SECTION - osobne pliki z funkcjami żeby poprawić czytelność kodu  
include("data_processing/loader.jl")
include("data_processing/extended_describe.jl")
include("data_processing/plotting.jl")
include("data_processing/preprocessing.jl")

# SECTION - ładujemy dane
df= load_file("SalariesInDataScience.csv")

# SECTION - rozszerzona wersja describe()
profile, size = profile_dataset(df)

# SECTION - wybór targetu 
# wybieramy kolumnę salary_in_usd jako nasz target -> typeof(df[!,:salary_in_usd]) <- zwróci nam typ Vector{Int64}

# SECTION - wstępne wykresy - zapis do pliku + wyświetlenie

# fig1 = plot_histogram(df, :salary_in_usd, bins=30)
# save("plots/_before/salary_histogram.svg", fig1)
# fig2 = plot_boxplot(df, :experience_level, :salary_in_usd, group_order = ["EN", "MI", "SE", "EX"])
# save("plots/_before/experience_vs_salary.svg", fig2)
# fig3 = plot_boxplot(df, :remote_ratio, :salary_in_usd, group_order = [0, 50, 100])
# save("plots/_before/remote_vs_salary.svg", fig3)

# display(fig1)
# display(fig2)
# display(fig3)

# SECTION - podział kolumn na numeryczne i kategoryczne
cols = split_columns_by_type(df)

# SECTION - do usunięcia typujemy poniższe kolumny z uwagi na redundancję danych 
cols_for_removal = [:salary, :salary_currency, :employee_residence]
drop_columns!(df, cols_for_removal)

# SECTION - używamy uprzednio przygotowanych słowników do konwersji kolumn kategorycznych na numeryczne
#           słowniki tworzone ad hoc wyeksportowaliśmy do pliku dictionaries.jl
include("dictionaries.jl")
countries = load_dict_from_csv("countries.csv")
job_titles = load_dict_from_csv("job_titles.csv")


# SECTION - ordinal encoding oraz one hot encoding
#           przed encodingiem - ["work_year", "experience_level", "employment_type", "job_title", "salary_in_usd", "remote_ratio", "company_location", "company_size"]
ordinal_encode!(df, :experience_level, experience)
ordinal_encode!(df, :company_location, countries)
ordinal_encode!(df, :employment_type, employment)
ordinal_encode!(df, :company_location, location)
ordinal_encode!(df, :company_size, company_size)
ordinal_encode!(df, :job_title, job_titles)
ordinal_encode!(df, :remote_ratio, remote)

df[!, :remote_ratio_plot] = copy(df[!, :remote_ratio]) # kopia kolumny do późniejszego wykresu 

one_hot_encode!(df, :job_title)
one_hot_encode!(df, :remote_ratio)
#           po encodingu - ["work_year", "experience_level", "employment_type", "salary_in_usd", "company_location", "company_size", 
#                           "job_title_Research & Science", "job_title_AI/Machine Learning", "job_title_Management & Leadership",
#                           "job_title_Data & Analytics", "job_title_Software Engineering", "job_title_Product Business & Strategy",
#                           "job_title_Data Engineering & Infrastructure", "job_title_Data Governance & Operations", 
#                           "remote_ratio_on_site", "remote_ratio_remote", "remote_ratio_hybrid"]


# SECTION - zaimplementowaliśmy imputację jako funkcję - impute_missing!(df),
#           jednakże missing stanowiły jedynie 1,5-2% obserwacji, zatem zdecydowaliśmy się na dropmissing!() by uniknąć szumu informacyjnego
# impute_missing!(df)
dropmissing!(df)

# SECTION - usuwanie rekordów z outlierami (metodą IQR), stanowiły one również około 1,5-2% obserwacji

outlier_candidates = [:salary_in_usd]
# outlier_mask  = detect_outliers_iqr(df, outlier_candidates) # funkcja pomocniczna, jedynie do sprawdzenia ilości outlierów
remove_outliers_iqr!(df, outlier_candidates)

# NOTE -            ostatecznie ze zbioru który początkowo miał około 94k rekordów zostało ich około 90k   

# SECTION - zdecydowaliśmy się dodać kolumnę ze zlogarytmowaną wartością salary_in_usd, 
#           z uwagi na wymogi zadania i brak innych kolumn pozwalających na sensowne przeprowadzenie standaryzacji/normalizacji/dyskretyzacji

add_log_column!(df, :salary_in_usd, :salary_log)

standardize_columns!(df, [:salary_in_usd, :salary_log])

# SECTION - wstępne wykresy po preprocessingu #FIXME - :DDDDDD

# fig_after_1 = plot_histogram(df, :salary_in_usd, bins=30)
# save("plots/after/salary_standardized_histogram.svg", fig_after_1)

# fig_after_2 = plot_histogram(df, :salary_log, bins=30)
# save("plots/after/salary_log_standardized_histogram.svg", fig_after_2)

# job_cols = filter(col -> startswith(String(col), "job_title_"), Symbol.(names(df)))
# job_counts = [sum(df[!, col]) for col in job_cols]
# job_labels = replace.(String.(job_cols), "job_title_" => "")

# fig_after_3 = Figure()
# ax = Axis(fig_after_3[1, 1], xticks=(1:length(job_labels), job_labels), xticklabelrotation=pi/4)
# barplot!(ax, 1:length(job_labels), job_counts)

# save("plots/after/job_title_onehot_counts.svg", fig_after_3)

# display(fig_after_1)
# display(fig_after_2)
# display(fig_after_3)

# fig_after_4 = plot_boxplot(
#     df,
#     :experience_level,
#     :salary_log,
#     group_order = sort(unique(df[!, :experience_level]))
# )

# save("plots/after/experience_vs_salary_log.svg", fig_after_4)

# SECTION - finalne wykresy po preprocessingu

# fig_final_1 = plot_histogram(df, :salary_in_usd, bins=30)
# save("plots/after/final/salary_standardized_histogram.svg", fig_final_1)


# fig_final_2 = plot_boxplot(
#     df,
#     :experience_level,
#     :salary_in_usd,
#     group_order = [1, 2, 3, 4]
# )
# save("plots/after/final/experience_vs_salary_standardized.svg", fig_final_2)


# fig_final_3 = plot_boxplot(
#     df,
#     :remote_ratio_plot,
#     :salary_in_usd,
#     group_order = ["on_site", "remote", "hybrid"]
# )
# save("plots/after/final/remote_vs_salary_standardized.svg", fig_final_3)


# job_cols = filter(col -> startswith(String(col), "job_title_"), Symbol.(names(df)))
# job_counts = [sum(df[!, col]) for col in job_cols]
# job_labels = replace.(String.(job_cols), "job_title_" => "")

# fig_final_4 = Figure()
# ax = Axis(
#     fig_final_4[1, 1],
#     xticks = (1:length(job_labels), job_labels),
#     xticklabelrotation = pi / 4
# )
# barplot!(ax, 1:length(job_labels), job_counts)

# save("plots/after/final/job_title_onehot_counts.svg", fig_final_4)

# display(fig_final_1)
# display(fig_final_2)
# display(fig_final_3)
# display(fig_final_4)