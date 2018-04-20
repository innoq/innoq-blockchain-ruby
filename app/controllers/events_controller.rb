class EventsController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    since = Time.now
    begin
      loop do
        new_since = Time.now
        events = Event.since(since)
        since = new_since
        if events.present?
          events.each do |ev|
            sse.write(ev.to_sse)
          end
        # else
        #   sse.write("\n")
        end
        sleep 1
      end
    rescue IOError
      logger.info 'Client disconnected'
    ensure
      sse.close
    end
  end


  class SSE
    def initialize(io)
      @io = io
    end

    def write(data)
      @io.write(data)
    end

    def close
      @io.close
    end
  end

end
