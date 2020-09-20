require_relative 'lib/servirtium/demo_server'
require_relative 'lib/servirtium/servirtium_servlet'

Servirtium.domain = "https://todo-backend-sinatra.herokuapp.com"
Servirtium.example = "todobackend_test_suite"
Servirtium.pretty_print = false
Servirtium.record = false
Servirtium.interaction = 0

Servirtium::DemoServer.new 61417

# TODO 1) localhost:61417 to  todo-backend-sinatra.herokuapp.com on the way down (and in recording)
# TODO 2) http://localhost:61417 to  https://todo-backend-sinatra.herokuapp.com on the way down (and in recording)
# TODO 3) todo-backend-sinatra.herokuapp.com to localhost:61417 on the way back
# TODO 4) https://todo-backend-sinatra.herokuapp.com to http://localhost:61417 on the way back
# TODO 5) cater for playback too.

# For 1-4, see https://github.com/servirtium/servirtium-javascript/blob/master/src/todobackend_compatibility_test.js and https://github.com/servirtium/servirtium-go/blob/master/cmd/todobackend_compatibility.go