require 'uri'
require 'net/http'

uri = URI("http://localhost:3000/notifications?key=someKey")
#uri = URI("http://patologi-pasha.herokuapp.com/notifications?key=someKey")

request = Net::HTTP::Post.new(uri.path + "?" + uri.query)

request["Content-Type"] = 'application/json'

request.body = %!
{
  "status_code": "200",
  "status_message": "Veritrans payment notification",
  "transaction_id": "143c41c8-25cf-4abb-8358-50643c3edb03",
  "order_id": "32DRG500000002",
  "payment_type": "bca_klikbca",
  "transaction_time": "2015-10-07 16:15:09 +0700",
  "transaction_status": "settlement",
  "gross_amount": "839000.00",
  "signature_key": "8742da37a3bc7b202ea386c6c0243fbf235911399b475fd26a9d1f1606c01ca9099c9a01d4c9b44afa7dc8070a090613331a7ca37548703f7d03607261d87f5e"
}
!.strip

response = Net::HTTP.start(uri.host, uri.port) do |http|
  http.request(request)
end

puts response

