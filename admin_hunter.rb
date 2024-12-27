require 'net/http'
require 'optparse'
#have a good day :⁠-⁠)
# Function to execute figlet command
def generate_figlet_text(text)
  `figlet #{text}` # Run the figlet command and return its output
end

# Banner Function
def print_banner
  # Generate and display the main title
  banner = generate_figlet_text("Admin Hunter")
  puts "\e[33m#{banner}\e[0m" # Yellow color for the banner

  # Display the subtitle
  puts "\e[36mby: Root@Spaghetti\e[0m" # Cyan color for the subtitle
  puts "\e[34m" + "=" * 50 + "\e[0m" # Blue separator line
end

# Call the banner function
print_banner

# Function for colored output
def color_text(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

# Parse options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby admin_finder.rb -w wordlist.txt -u http://example.com -o output.txt"

  opts.on("-w", "--wordlist FILE", "Path to the wordlist file (Default: admin.txt)") do |file|
    options[:wordlist] = file
  end

  opts.on("-u", "--url URL", "Target URL (required)") do |url|
    options[:url] = url
  end

  opts.on("-o", "--output FILE", "File to save results") do |output|
    options[:output] = output
  end
end.parse!

# Check required parameters
if options[:url].nil?
  puts color_text("Error: The -u parameter is required!", 31) # Red
  exit
end

# Check wordlist file
wordlist_file = options[:wordlist] || "admin.txt"
begin
  paths = File.readlines(wordlist_file).map(&:chomp)
rescue Errno::ENOENT
  puts color_text("Error: Wordlist file '#{wordlist_file}' not found!", 31) # Red
  exit
end

found_admin_panels = []

# Scan for admin panels
puts color_text("Scanning for admin panels...", 36) # Cyan
paths.each do |path|
  url = URI.join(options[:url], path)
  begin
    response = Net::HTTP.get_response(url)
    if response.code.to_i == 200
      puts color_text("[+] Admin panel found: #{url}", 32) # Green
      found_admin_panels << url.to_s
    else
      puts color_text("[-] Tried: #{url} - Status Code: #{response.code}", 33) # Yellow
    end
  rescue => e
    puts color_text("[!] Error: #{e.message}", 31) # Red
  end
end

# Save results
if options[:output]
  begin
    File.open(options[:output], "w") do |file|
      found_admin_panels.each { |panel| file.puts(panel) }
    end
    puts color_text("Results saved to '#{options[:output]}'", 32) # Green
  rescue => e
    puts color_text("Error saving results: #{e.message}", 31) # Red
  end
end

# Summary
#bye :⁠^⁠)
puts color_text("Total paths scanned: #{paths.size}", 36) # Cyan
puts color_text("Admin panels found: #{found_admin_panels.size}", 36) # Cyan