require 'socket'
require 'natto'

DIC_DIR = 'C:\\mecab-unidic-neologd'.freeze
OUTPUT_FORMAT_TYPE = ''.freeze
NODE_FORMAT = '%f[6]'.freeze
UNK_FORMAT = '%m'.freeze
EOS_FORMAT = ''.freeze
LOG_FILE = 'mecab-service.log'.freeze
PORT = 24343

begin
  require 'win32/daemon'
  include Win32

  class NattoMeCabService < Daemon
    def service_init
      File.open(LOG_FILE, 'a') { |f| f.puts "Initializing service #{Time.now}" }
      @tagger = Natto::MeCab.new(
        dicdir: DIC_DIR,
        output_format_type: OUTPUT_FORMAT_TYPE,
        node_format: NODE_FORMAT,
        unk_format: UNK_FORMAT,
        eos_format: EOS_FORMAT)
      @server = TCPServer.new(PORT)
      File.open(LOG_FILE, 'a') { |f| f.puts "Listening on port #{PORT}... #{Time.now}" }
      sleep 1
    end

    def service_main
      File.open(LOG_FILE, 'a') { |f| f.puts "Service is running #{Time.now}" }
      while running?
        Thread.start(@server.accept) do |sock|
          begin
            while str = sock.gets.chomp
              yomi = @tagger.parse(str)
              sock.puts yomi
            end
            sock.close
          rescue Errno::ECONNRESET
            File.open(LOG_FILE, 'a') { |f| f.puts "Connection reset #{Time.now}" }
          end
        end
      end
    end

    def service_stop
      File.open(LOG_FILE, 'a') { |f| f.puts "Stopping server thread #{Time.now}" }
      @server.close
      File.open(LOG_FILE, 'a') { |f| f.puts "Service stopped #{Time.now}" }
    end
  end

  NattoMeCabService.mainloop

rescue Exception => e
  File.open(LOG_FILE, 'a+') do |f|
     f.puts "***Daemon failure #{Time.now} exception=#{e.inspect}"
     f.puts "#{e.backtrace.join($INPUT_RECORD_SEPARATOR)}"
  end
  raise
end
