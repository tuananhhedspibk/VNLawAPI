Searchkick.client = Elasticsearch::Client.new(hosts: ["localhost:9300"], retry_on_failure: true, transport_options: {request: {timeout: 250}})