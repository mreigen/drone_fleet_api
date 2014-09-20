Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    # :api_extension_type => :json
    # the output location where your .json files are written to
    :api_file_path => "public",
    # the URL base path to your API
    :base_path => "http://localhost:2001/",
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "Airware mock API",
        "description" => "I'd like to fantasize on the idea of having the API which connects data from drones' telemetry with projects and clients. Also I want to play around with the idea of streaming video through HTTP API :)",
        "termsOfServiceUrl" => "http://minhreigen.com/",
        "contact" => "mreigen@gmail.com",
        "license" => "Free",
        "licenseUrl" => "http://minhreigen.com"
      }
    }
  }
})