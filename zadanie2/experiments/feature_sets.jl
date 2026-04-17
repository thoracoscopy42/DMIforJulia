function get_feature_sets()
    return Dict(
        "all_features" => [
            :experience_level,
            :employment_type,
            :company_size,
            :continents,
            :job_titles,
            :remote_type
        ],

        "without_location" => [
            :experience_level,
            :employment_type,
            :company_size,
            :job_titles,
            :remote_type
        ],

        "without_job_title" => [
            :experience_level,
            :employment_type,
            :company_size,
            :continents,
            :remote_type
        ],

        "core_only" => [
            :experience_level,
            :employment_type,
            :company_size
        ],

        "role_and_seniority" => [
            :experience_level,
            :employment_type,
            :job_titles
        ]
    )
end