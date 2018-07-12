#!/usr/bin/env ruby
require 'csv'
require 'digest'

# Problem
# Package
# File
# Priority
# Line
# Description
# Rule set
# Rule
FILE_COLUMN = 2
LINE_COLUMN = 4
DESCRIPTION_COLUMN = 5
RULE_COLUMN = 7

def get_file(path)
  @files||={}
  return @files[path] if @files[path]
  @files[path] = File.read(path).split("\n")
  return @files[path]
end

def mark_false(path, line_number, issue, comment, code_line_verify = nil)
  line = get_file(path)[line_number - 1]
  return false if line.nil?
  line = line.strip
  return false if line == ''
  hashed_line = get_hashed_line(line)
  if code_line_verify && (code_line_verify.strip != hashed_line)
    return false
  end
  line_hash = get_line_hash(issue, hashed_line)
  false_positive = "/*#{line_hash}:#{comment}*/"
  @files[path][line_number - 1] = "#{@files[path][line_number - 1]} #{false_positive}"
  true
end

def get_hashed_line(line)
  line.split(/\/[*][0-9a-z]{16}/)[0].strip
end

def get_false_positive_info(line, line_hash)
  match = line.match(/\/[*]#{line_hash}::?([^*]*)[*]\//)
  return nil unless match
  match[1]
end

def parse_pmd_row(record)
  path = record[FILE_COLUMN]
  issue_type = record[DESCRIPTION_COLUMN]
  line_number = record[LINE_COLUMN].to_i
  line = get_file(path)[line_number - 1].strip
  [path, issue_type, line_number, line]
end

def get_line_hash(issue_type, hashed_line)
  Digest::SHA256.hexdigest "#{issue_type}::#{hashed_line}"
end

def main
  generate_report = !(ARGV.detect {|x| x == '--report'}).nil?
  issues = 0
  header = nil
  CSV($stdin) do |csv_in|
    csv_in.each do |record|
      if header.nil?

        header = record
        puts CSV.generate_line(['File','Line','Code','Issue','Response'])
      else
        path, issue_type, line_number, line = parse_pmd_row(record)
        hashed_line = get_hashed_line(line)
        line_hash = get_line_hash(issue_type, hashed_line)
        false_positive = get_false_positive_info(line, line_hash)
        is_issue = false_positive.nil?
        issues += 1 if is_issue
        row = [path, line_number, hashed_line, issue_type, false_positive, line_hash]
        puts CSV.generate_line(row,{:force_quotes=>true}) if (generate_report || is_issue)
      end
    end
  end
  puts "Issues: #{issues}"
  exit 1 unless issues == 0
end

main
