require 'aws-sdk'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new
labels = ""
count = 0

Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new('AKIAJVU5FURWWWSXK3GA', '9gk3UmIaRgsiPUEvM6hOnP7zGchu19muJlJn5/uH')
})

scheduler.every '20s' do
  begin
    rekognition = Aws::Rekognition::Client.new(region: Aws.config[:region], credentials: Aws.config[:credentials])
    if count >= 7
      count = 0
    end
    img = File.read("./assets/images/foto#{count}.jpg")
    # puts "foto#{count}"

    resp = rekognition.detect_faces({
      image: {
        bytes: img
      },
      attributes: ["ALL"],
    })
    count+=1

    resp = rekognition.detect_labels(
      image: {
        bytes: img
      }
    )

    datos = Hash.new({ value: 0 })

    name = Array.new
    num = Array.new
    resp.labels.each do |lb|
      # puts "#{lb.name} #{lb.confidence.to_i}"
      name.push("#{lb.name}")
      num.push("#{lb.confidence.to_i}")
    end
  data = [
    {
      label: 'First dataset',
      data: num,
      backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * labels.length,
      borderColor: [ 'rgba(255, 99, 132, 1)' ] * labels.length,
      borderWidth: 1,
    }, {
      label: 'Second dataset',
      data: num,
      backgroundColor: [ 'rgba(255, 206, 86, 0.2)' ] * labels.length,
      borderColor: [ 'rgba(255, 206, 86, 1)' ] * labels.length,
      borderWidth: 1,
    }
  ]
  options = { }

  send_event('linechart2', { labels: name, datasets: data, options: options })
  rescue Aws::Rekognition::Errors::ServiceError => e
      puts e.message
  end
end
