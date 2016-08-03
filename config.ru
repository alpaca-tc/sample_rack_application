class ContentLength
  def initialize(app)
    @app = app
  end

  def call(env)
    response = @app.call(env)

    status, headers, body = response

    content_length = body.inject(0) { |sum, part| sum + part.bytesize }
    headers['Content-Length'] = content_length.to_s

    [status, headers, body]
  end
end

class SampleApplication
  def self.call(env)
    body = if env['REQUEST_METHOD'] == 'GET'
             'HTTP METHOD IS GET'
           else
             'HTTP METHOD IS Unknown'
           end

    [200, { 'Content-Type' => 'text/plain', 'Content-Length' => body.bytesize.to_s }, [body]]
  end
end

use ContentLength
run ContentLength.new(SampleApplication)
