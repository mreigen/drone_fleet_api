Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    # :api_extension_type => :json
    # the output location where your .json files are written to
    :api_file_path => "public",
    # the URL base path to your API
    # hack with localhost env and ip
    :base_path => ENV['LOCALHOST'] == "true" ? "http://localhost:2001/" : "http://74.207.247.126:3001/",
    # if you want to delete all .json files at each generation
    :clean_directory => true,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "Airware mock API",
        "description" => "I'd like to fantasize on the idea of having an API that connects data from drones' telemetry with projects, flights and clients. Also I want to play around with the idea of streaming video through HTTP API, and upload/download to/from S3 :)",
        "termsOfServiceUrl" => "http://minhreigen.com/",
        "contact" => "mreigen@gmail.com",
        "license" => "Free",
        "licenseUrl" => "http://minhreigen.com"
      }
    }
  }
})