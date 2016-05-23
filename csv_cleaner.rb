require 'smarter_csv'
load 'utils.rb'
load 'clean_line_breaks.rb'
load 'join_multiline_entries.rb'

def clean_csv_file(file_path)
  f   = join_multilines_csv_entries(File.open(file_path, "r"))
  ff  = clean_bad_line_breaks(File.open(f.path,"r"))
  fff = remove_empty_columns(File.open(ff.path,"r"))
end

def remove_empty_columns(messy_file)
  f = File.open("no_empty_columns.csv","w+")

  messy_first_line = messy_file.gets

  trailing_useless_columns_number =
    number_of_columns_from_line(messy_first_line) - columns_without_empty_trailing_ones_number(messy_first_line)

  f.puts delete_trailing_columns_added_by_google_spreadsheets(messy_first_line, trailing_useless_columns_number)

  #cleaned_first_line = remove_empty_columns_from_first_line(messy_first_line)
  #cleaned_file_col_num = number_of_columns_from_line(cleaned_first_line)

  #remove_colum

  messy_file.each do |messy_line|
    f.puts delete_trailing_columns_added_by_google_spreadsheets(messy_line, trailing_useless_columns_number)
  end

  f
end


# Fuck off empty columns
def columns_without_empty_trailing_ones_number(first_line)
  correct_split(first_line.chomp).reverse.drop_while{ |v| v == ""}.reverse.size
end

def delete_trailing_columns_added_by_google_spreadsheets(line, number_of_columns)
  correct_split(line).tap{ |l| l.pop(number_of_columns) }.join(',')
end