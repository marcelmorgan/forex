desc "build rates for missing traders"
task :build_expected_rates do
  require 'yaml'
  require 'vcr'
  require 'forex'

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/vcr'
    c.hook_into :webmock
  end

  Forex::Trader.all.each do |short_name, trader|
    expected_rates_file_path = "spec/rates/#{short_name.downcase}.yml"

    unless File.exists?(expected_rates_file_path)
      VCR.use_cassette(['traders', short_name].join('/')) do
        puts "Adding expected rates to #{expected_rates_file_path}"

        File.open(expected_rates_file_path, 'w') do |f|
          f.write(trader.fetch && trader.rates.to_yaml)
        end
      end
    end
  end

end


