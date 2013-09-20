require 'artoo'

connection :capture, :adaptor => :opencv_capture
device :capture, :driver => :opencv_capture, :connection => :capture, :interval => 0.01

connection :video, :adaptor => :opencv_window
device :video, :driver => :opencv_window, :connection => :video, :title => "Video", :interval => 0.01

work do
  on capture, :frame => proc { |*value| 
    begin
      opencv = value[1]
      biggest_circle = 0
      ball = nil
      opencv.detect_circles({:r =>170, :g =>50, :b =>0}, {:r => 256, :g => 180, :b => 10}).each{ |circle|
        if circle.radius > biggest_circle
          biggest_circle = circle.radius
          ball = circle
        end
      }
      opencv.draw_circles!([ball]) if !ball.nil?
      video.image = opencv.image if video.alive?
    rescue Exception => e
      puts e.message
    end
  }
end
