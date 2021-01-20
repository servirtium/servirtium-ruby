require 'servirtium'

# Hard code record for now, should be switchable between record and playback later.

Servirtium.example = 'compatibility_suite_recording.md'
Servirtium.interaction = 0
Servirtium.record = true
Servirtium.domain = 'https://todo-backend-sinatra.herokuapp.com/todos'

let!(:server) { class_double('Servirtium::DemoServer') }
servlet = Servirtium::ServirtiumServlet.new(server)