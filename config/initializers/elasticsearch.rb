Searchkick.client = Elasticsearch::Client.new(hosts: ["lkbc-elastic-1"],
  retry_on_failure: true, transport_options: {request: {timeout: 300}})
