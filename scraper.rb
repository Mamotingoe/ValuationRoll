require 'selenium-webdriver'
require 'csv'

# Set the township to "arena"
township = 'aldarapark'

# Create a new instance of the Selenium WebDriver using Chrome
driver = Selenium::WebDriver.for :chrome

begin
  # Specify the URL of the web page
  url = "https://objections.joburg.org.za/Objection/PropertyIndex/search/township?q=#{township}"

  # Navigate to the web page
  driver.get(url)

  # Locate and click the "Search" button
  search_button = driver.find_element(css: 'input[value="Search"]')
  search_button.click

  # Wait for the results to load (adjust the wait time as needed)
  wait = Selenium::WebDriver::Wait.new(timeout: 10)
  wait.until { driver.find_element(id: 'example_wrapper') }

  # Find the table with the ID 'example'
  table = driver.find_element(id: 'example')

  # Extract data from the table
  data = []
  rows = table.find_elements(tag_name: 'tr')
  rows.each do |row|
    columns = row.find_elements(tag_name: 'td').map(&:text)
    data << columns
  end

  # Define the path where you want to save the CSV file
  csv_file_path = 'output.csv'

  # Write the data to a CSV file
  CSV.open(csv_file_path, 'wb') do |csv|
    # Write the header row (column names) to the CSV file
    header_row = ['TOWNSHIP', 'ADDRESS', 'ERF', 'PTN', 'RE', 'CATEGORY', 'EXTENT', 'MARKET VALUE', 'SCHEME NAME', 'SCHEME NO.', 'SCHEME YEAR', 'UNIT NO.', 'REMARKS']
    csv << header_row

    # Write the data rows to the CSV file
    data.each do |row|
      csv << row
    end
  end

  puts "Data has been saved to #{csv_file_path}"

ensure
  # Close the browser
  driver.quit
end
