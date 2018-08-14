require "graphql"
require "net/http"

### Our target—allow clients to query a test
#
# query {
#   test              <- Need to define a "test" field
# }
# => "Hello, world!"  <- Need to send a test response

# Actually, a GraphQL response will have a top level key called "data", under
# which we can find the data we requested. Notice that the JSON structure
# matches that of the query document.
# => {
#      "data": {
#        "test": "Hello, world!"
#      }
#    }


### Define Schema
# We could parse the GraphQL document ourselves, but why do that when there
# are perfectly good libraries which already exist? Here we define a GraphQL
# schema using the graphql gem.

# Root-level fields
class Query < GraphQL::Schema::Object
  # Add the "test" field with its type specification
  field :test, String, null: false, description: "Just testing things out."

  # Define a resolver for the "test" field
  def test(*args)
    "Hello, world!"
  end

  field :foo, String, null: false, description: "-bar? -fighters? -manchu?"

  # Some extra stuff just for fun
  def foo(*args)
    "Goodbye, cruel world! 😢"
  end

  field :crypto_price, String, null: true, description: "Returns the current market price for given product." do
    argument :product, String, required: true
  end

  def crypto_price(product:)
    api_endpoint = URI("https://api.pro.coinbase.com/products/#{ product }/ticker")
    response = Net::HTTP.get(api_endpoint)
    data = JSON.parse(response)
    data["price"]
  end
end

# Define the schema
class Schema < GraphQL::Schema
  # Add the root-level query object.
  query(Query)
  # This is also the place where will add mutations and subscriptions later.
end
