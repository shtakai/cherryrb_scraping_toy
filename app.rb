require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
require 'eventmachine'
require 'benchmark'

benchmark_result = Benchmark.realtime do
  EM.run do
    get_url_list_operation = proc do

      host = 'http://rubykaigi.org'
      path = '/2016/schedule/'
      url = host + path

      url_list = []
      open(url) do |f|
        doc = Nokogiri::HTML(f.read)
        doc.css('table a').each do |a|
          url_list << host + a['href']
        end
      end
      url_list

    end

    get_url_list_operation_callback = proc do |url_list|
      EM.run do


        url_list.each_with_index do |url, index|

          get_parmalink_page_operation = proc do
            p url
            doc = Nokogiri::HTML
            open(url) do |f|
              doc = Nokogiri::HTML(f.read)
            end
            doc
          end

          get_parmalink_page_operation_callback = proc do |doc|

            doc.css('.section p').each do |g|
              p g.text
            end

            if url_list.size - 1 == index
              EM.stop
            end
          end

          EM.defer(get_parmalink_page_operation, get_parmalink_page_operation_callback)
        end

      end

    end

    EM.defer(get_url_list_operation, get_url_list_operation_callback)
  end

end

puts "benchmark: #{benchmark_result}"
