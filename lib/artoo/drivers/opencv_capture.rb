require 'artoo/drivers/driver'
require 'artoo/drivers/opencv'

module Artoo
  module Drivers
    # The opencv driver behaviors
    class OpencvCapture < Driver

      COMMANDS = [:opencv].freeze

      attr_accessor :opencv
      # Start driver and any required connections
      def start_driver
        begin
          every(interval) do
            handle_frame
          end
          super
        rescue Exception => e
          Logger.error "Error starting Opencv driver!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      def handle_frame
        if !connection.capture.nil?
          frame = connection.capture.query 
          if !frame.nil?
            @opencv = Artoo::Drivers::Opencv.new(frame)
            publish(event_topic_name("frame"), @opencv) 
          else
            connection.connect
          end
        else
          connection.connect
        end
      end
    end
  end
end
