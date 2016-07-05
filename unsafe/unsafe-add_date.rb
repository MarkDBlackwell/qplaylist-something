# coding: utf-8
filename_out = 'var/recent-songs.txt'
message = "Output file '#{filename_out}' already exists; "\
          "please rename it before running this."
::Kernel.abort message if File.exists? filename_out

n = Time.now
year_month_day = Time.new(n.year, n.month, n.day).strftime '%4Y %2m %2d'

File.open "#{filename_out}-old-format", 'r' do |f_old|
  lines = f_old.readlines
  File.open filename_out, 'w' do |f_new|
    lines.each_slice(3) do |a|
      f_new.puts year_month_day
      f_new.print a.join ''
    end
  end
end

